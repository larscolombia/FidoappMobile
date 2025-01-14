import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:pawlly/components/custom_alert_dialog_widget.dart';
import 'package:pawlly/configs.dart';
import 'package:pawlly/modules/integracion/controller/balance/balance_controller.dart';
import 'package:pawlly/modules/integracion/controller/notificaciones/notificaciones_controller.dart';
import 'package:http/http.dart' as http;
import 'package:pawlly/services/auth_service_apis.dart';

class PushProvider extends GetxController {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  Future<void> updateDeviceToken(String userId, String deviceToken) async {
    final url = Uri.parse('${BASE_URL}update-device-token');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${AuthServiceApis.dataCurrentUser.apiToken}',
      },
      body: jsonEncode({
        'user_id': userId,
        'device_token': deviceToken,
      }),
    );
    print('resupuesta de device token $response');
    print(response.body);
    if (response.statusCode == 200) {
      print('Token actualizado exitosamente');
      Get.snackbar(
        'exito',
        'Vinculado',
      );
    } else {
      print('Error al actualizar token: ${response.statusCode}');
    }
  }

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
      if (token != null) {
        updateDeviceToken(
            AuthServiceApis.dataCurrentUser.id.toString(), token!);
      }

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
    // Verifica si el mensaje contiene notificación para mostrar

    RemoteNotification? notification = message.notification;
    print("google notificacion: ${notification}");
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
      print('google notification id: ${notification.title}');
      switch (notification.title) {
        case "Recarga exitosa":
          var balanceController = Get.put(UserBalanceController());
          balanceController.fetchUserBalance();
          Get.dialog(
            //pisa papel
            CustomAlertDialog(
              icon: Icons.check_circle_outline,
              title: 'Has recargado tu FidoCoin con exito ',
              description: 'Tu compra fue exitosa',
              primaryButtonText: 'Continuar',
              onPrimaryButtonPressed: () {
                Get.back();
              },
            ),
            barrierDismissible: true,
          );
        case 'notificacion':
          var notificacionescontroller = Get.put(NotificationController());
          notificacionescontroller.fetchNotifications();
          break;
        default:
          print('tipo normal');
          break;
      }
      await flutterLocalNotificationsPlugin.show(
        notification.hashCode, // id único para la notificación
        notification.title,
        notification.body,
        platformDetails,
      );
    } else {
      print('google notification else');
    }
  }

  /// Callback para cuando el usuario abre la app a partir de una notificación
  void _onMessageOpenedAppHandler(RemoteMessage message) async {
    print("_onMessageOpenedAppHandler: ${message.messageId}");
    RemoteNotification? notification = message.notification;
    print("google notificacion: ${notification}");
    // Aquí puedes implementar la navegación o la lógica que necesites
  }
}
