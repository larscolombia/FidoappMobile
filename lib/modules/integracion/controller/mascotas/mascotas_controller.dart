import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:pawlly/components/custom_alert_dialog_widget.dart';
import 'package:pawlly/configs.dart';
import 'package:pawlly/modules/integracion/model/mascotas/mascotas_model.dart';

import 'package:pawlly/services/auth_service_apis.dart';
import 'dart:convert';

class PetControllerv2 extends GetxController {
  var pets = <Pet>[].obs;
  var isLoading = true.obs;
  var selectedPet = Rxn<Pet>();
  var url =
      '$DOMAIN_URL/api/pets?user_id=${AuthServiceApis.dataCurrentUser.id}';
  var succesApdate = false.obs;
  get selectedPetIds => null;
  @override
  void onInit() {
    fetchPets();
    super.onInit();
  }

  void fetchPets() async {
    try {
      isLoading(true);
      var response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer ${AuthServiceApis.dataCurrentUser.apiToken}',
        },
      );
      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        var data = jsonResponse['data'] as List;
        pets.value = data.map((item) => Pet.fromJson(item)).toList();
      } else {
        Get.snackbar('Error', 'Failed to fetch pets');
      }
    } catch (e) {
      print('Error en la solicitud: $e');
    } finally {
      isLoading(false);
      isLoading.value = false;
    }
  }

  void showPet(String id) async {
    var uriShow = '$DOMAIN_URL/api/pets/$id';
    try {
      isLoading(true);
      print('uriShow $uriShow');
      var response = await http.get(
        Uri.parse('$DOMAIN_URL/api/pets/$id'),
        headers: {
          'Authorization':
              'Bearer ${AuthServiceApis.dataCurrentUser.apiToken}', // Ajusta según tu autenticación
        },
      );
      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        selectedPet.value = Pet.fromJson(jsonResponse['data']);
        print('seleccionado ${jsonResponse['data']}');
      } else {
        Get.snackbar('Error', 'Failed to fetch pet profile');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading(false);
    }
  }

  //actilizar mascota
  var metatdat = {
    "name": "",
    "additional_info": "",
    "date_of_birth": "",
    "breed_name": "",
    "gender": "",
    "weight": "",
    "eweightUnit": "",
    "heheightUnit": "",
    "height": "",
    "user_id": "",
    "age": "",
    "pet_fur": "",
    "chip": "",
    "size": "",
  }.obs;
  // Método para actualizar la información de una mascota
  Future<void> updatePet(int id, Map<String, dynamic> body) async {
    try {
      succesApdate(false);
      isLoading(true);
      final url = Uri.parse('${BASE_URL}pets/$id');
      print('URL completa: $url');
      print('Cuerpo de la solicitud (JSON): ${jsonEncode(body)}');

      // Convertir todos los valores a cadenas
      Map<String, String> stringBody = body.map((key, value) {
        return MapEntry(key, value?.toString() ?? '');
      });

      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer ${AuthServiceApis.dataCurrentUser.apiToken}',
          'Content-Type': 'application/json',
        },
        body: json.encode(stringBody),
      );

      print('responseee ${response.statusCode}');
      print('Respuesta completa: ${response.body}');

      if (response.statusCode == 200) {
        Get.dialog(
          //pisa papel
          CustomAlertDialog(
            icon: Icons.check_circle_outline,
            title: 'Acción Realizada Exitosamente',
            description: 'Felicidades ¡Tu cuenta ha sido creada!',
            primaryButtonText: 'Continuar',
            onPrimaryButtonPressed: () {
              Get.back();
            },
          ),
          barrierDismissible: true,
        );
      } else {
        print('Error en la solicitud: ${response.statusCode}');
        print('Respuesta: ${response.body}');
        Get.snackbar(
          'Advertencia',
          'verifique todos los campos',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
        );
      }
    } catch (e) {
      print('Error al actualizar la mascota: $e');
    } finally {
      isLoading(false);
    }
  }
}
