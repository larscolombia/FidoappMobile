import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pawlly/components/custom_alert_dialog_widget.dart';
import 'package:pawlly/configs.dart';
import 'package:pawlly/modules/home/controllers/home_controller.dart';
import 'package:pawlly/modules/home/screens/home_screen.dart';

import 'package:pawlly/modules/integracion/model/diario/actividad_mascota_modal.dart';
import 'package:pawlly/services/auth_service_apis.dart';
import 'package:path/path.dart'
    as path; // Asegúrate de importar el paquete path

class PetActivityController extends GetxController {
  final HomeController homeController = Get.put(HomeController());
  var isLoading = true.obs; // Estado de carga
  var activities = <PetActivity>[].obs; // Lista observable de PetActivity
  var filteredActivities = <PetActivity>[].obs; // Lista filtrada de PetActivity
  var url = "${DOMAIN_URL}/api/get-diary"; // URL para obtener las actividades
  var createUrl =
      "${DOMAIN_URL}/api/training-diaries"; // URL para crear una actividad

  var diario = {}.obs; // Inicializa el mapa vacío

  @override
  void onInit() {
    super.onInit();
    // Mueve la inicialización de 'diario' a onInit() para acceder a 'homeController'
    initDiario();
  }

  // Método para inicializar el objeto `diario`
  void initDiario() {
    diario.value = {
      'actividad': "",
      'date': "",
      'category_id': "",
      'notas': "",
      'pet_id': '0', // Cambia esto si es necesario
      'image': "",
    };
  }

  // Método para obtener las actividades de las mascotas
  Future<void> fetchPetActivities(String pet_id) async {
    print('Respuesta JSON completa 1');
    print('Respuesta JSON completa ${diario}');
    try {
      isLoading(true);
      final response = await http.get(
        Uri.parse('${url}?pet_id=${pet_id}'),
        headers: {
          'Authorization': 'Bearer ${AuthServiceApis.dataCurrentUser.apiToken}',
          'Content-Type': 'application/json',
        },
      );

      var jsonResponse = json.decode(response.body);
      print('Respuesta JSON completa: $jsonResponse');

      if (response.statusCode == 200) {
        if (jsonResponse['success']) {
          List<dynamic> data = jsonResponse['data'];
          activities.value =
              data.map((activity) => PetActivity.fromJson(activity)).toList();
          filteredActivities.value =
              activities; // Inicialmente igualar a activities
        } else {
          print(
              'Error en la respuesta del servidor: ${jsonResponse['message']}');
        }
      } else {
        print('Error en la solicitud: ${response.statusCode}');
      }
    } catch (e) {
      print('Excepción capturada: $e');
    } finally {
      isLoading(false); // Cambiar el estado de carga
    }
  }

  // Método para agregar una nueva actividad de mascota

  Future<void> addPetActivity(File? imageFile) async {
    try {
      isLoading(true);

      // Crear el request multipart
      var request = http.MultipartRequest('POST', Uri.parse(createUrl))
        ..headers.addAll({
          'Authorization': 'Bearer ${AuthServiceApis.dataCurrentUser.apiToken}',
          'ngrok-skip-browser-warning': 'true',
        })
        ..fields['actividad'] = diario['actividad'] ?? ''
        ..fields['date'] = diario['date'] ?? ''
        ..fields['category_id'] = diario['category_id'] ?? ''
        ..fields['notas'] = diario['notas'] ?? ''
        ..fields['pet_id'] = diario['pet_id'] ?? '';

      // Agregar la imagen al request si existe
      if (imageFile != null) {
        var stream = http.ByteStream(imageFile.openRead());
        var length = await imageFile.length();
        var multipartFile = http.MultipartFile('image', stream, length,
            filename: path.basename(imageFile.path)); // Usando path.basename
        request.files.add(multipartFile);
      }

      // Enviar el request
      var response = await request.send();
      var responseBody = await http.Response.fromStream(response);

      print('Actividad registrada con éxito ${responseBody.body}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.dialog(
          CustomAlertDialog(
            icon: Icons.check_circle_outline,
            title: 'Éxito',
            description: 'El Diario ha sido creado exitosamente.',
            primaryButtonText: 'Aceptar',
            onPrimaryButtonPressed: () {
              Get.off(HomeScreen()); // Cerrar el diálogo
              // fetchPetActivities(diario['pet_id'].toString());
            },
          ),
          barrierDismissible:
              false, // No permite cerrar el diálogo tocando fuera
        );
      } else {
        print('Error en la creación de la actividad: ${responseBody.body}');
      }
    } catch (e) {
      print('Excepción capturada: $e');
    } finally {
      isLoading(false); // Cambiar el estado de carga
    }
  }

  // Método para obtener una actividad por su ID
  PetActivity getActivityById(int id) {
    return activities.firstWhere((activity) => activity.id == id);
  }

  // Método para actualizar un campo en el objeto `diario`
  void updateField(String key, dynamic value) {
    diario[key] = value;
  }

  // Método para buscar actividades por nombre
  void searchActivities(String query) {
    if (query.isEmpty) {
      filteredActivities.value =
          activities; // Mostrar todas si la búsqueda está vacía
    } else {
      filteredActivities.value = activities.where((activity) {
        return activity.actividad.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
  }
}
