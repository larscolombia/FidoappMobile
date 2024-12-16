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
import 'package:path/path.dart' as path;

class PetActivityController extends GetxController {
  final HomeController homeController = Get.put(HomeController());
  var isLoading = true.obs;
  var activities = <PetActivity>[].obs;
  var filteredActivities = <PetActivity>[].obs;
  var activitiesOne =
      Rxn<PetActivity>(); // Observable para almacenar una sola actividad
  var url = '$DOMAIN_URL/api/get-diary';
  var createUrl = "$DOMAIN_URL/api/training-diaries";

  var diario = {}.obs;

  @override
  void onInit() {
    super.onInit();
    initDiario();
  }

  void initDiario() {
    diario.value = {
      'actividadId': "",
      'actividad': "",
      'date': "",
      'category_id': "",
      'notas': "",
      'pet_id': '0',
      'image': "",
    };
  }

  Future<void> fetchPetActivities(String petId) async {
    try {
      isLoading(true);
      final response = await http.get(
        Uri.parse('$url?pet_id=$petId'),
        headers: {
          'Authorization': 'Bearer ${AuthServiceApis.dataCurrentUser.apiToken}',
          'Content-Type': 'application/json',
        },
      );

      var jsonResponse = json.decode(response.body);
      if (response.statusCode == 200) {
        if (jsonResponse['success']) {
          List<dynamic> data = jsonResponse['data'];
          activities.value =
              data.map((activity) => PetActivity.fromJson(activity)).toList();
          filteredActivities.value = activities;
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
      isLoading(false);
    }
  }

  Future<void> addPetActivity(File? imageFile) async {
    isLoading.value = true;
    try {
      isLoading(true);
      var petId = diario['pet_id'];
      petId = petId != null ? petId.toString() : '';
      var request = http.MultipartRequest('POST', Uri.parse(createUrl))
        ..headers.addAll({
          'Authorization': 'Bearer ${AuthServiceApis.dataCurrentUser.apiToken}',
          'ngrok-skip-browser-warning': 'true',
        })
        ..fields['actividad'] = diario['actividad'] ?? ''
        ..fields['date'] = diario['date'] ?? ''
        ..fields['category_id'] = diario['category_id'] ?? ''
        ..fields['notas'] = diario['notas'] ?? ''
        ..fields['pet_id'] = '1';

      if (imageFile != null) {
        var stream = http.ByteStream(imageFile.openRead());
        var length = await imageFile.length();
        var multipartFile = http.MultipartFile('image', stream, length,
            filename: path.basename(imageFile.path));
        request.files.add(multipartFile);
      }

      var response = await request.send();
      var responseBody = await http.Response.fromStream(response);

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.dialog(
          CustomAlertDialog(
            icon: Icons.check_circle_outline,
            title: 'Éxito',
            description: 'El Diario ha sido creado exitosamente.',
            primaryButtonText: 'Aceptar',
            onPrimaryButtonPressed: () {
              Get.off(HomeScreen());
            },
          ),
          barrierDismissible: false,
        );
      } else {
        print('Error en la creación de la actividad: ${responseBody.body}');
      }
    } catch (e) {
      print('Excepción capturada: $e');
    } finally {
      isLoading(false);
    }
  }

  //editar
  Future<void> editPetActivity(String diaryId, File? imageFile) async {
    isLoading.value = true;
    try {
      isLoading(true);

      // Cambia la URL al endpoint de actualización, utilizando el ID
      var request = http.MultipartRequest(
        'PUT',
        Uri.parse(
            '${BASE_URL}training-diaries/$diaryId'), // Usa el endpoint PUT con el ID
      )
        ..headers.addAll({
          'Authorization': 'Bearer ${AuthServiceApis.dataCurrentUser.apiToken}',
          'ngrok-skip-browser-warning': 'true',
        })
        ..fields['actividad'] = diario['actividad'] ?? ''
        ..fields['date'] = diario['date'] ?? ''
        ..fields['category_id'] = diario['category_id'] ?? ''
        ..fields['notas'] = diario['notas'] ?? ''
        ..fields['pet_id'] = diario['pet_id'];

      if (imageFile != null) {
        // Si se seleccionó una nueva imagen, se agrega al request
        var stream = http.ByteStream(imageFile.openRead());
        var length = await imageFile.length();
        var multipartFile = http.MultipartFile('image', stream, length,
            filename: path.basename(imageFile.path)); // Nombre del archivo
        request.files.add(multipartFile);
      }

      var response = await request.send();
      var responseBody = await http.Response.fromStream(response);
      print('responseBody.statusCode: ${json.decode(responseBody.body)}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Si la respuesta es exitosa, mostramos un mensaje de éxito
        Get.dialog(
          CustomAlertDialog(
            icon: Icons.check_circle_outline,
            title: 'Éxito',
            description: 'El Diario ha sido actualizado exitosamente.',
            primaryButtonText: 'Aceptar',
            onPrimaryButtonPressed: () {
              //  Get.off(HomeScreen());
            },
          ),
          barrierDismissible: false,
        );
      } else {
        // Si hubo algún error en el servidor
        print('Error al actualizar la actividad: ${responseBody.body}');
      }
    } catch (e) {
      // Manejo de excepciones
      print('Excepción capturada: $e');
    } finally {
      isLoading(false);
    }
  }

  // Método para obtener una actividad por su ID y almacenarla en activitiesOne
  void getActivityById(int id) {
    var activity = activities.firstWhere(
      (activity) => activity.id == id,
      orElse: () => PetActivity(
        id: -1,
        categoryId: -1,
        categoryName: 'No Encontrada',
        date: '',
        actividad: '',
        notas: '',
        petId: -1,
        image: '',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );

    if (activity.id != -1) {
      activitiesOne.value = activity;
    } else {
      print('Actividad no encontrada');
    }
  }

  void updateField(String key, dynamic value) {
    diario[key] = value;
  }

  void searchActivities(String query) {
    if (query.isEmpty) {
      filteredActivities.value = activities;
    } else {
      filteredActivities.value = activities.where((activity) {
        return activity.actividad.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
  }

  //actulizar historial
}
