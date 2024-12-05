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
              notificationController.getYesterdayNotifications().length > 0
                  ? _buildSectionTitle('Ayer')
                  : Container(),
              _buildNotificationList(
                  notificationController.getYesterdayNotifications(),
                  showTime: true),
              notificationController.getOlderNotifications().length > 0
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
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildNotificationList(List<NotificationData> notifications,
      {required bool showTime}) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        final notification = notifications[index];
        return GestureDetector(
          onTap: () {},
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 12),
            width:
                double.infinity, // Asegurar que ocupe todo el ancho disponible
            margin: EdgeInsets.symmetric(vertical: 4.0),
            decoration: BoxDecoration(
              color: notification.isRead == 1
                  ? Styles.whiteColor
                  : Styles.fiveColor,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30, // Aumenta el tamaño de la imagen
                  backgroundImage: NetworkImage(
                      'https://via.placeholder.com/150'), // URL por defecto
                  backgroundColor: Colors
                      .transparent, // Asegura que el fondo sea transparente
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
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notification.description ??
                            '', // Asumiendo que description es el título
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Lato',
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 4.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            notification.type ?? '',
                            style: TextStyle(
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
                            style: TextStyle(
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
  /** 
  void _showNotificationDetails(
      BuildContext context, Model.NotificationModel notification) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(notification.title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Tipo: ${notification.type}'),
              SizedBox(height: 8.0),
              Text(
                  'Descripción: \n\nLorem ipsum dolor sit amet, consectetur adipiscing elit.'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(), // Cerrar el diálogo
              child: Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }*/
}
