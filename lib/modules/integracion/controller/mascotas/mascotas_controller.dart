import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:pawlly/components/custom_alert_dialog_widget.dart';
import 'package:pawlly/configs.dart';
import 'package:pawlly/modules/integracion/model/mascotas/mascotas_model.dart';
import 'package:pawlly/components/custom_snackbar.dart';
import 'package:pawlly/modules/home/controllers/home_controller.dart';

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
        CustomSnackbar.show(
          title: 'Error',
          message: 'No se pudieron obtener las mascotas',
          isError: true,
        );
      }
    } catch (e) {
      CustomSnackbar.show(
        title: 'Error',
        message: e.toString(),
        isError: true,
      );
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
        CustomSnackbar.show(
          title: 'Error',
          message: 'No se pudo obtener el perfil de la mascota',
          isError: true,
        );
      }
    } catch (e) {
      CustomSnackbar.show(
        title: 'Error',
        message: e.toString(),
        isError: true,
      );
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

      // Convertir todos los valores a cadenas y filtrar los vacíos
      Map<String, String> stringBody = {};
      body.forEach((key, value) {
        final stringValue = value?.toString() ?? '';
        if (stringValue.isNotEmpty) {
          stringBody[key] = stringValue;
        }
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
        // Actualizar los datos en el controlador
        fetchPets(); // Recargar la lista de mascotas
        
        // Actualizar también el HomeController
        final homeController = Get.find<HomeController>();
        homeController.fetchProfiles();
        
        Get.dialog(
          CustomAlertDialog(
            icon: Icons.check_circle_outline,
            title: 'Información Actualizada',
            description: 'La información de la mascota ha sido actualizada correctamente',
            primaryButtonText: 'Continuar',
            onPrimaryButtonPressed: () {
              Get.back(); // Cerrar el modal
              Get.back(); // Regresar a la pantalla anterior
            },
          ),
          barrierDismissible: true,
        );
      } else {
        CustomSnackbar.show(
          title: 'Advertencia',
          message: 'Verifique todos los campos',
          isError: true,
        );
      }
    } catch (e) {
      CustomSnackbar.show(
        title: 'Error',
        message: 'Error al actualizar la mascota',
        isError: true,
      );
    } finally {
      isLoading(false);
    }
  }
}
