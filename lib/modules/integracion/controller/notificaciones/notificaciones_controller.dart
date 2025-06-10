import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:pawlly/components/custom_alert_dialog_widget.dart';
import 'dart:convert';
import 'package:pawlly/configs.dart'; // Asegúrate de tener este archivo configurado con tus URLs y otros detalles
import 'package:pawlly/modules/integracion/model/notigicaciones/notificaciones.dart';
import 'package:pawlly/services/auth_service_apis.dart'; // Asegúrate de tener este servicio para obtener el token de autenticación

class NotificationController extends GetxController {
  var notifications = <NotificationData>[]
      .obs; // Usamos RxList para almacenar las notificaciones
  var isLoading = false.obs;
  final String baseUrl = "$DOMAIN_URL/api";
  Timer? _pollingTimer;
  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    try {
      // isLoading(true);
      final response = await http.get(
        Uri.parse(
            '$baseUrl/user-notification?user_id=${AuthServiceApis.dataCurrentUser.id}'), // Ajusta el endpoint según sea necesario
        headers: {
          'Authorization': 'Bearer ${AuthServiceApis.dataCurrentUser.apiToken}',
          'Content-Type': 'application/json',
        },
      );

      print('Respuesta de las notificaciones: ${json.decode(response.body)}');
      if (response.statusCode == 200) {
        var data = json.decode(response.body)['data'] as List;
        notifications.value =
            data.map((item) => NotificationData.fromJson(item)).toList();
      } else {
        //throw Exception('Failed to load notifications');
      }
    } catch (e) {
      print('Respuesta de las notificaciones: $e');
      // isLoading(false);
    }
  }

  Future<void> markAsRead(int notificationId) async {
    try {
      final response = await http.post(
        Uri.parse(
            '$baseUrl/notifications/mark-as-read/$notificationId'), // Ajusta el endpoint según sea necesario
        headers: {
          'Authorization': 'Bearer ${AuthServiceApis.dataCurrentUser.apiToken}',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // Actualiza la lista de notificaciones después de marcar una como leída
        fetchNotifications();
      } else {
        throw Exception('Failed to mark notification as read');
      }
    } catch (e) {
      print('Error al marcar la notificación como leída: $e');
    }
  }

  int countUnreadNotifications() {
    return notifications
        .where((notification) => notification.isRead == 0)
        .length;
  }

  // Método para obtener las notificaciones de hoy
  List<NotificationData> getTodayNotifications() {
    DateTime today = DateTime.now();
    return notifications
        .where((n) =>
            n.createdAt != null &&
            DateTime.parse(n.createdAt!).year == today.year &&
            DateTime.parse(n.createdAt!).month == today.month &&
            DateTime.parse(n.createdAt!).day == today.day)
        .toList();
  }

  // Método para obtener las notificaciones de ayer
  List<NotificationData> getYesterdayNotifications() {
    DateTime yesterday = DateTime.now().subtract(const Duration(days: 1));
    return notifications
        .where((n) =>
            n.createdAt != null &&
            DateTime.parse(n.createdAt!).year == yesterday.year &&
            DateTime.parse(n.createdAt!).month == yesterday.month &&
            DateTime.parse(n.createdAt!).day == yesterday.day)
        .toList();
  }

  // Método para obtener las notificaciones anteriores a ayer
  List<NotificationData> getOlderNotifications() {
    DateTime today = DateTime.now();
    return notifications
        .where((n) =>
            n.createdAt != null &&
            DateTime.parse(n.createdAt!)
                .isBefore(DateTime(today.year, today.month, today.day - 1)))
        .toList();
  }

  var notificacionData = {
    "pet_id": null,
    "category_id": null,
    "date": AuthServiceApis.dataCurrentUser.id,
    "actividad": "",
    "notas": "",
    "image": "",
  }.obs;

  void updateField(String key, dynamic value) {
    notificacionData[key] = value;
  }

  // Método para enviar los datos
  Future<void> submitNotificacion() async {
    isLoading.value = true;
    const url = '$DOMAIN_URL/api/training-diaries';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer ${AuthServiceApis.dataCurrentUser.apiToken}',
          'Content-Type': 'application/json',
          'ngrok-skip-browser-warning': 'true',
        },
        body: jsonEncode(notificacionData),
      );

      if (response.statusCode == 200) {
        // Éxito
        print("Datos enviados correctamente a evento: ${response.body}");
      } else {
        // Error
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoading(false);
    }
  }

  //Actualizar notificaciones

  Future<void> updateNotification(int? notificationId) async {
    final url =
        '$DOMAIN_URL/api/user-notification/$notificationId'; // Cambia a tu URL real

    try {
      final response = await http.put(
        Uri.parse(url),
        headers: {
          'Authorization':
              'Bearer ${AuthServiceApis.dataCurrentUser.apiToken}', // Token de autorización
          'Content-Type': 'application/json', // Tipo de contenido
        },
        body: jsonEncode({
          // Aquí puedes incluir los campos que necesitas actualizar
          'status':
              'read', // Por ejemplo, si estás actualizando el estado a "leído"
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print(
            'Notificación actualizada exitosamente ${json.decode(response.body)}');
        fetchNotifications();
      } else {
        print('Error al actualizar la notificación: ${response.body}');
      }
    } catch (e) {
      print('Excepción capturada: $e');
    }
  }

  //aceptar reserva
  Future<void> acceptBooking(String id, BuildContext context) async {
    final url = Uri.parse('$baseUrl/accept-or-reject-event');
    print('url: $url');
    try {
      // Construir el cuerpo de la solicitud
      final body = jsonEncode({
        "confirm": true,
        "user_id": AuthServiceApis.dataCurrentUser.id,
        "event_id": id,
      });

      // Configurar los encabezados
      final headers = {
        'Authorization': 'Bearer ${AuthServiceApis.dataCurrentUser.apiToken}',
        'Content-Type': 'application/json',
      };

      // Realizar la petición HTTP
      final response = await http.put(url, body: body, headers: headers);

      // Manejar la respuesta
      if (response.statusCode == 200) {
        // Mostrar diálogo de éxito
        Get.dialog(
          CustomAlertDialog(
            icon: Icons.confirmation_num,
            title: '¡Enhorabuena!',
            description: 'Has aceptado la reserva',
            primaryButtonText: 'Continuar',
            onPrimaryButtonPressed: () {
              Get.back();
            },
          ),
          barrierDismissible: true,
        );
      } else {
        // Manejar errores HTTP
        print('Error: ${response.statusCode}, Body: ${response.body}');
        showErrorDialog(context,
            'Hubo un error al aceptar la reserva. Inténtalo de nuevo.');
      }
    } catch (e) {
      // Manejar excepciones
      print('Error al realizar la petición: $e');
      showErrorDialog(context,
          'Ocurrió un error inesperado. Por favor, revisa tu conexión e inténtalo nuevamente.');
    }
  }

  Future<void> rechazarReserva(String id, BuildContext context) async {
    final url = Uri.parse('$baseUrl/accept-or-reject-event');
    print('url: $url');
    try {
      // Construir el cuerpo de la solicitud
      final body = jsonEncode({
        "confirm": false,
        "user_id": AuthServiceApis.dataCurrentUser.id,
        "event_id": id,
      });

      // Configurar los encabezados
      final headers = {
        'Authorization': 'Bearer ${AuthServiceApis.dataCurrentUser.apiToken}',
        'Content-Type': 'application/json',
      };

      // Realizar la petición HTTP
      final response = await http.put(url, body: body, headers: headers);

      // Manejar la respuesta
      if (response.statusCode == 200) {
        // Mostrar diálogo de éxito
        print('rechazamos el evento  ${response.body}');
        Get.dialog(
          CustomAlertDialog(
            icon: Icons.confirmation_num,
            title: 'evento rechazado',
            description: 'Has rechazado el evento',
            primaryButtonText: 'Continuar',
            onPrimaryButtonPressed: () {
              Get.back();
            },
          ),
          barrierDismissible: true,
        );
      } else {
        // Manejar errores HTTP
        print('Error: ${response.statusCode}, Body: ${response.body}');
        showErrorDialog(context,
            'Hubo un error al aceptar la reserva. Inténtalo de nuevo.');
      }
    } catch (e) {
      // Manejar excepciones
      print('Error al realizar la petición: $e');
      showErrorDialog(context,
          'Ocurrió un error inesperado. Por favor, revisa tu conexión e inténtalo nuevamente.');
    }
  }

  void showErrorDialog(BuildContext context, String message) {
    Get.dialog(
      CustomAlertDialog(
        icon: Icons.error,
        title: 'Error',
        description: message,
        primaryButtonText: 'Aceptar',
        onPrimaryButtonPressed: () {
          Get.back();
        },
      ),
      barrierDismissible: true,
    );
  }
}
