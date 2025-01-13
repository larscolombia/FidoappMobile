import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:pawlly/modules/integracion/controller/notificaciones/notificaciones_controller.dart';

class PushProvider {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final NotificationController notificacionescontroller =
      Get.put(NotificationController());

  /// Solicita permisos, imprime el token FCM y valida si hay autorización.
  Future<void> setupFCM() async {
    print("Solicitando permisos y configurando FCM...");
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('Notificaciones autorizadas');
      String? token = await _firebaseMessaging.getToken();
      print("Token FCM: $token");
    } else {
      print('Permisos de notificación denegados');
    }
  }

  /// Inicializa flutter_local_notifications y registra los listeners de FCM.
  Future<void> initNorification() async {
    // Configuración para Android e iOS
    AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    // Listener para mensajes en primer plano
    FirebaseMessaging.onMessage.listen(_onMessageHandler);
    // Listener para cuando el usuario toca la notificación
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenedAppHandler);
  }

  /// Callback para mensajes recibidos en primer plano
  void _onMessageHandler(RemoteMessage message) async {
    print(": ${message.messageId}");
    notificacionescontroller.fetchNotifications();
    // Verifica si el mensaje contiene notificación para mostrar
    RemoteNotification? notification = message.notification;
    if (notification != null) {
      // Detalle de la notificación para Android
      AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
        'default_channel_id', // Debe coincidir con el canal configurado o se crea uno nuevo
        'Default Channel',
        channelDescription: 'Channel for default notifications',
        importance: Importance.max,
        priority: Priority.high,
      );
      // Detalle para iOS

      NotificationDetails platformDetails = NotificationDetails(
        android: androidDetails,
      );

      // Muestra la notificación local
      await flutterLocalNotificationsPlugin.show(
        notification.hashCode, // id único para la notificación
        notification.title,
        notification.body,
        platformDetails,
      );
    }
  }

  /// Callback para cuando el usuario abre la app a partir de una notificación
  void _onMessageOpenedAppHandler(RemoteMessage message) async {
    print("_onMessageOpenedAppHandler: ${message.messageId}");
    // Aquí puedes implementar la navegación o la lógica que necesites
  }
}
