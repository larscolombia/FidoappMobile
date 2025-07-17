import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pawlly/components/button_default_widget.dart';
import 'package:pawlly/components/custom_alert_dialog_widget.dart';
import 'package:pawlly/modules/integracion/controller/notificaciones/notificaciones_controller.dart';
import 'package:pawlly/modules/integracion/model/notigicaciones/notificaciones.dart';
import 'package:pawlly/modules/notification/controllers/notification_controller.dart';
import 'package:pawlly/modules/notification/screens/widgets/app_bar_notifications.dart';
import 'package:pawlly/modules/provider/push_provider.dart';
import 'package:pawlly/services/auth_service_apis.dart';
import 'package:pawlly/styles/styles.dart';

class NotificationsScreen extends StatelessWidget {
  final NotificationsController controller = Get.put(NotificationsController());
  final NotificationController notificationController = Get.find<NotificationController>();
  final PushProvider tokenDevice = Get.put(PushProvider());
  NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;
    controller.loadNotifications();
    tokenDevice.verificarDeviceToken();
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
              _buildNotificationList(notificationController.getTodayNotifications(), showTime: true),
              notificationController.getYesterdayNotifications().isNotEmpty ? _buildSectionTitle('Ayer') : Container(),
              _buildNotificationList(notificationController.getYesterdayNotifications(), showTime: true),
              const Divider(
                thickness: .1,
                color: Colors.black,
              ),
              notificationController.getOlderNotifications().isNotEmpty ? _buildSectionTitle('Anteriores') : Container(),
              _buildNotificationList(notificationController.getOlderNotifications(), showTime: true),
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
                    borderRadius: BorderRadius.horizontal(left: Radius.circular(50), right: Radius.circular(50)),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Center(
                    child: Text(
                      title,
                      style: TextStyle(
                        color: title == "Hoy" ? Colors.white : Styles.iconColorBack,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
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

  Widget _buildNotificationList(List<NotificationData> notifications, {required bool showTime}) {
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
            notification.isRead == 0 ? controller.updateNotification(notification.id) : null;

            _showNotificationDetails(context, notification);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 12),
            width: double.infinity, // Asegurar que ocupe todo el ancho disponible
            //margin: const EdgeInsets.symmetric(vertical: 1.0), //margen notificaciones
            decoration: BoxDecoration(
              color: notification.isRead == 0 ? Styles.fiveColor : Styles.whiteColor,
            ),
            child: Row(
              children: [
                if (notification.type == 'fidocoin')
                  Container(
                    width: 60,
                    height: 60,
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Styles.iconColorBack,
                      border: Border.all(
                        color: Styles.iconColorBack, // Color del borde
                        width: 1.0, // Grosor del borde
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: SvgPicture.asset(
                        'assets/icons/svg/vector_notification.svg',
                        width: 1,
                        height: 1,
                      ),
                    ),
                  ),
                if (notification.type != 'fidocoin')
                  CircleAvatar(
                    radius: 30, // Aumenta el tamaño de la imagen
                    backgroundImage: NetworkImage(notification.userAvatar ?? 'https://via.placeholder.com/150'), // URL por defecto
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
                        style: const TextStyle(fontWeight: FontWeight.w700, fontFamily: 'Lato', fontSize: 14, color: Color(0xFF000000)),
                      ),
                      const SizedBox(height: 4.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            notification.typeText ?? notification.type ?? '',
                            style: const TextStyle(
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Lato',
                              fontSize: 12,
                              color: Styles.primaryColor,
                            ),
                          ),
                          Text(
                            showTime
                                ? DateFormat('HH:mm').format(DateTime.parse(notification.createdAt!))
                                : DateFormat('dd MMM').format(DateTime.parse(notification.createdAt!)),
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Lato',
                              fontSize: 12,
                              color: Color(0xFF383838),
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
  void _showNotificationDetails(BuildContext context, NotificationData notification) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      isScrollControlled: true, // Permite que el contenido sea scrollable
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.8, // Altura inicial del modal (50% de la pantalla)
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
                        notification.title ?? 'Sin descripción',
                        style: Styles.welcomeTitle,
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    // Etiqueta "Tipo"
                    Text(
                      'Tipo: ',
                      style: TextStyle(
                        fontFamily: 'Lato',
                        fontSize: 14,
                        color: Styles.primaryColor, // Estilo de etiqueta
                        fontWeight: FontWeight.w700,
                        // Aumentar el peso de la etiqueta
                      ),
                    ),
                    // Texto del tipo
                    Text(
                      notification.typeText ?? notification.type ?? 'Desconocido',
                      style: TextStyle(
                        fontFamily: 'Lato',
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    // Etiqueta "Descripción"
                    const Text(
                      'Descripción:',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Styles.primaryColor,
                        fontSize: 16,
                        fontFamily: 'Lato',
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    // Texto de la descripción
                    Text(
                      notification.description ?? '',
                      style: const TextStyle(
                        fontSize: 15,
                        fontFamily: 'Lato',
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: 16.0),
                    // Etiqueta "Fecha"
                    const Text(
                      'Fecha:',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Styles.primaryColor,
                        fontSize: 16,
                        fontFamily: 'Lato',
                      ),
                    ),
                    // Texto de la fecha
                    Text(
                      DateFormat('dd MMM yyyy HH:mm').format(DateTime.parse(notification.createdAt!)),
                      style: const TextStyle(
                        fontSize: 14,
                        fontFamily: 'Lato',
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    // Etiqueta "Leída"
                    const Text(
                      'Leída:',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Styles.primaryColor,
                        fontSize: 16,
                        fontFamily: 'Lato',
                      ),
                    ),
                    // Texto del estado "Leída"
                    Text(
                      notification.isRead == 1 ? 'Sí' : 'No',
                      style: const TextStyle(
                        fontSize: 14,
                        fontFamily: 'Lato',
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 24.0),
                    if ((notification.type == 'medico' || notification.type == "entrenamiento") && AuthServiceApis.dataCurrentUser.userType != "user")
                      Row(
                        children: [
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
                                      description: '¿Quieres rechazar este evento?',
                                      primaryButtonText: 'Continuar',
                                      secondaryButtonText: 'Cancelar',
                                      onPrimaryButtonPressed: () {
                                        notificationController.rechazarReserva(
                                          notification.eventId ?? "-1",
                                          context,
                                        );
                                        Get.back();
                                      },
                                    ),
                                    barrierDismissible: true,
                                  );
                                },
                              ),
                            ),
                          const SizedBox(width: 8.0),
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
                                      description: '¿Quieres Aceptar este Evento?',
                                      primaryButtonText: 'Continuar',
                                      secondaryButtonText: 'Cancelar',
                                      onPrimaryButtonPressed: () {
                                        notificationController.acceptBooking(notification.eventId ?? "-1", context);
                                        Get.back();
                                      },
                                      onSecondaryButtonPressed: () {
                                        Get.back();
                                      },
                                    ),
                                    barrierDismissible: true,
                                  );
                                },
                              ),
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
