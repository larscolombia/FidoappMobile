import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pawlly/components/custom_alert_dialog_widget.dart';
import 'package:pawlly/configs.dart';
import 'package:http/http.dart' as http;
import 'package:pawlly/modules/home/controllers/home_controller.dart';
import 'package:pawlly/services/auth_service_apis.dart';

class MascotaPerdida extends GetxController {
  final HomeController homeController = Get.find<HomeController>();
  @override
  void onInit() {
    super.onInit();
    reportarMascotaPerdida();
  }

  Future<void> reportarMascotaPerdida() async {
    const url = '${BASE_URL}pets/update-lost';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer ${AuthServiceApis.dataCurrentUser.apiToken}',
          'Content-Type': 'application/json',
          'ngrok-skip-browser-warning': 'true',
        },
        body: jsonEncode({
          'pet_id': homeController.selectedProfile.value!.id,
        }),
      );

      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 202) {
        Get.dialog(
          CustomAlertDialog(
            icon: Icons.check_circle_outline,
            title: 'Éxito',
            description:
                'Se ha mandado una notificación de alerta a todos los usuarios de la plataforma',
            primaryButtonText: 'Aceptar',
            onPrimaryButtonPressed: () {
              Get.back();
            },
          ),
          barrierDismissible:
              false, // No permite cerrar el diálogo tocando fuera
        );
      } else {
        print("Error al enviar datos: ${response.body}");
      }
    } catch (e) {
      print("Error en mascota perdida: $e");
    }
  }
}
