import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pawlly/components/button_default_widget.dart';
import 'package:pawlly/components/custom_alert_dialog_widget.dart';
import 'package:pawlly/modules/integracion/controller/notificaciones/notificaciones_controller.dart';
import 'package:pawlly/modules/integracion/model/notigicaciones/notificaciones.dart';
import 'package:pawlly/modules/notification/controllers/notification_controller.dart';
import 'package:pawlly/modules/notification/screens/widgets/app_bar_notifications.dart';
import 'package:pawlly/styles/styles.dart';

class NotificationsScreen extends StatelessWidget {
  final NotificationsController controller = Get.put(NotificationsController());
  final NotificationController notificationController =
      Get.find<NotificationController>();

  NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    controller.loadNotifications();

    return Scaffold(
      appBar: AppBarNotifications(),
      body: Container(
        width: width,
        height: height,
        color: Styles.whiteColor,
        child: Obx(
          () => ListView(
            children: [
              _buildSectionTitle('Hoy'),
              _buildNotificationList(
                  notificationController.getTodayNotifications(),
                  showTime: true),
              notificationController.getYesterdayNotifications().isNotEmpty
                  ? _buildSectionTitle('Ayer')
                  : Container(),
              _buildNotificationList(
                  notificationController.getYesterdayNotifications(),
                  showTime: true),
              const Divider(
                thickness: .1,
                color: Colors.black,
              ),
              notificationController.getOlderNotifications().isNotEmpty
                  ? _buildSectionTitle('Anteriores')
                  : Container(),
              _buildNotificationList(
                  notificationController.getOlderNotifications(),
                  showTime: true),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center, // Centra el Row
            children: [
              Align(
                alignment: Alignment.center,
                child: Container(
                  decoration: BoxDecoration(
                    color: title == "Hoy" ? Colors.orange : Styles.fiveColor,
                    borderRadius: BorderRadius.circular(32),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Center(
                    child: Text(
                      title,
                      style: TextStyle(
                        color: title == "Hoy"
                            ? Colors.white
                            : Styles.iconColorBack,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Lato',
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationList(List<NotificationData> notifications,
      {required bool showTime}) {
    // ignore: unused_local_variable
    NotificationController controller = Get.put(NotificationController());
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        final notification = notifications[index];
        return GestureDetector(
          onTap: () {
            // Mostrar el detalle de la notificación
            notification.isRead == 0
                ? controller.updateNotification(notification.id)
                : null;

            _showNotificationDetails(context, notification);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 12),
            width:
                double.infinity, // Asegurar que ocupe todo el ancho disponible
            //margin: const EdgeInsets.symmetric(vertical: 1.0), //margen notificaciones
            decoration: BoxDecoration(
              color: notification.isRead == 0
                  ? Styles.whiteColor
                  : Styles.fiveColor,
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30, // Aumenta el tamaño de la imagen
                  backgroundImage: const NetworkImage(
                      'https://via.placeholder.com/150'), // URL por defecto
                  backgroundColor: Colors.transparent,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Styles.iconColorBack, // Color del borde
                        width: 1.0, // Grosor del borde
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notification.title ?? '',
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Lato',
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            notification.type ?? '',
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Lato',
                              fontSize: 14,
                              color: Styles.primaryColor,
                            ),
                          ),
                          Text(
                            showTime
                                ? DateFormat('HH:mm').format(
                                    DateTime.parse(notification.createdAt!))
                                : DateFormat('dd MMM').format(
                                    DateTime.parse(notification.createdAt!)),
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Lato',
                              fontSize: 12,
                              color: Styles.greyTextColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Método para mostrar el detalle de la notificación en un modal
  void _showNotificationDetails(
      BuildContext context, NotificationData notification) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      isScrollControlled: true, // Permite que el contenido sea scrollable
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize:
              0.8, // Altura inicial del modal (50% de la pantalla)
          minChildSize: 0.3, // Altura mínima al deslizar hacia abajo
          maxChildSize: 0.9, // Altura máxima al deslizar hacia arriba
          expand: false,
          builder: (_, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Línea decorativa del modal
                    Center(
                      child: Container(
                        width: 40,
                        height: 5,
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Styles.primaryColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        textAlign: TextAlign.center,
                        notification.type ?? 'Sin descripción',
                        style: Styles.welcomeTitle,
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Text(
                      'Tipo: ${notification.type ?? 'Desconocido'}',
                      style: const TextStyle(
                        fontFamily: 'Lato',
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    const Text(
                      'Descripción:',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Styles.primaryColor,
                        fontSize: 16,
                        fontFamily: 'Lato',
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      notification.description ?? '',
                      style: const TextStyle(
                        fontSize: 15,
                        fontFamily: 'Lato',
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Text(
                      'Fecha: ${DateFormat('dd MMM yyyy HH:mm').format(DateTime.parse(notification.createdAt!))}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                        fontSize: 14,
                        fontFamily: 'Lato',
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Text(
                      'Leída: ${notification.isRead}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Lato',
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 24.0),
                    if (notification.type == 'medico' ||
                        notification.type == "entrenamiento")
                      Row(
                        children: [
                          if (notification.status == "pending")
                            Expanded(
                              child: ButtonDefaultWidget(
                                  title: 'Aceptar',
                                  callback: () {
                                    Navigator.of(context).pop();
                                    Get.dialog(
                                      CustomAlertDialog(
                                        icon: Icons.confirmation_num,
                                        title: 'Confirmación',
                                        description:
                                            '¿Deseas rechazar el evento?',
                                        primaryButtonText: 'Continuar',
                                        secondaryButtonText: 'Cancelar',
                                        onPrimaryButtonPressed: () {
                                          notificationController.acceptBooking(
                                              notification.eventId ?? "-1",
                                              context);
                                          Get.back();
                                        },
                                      ),
                                      barrierDismissible: true,
                                    );
                                  }),
                            ),
                          const SizedBox(width: 8.0),
                          if (notification.status == "pending")
                            Expanded(
                              child: ButtonDefaultWidget(
                                  title: 'Rechazar',
                                  callback: () {
                                    Navigator.of(context).pop();
                                    Get.dialog(
                                      CustomAlertDialog(
                                        icon: Icons.confirmation_num,
                                        title: 'Confirmación',
                                        description:
                                            '¿Deseas aceptar el evento?',
                                        primaryButtonText: 'Continuar',
                                        secondaryButtonText: 'Cancelar',
                                        onPrimaryButtonPressed: () {
                                          notificationController
                                              .rechazarReserva(
                                            notification.eventId ?? "-1",
                                            context,
                                          );
                                          Get.back();
                                        },
                                      ),
                                      barrierDismissible: true,
                                    );
                                  }),
                            ),
                          const SizedBox(width: 8.0),
                        ],
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
