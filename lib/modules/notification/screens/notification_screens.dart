import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
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
      child: Center(
        child: Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
            margin: const EdgeInsets.symmetric(vertical: 4.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
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
                        notification.description ?? '',
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
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(notification.description ?? 'Sin descripción'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tipo: ${notification.type ?? 'Desconocido'}',
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 15.0),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Descripcion:',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Lato',
                          color: Styles.primaryColor,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        notification.description ?? '',
                        style: Styles.textProfile15w700,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12.0),
                Text(
                  'Fecha: ${DateFormat('dd MMM yyyy HH:mm').format(DateTime.parse(notification.createdAt!))}',
                  style: const TextStyle(fontWeight: FontWeight.w400),
                ),
                const SizedBox(height: 12.0),
                Text(
                  'Leida: ${notification.isRead}',
                  style: const TextStyle(fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(), // Cerrar el diálogo
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }
}
