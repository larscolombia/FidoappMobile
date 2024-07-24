import 'package:get/get.dart';
import 'package:pawlly/models/notification_model.dart';

class NotificationsController extends GetxController {
  var notifications = <NotificationModel>[].obs;

  void loadNotifications() {
    notifications.addAll([
      NotificationModel(
        title: 'Nueva función lanzada',
        type: 'Actualización',
        date: DateTime.now(),
        imageUrl: 'https://via.placeholder.com/150',
      ),
      NotificationModel(
        title: 'Recordatorio de evento',
        type: 'Evento',
        date: DateTime.now().subtract(Duration(days: 1)),
        imageUrl: 'https://via.placeholder.com/150',
      ),
      NotificationModel(
        title: 'Mantenimiento programado',
        type: 'Mantenimiento',
        date: DateTime.now().subtract(Duration(days: 2)),
        imageUrl: 'https://via.placeholder.com/150',
      ),
      NotificationModel(
        title: 'Actualización de seguridad',
        type: 'Actualización',
        date: DateTime.now().subtract(Duration(days: 3)),
        imageUrl: 'https://via.placeholder.com/150',
      ),
      NotificationModel(
        title: 'Nueva política de privacidad',
        type: 'Anuncio',
        date: DateTime.now().subtract(Duration(days: 4)),
        imageUrl: 'https://via.placeholder.com/150',
      ),
      NotificationModel(
        title: 'Ampliación de almacenamiento',
        type: 'Actualización',
        date: DateTime.now().subtract(Duration(days: 5)),
        imageUrl: 'https://via.placeholder.com/150',
      ),
      NotificationModel(
        title: 'Notificación de cumpleaños',
        type: 'Recordatorio',
        date: DateTime.now().subtract(Duration(days: 6)),
        imageUrl: 'https://via.placeholder.com/150',
      ),
      NotificationModel(
        title: 'Cierre de sesión programado',
        type: 'Mantenimiento',
        date: DateTime.now().subtract(Duration(days: 7)),
        imageUrl: 'https://via.placeholder.com/150',
      ),
      NotificationModel(
        title: 'Actualización de términos y condiciones',
        type: 'Anuncio',
        date: DateTime.now().subtract(Duration(days: 8)),
        imageUrl: 'https://via.placeholder.com/150',
      ),
      NotificationModel(
        title: 'Evento de networking',
        type: 'Evento',
        date: DateTime.now().subtract(Duration(days: 9)),
        imageUrl: 'https://via.placeholder.com/150',
      ),
      NotificationModel(
        title: 'Recordatorio de cita',
        type: 'Recordatorio',
        date: DateTime.now().subtract(Duration(days: 10)),
        imageUrl: 'https://via.placeholder.com/150',
      ),
    ]);
  }

  List<NotificationModel> getTodayNotifications() {
    DateTime today = DateTime.now();
    return notifications
        .where((n) =>
            n.date.year == today.year &&
            n.date.month == today.month &&
            n.date.day == today.day)
        .toList();
  }

  List<NotificationModel> getYesterdayNotifications() {
    DateTime yesterday = DateTime.now().subtract(Duration(days: 1));
    return notifications
        .where((n) =>
            n.date.year == yesterday.year &&
            n.date.month == yesterday.month &&
            n.date.day == yesterday.day)
        .toList();
  }

  List<NotificationModel> getOlderNotifications() {
    DateTime today = DateTime.now();
    return notifications
        .where((n) =>
            n.date.isBefore(DateTime(today.year, today.month, today.day)))
        .toList();
  }

  void markAsRead(NotificationModel notification) {
    int index = notifications.indexOf(notification);
    if (index != -1) {
      notifications[index] = notification.copyWith(isRead: true);
    }
  }
}
