import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:pawlly/components/custom_alert_dialog_widget.dart';
import 'dart:convert';
import 'package:pawlly/configs.dart';
import 'package:pawlly/modules/integracion/model/servicio_entrenador_categoria/entrenador_servicio_model.dart';

import 'package:pawlly/services/auth_service_apis.dart';

class ServiceEntrenadorController extends GetxController {
  var services = <Service>[].obs;
  var isLoading = true.obs;
  var totalAmount = "".obs;
  @override
  void onInit() {
    super.onInit();
    fetchServices();
  }

  void fetchServices() async {
    try {
      isLoading(true);
      // Reemplaza con tu URL de API real
      final response = await http.get(
        Uri.parse('${BASE_URL}training-list-all'),
        headers: {
          'Authorization': 'Bearer ${AuthServiceApis.dataCurrentUser.apiToken}',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        print('Respuesta JSON servicios: $jsonResponse');
        var fetchedServices = (jsonResponse['data'] as List)
            .map((service) => Service.fromJson(service))
            .toList();
        services.value = fetchedServices;
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error al obtener los servicios: $e');
    } finally {
      isLoading(false);
    }
  }

  void fetchprecio(String type, BuildContext context) async {
    isLoading.value = true;
    print('type entrenamiento ${type.toString()}');
    final response = await http.get(
      Uri.parse('${BASE_URL}duration-price?duration_id=$type'),
      headers: {
        'Authorization': 'Bearer ${AuthServiceApis.dataCurrentUser.apiToken}',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      print('Respuesta JSON precio: $jsonResponse');
      totalAmount.value = jsonResponse['data']['amount'].toString();
      Get.dialog(
        //pisa papel
        CustomAlertDialog(
          icon: Icons.check_circle_outline,
          title: 'Costo del servicio ',
          description: '${totalAmount.value}',
          primaryButtonText: 'Continuar',
          onPrimaryButtonPressed: () {
            Navigator.pop(context);
          },
        ),
        barrierDismissible: true,
      );
    } else {
      print('Error: ${response.statusCode}');
    }
    isLoading.value = false;
  }
}
