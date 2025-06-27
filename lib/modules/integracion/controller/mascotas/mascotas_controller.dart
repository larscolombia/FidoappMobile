import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:pawlly/components/custom_alert_dialog_widget.dart';
import 'package:pawlly/components/custom_snackbar.dart';
import 'package:pawlly/configs.dart';
import 'package:pawlly/models/brear_model.dart';
import 'package:pawlly/models/pet_data.dart';
import 'package:pawlly/models/pet_list_res_model.dart';
import 'package:pawlly/modules/home/controllers/home_controller.dart';
import 'package:pawlly/modules/integracion/model/mascotas/mascotas_model.dart';
import 'package:pawlly/services/auth_service_apis.dart';
import 'package:pawlly/services/pet_service_apis.dart';

class PetControllerv2 extends GetxController {
  var pets = <Pet>[].obs;
  var isLoading = true.obs;
  var selectedPet = Rxn<Pet>();
  var url = '$DOMAIN_URL/api/pets?user_id=${AuthServiceApis.dataCurrentUser.id}';
  var succesUpdate = false.obs;
  get selectedPetIds => null;
  var breedList = <BreedModel>[].obs;

  @override
  void onInit() {
    fetchPets();
    fetchBreedsList();
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

    // Método para obtener la lista de razas desde la API
  Future<void> fetchBreedsList() async {
    final breeds = await PetService.getBreedsListApi();
    if (breeds.isNotEmpty) {
      breedList.assignAll(breeds);
    } else {
      // Manejar el error si la lista está vacía
      CustomSnackbar.show(
        title: 'Error',
        message: 'No se pudo cargar la lista de razas',
        isError: true,
      );
    }
  }
  
  // Método para actualizar la información de una mascota
  Future<void> updatePet(int id, PetData petData) async {
    try {
      succesUpdate(false);
      isLoading(true);

      final url = Uri.parse('${BASE_URL}pets/$id');
      final body = json.encode(petData.mapToUpdate());
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer ${AuthServiceApis.dataCurrentUser.apiToken}',
          'Content-Type': 'application/json',
        },
        body: body,
      );

      // print('responseee ${response.statusCode}');
      // print('Respuesta completa: ${response.body}');

      if (response.statusCode == 200) {

        final homeController = Get.find<HomeController>();
        homeController.updateSelectedProfile(petData);

        Get.dialog(
          //pisa papel
          CustomAlertDialog(
            icon: Icons.check_circle_outline,
            title: 'Acción Realizada Exitosamente',
            description: 'Felicidades ¡La información se actualizó!',
            primaryButtonText: 'Continuar',
            onPrimaryButtonPressed: () {
              Get.back();
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
