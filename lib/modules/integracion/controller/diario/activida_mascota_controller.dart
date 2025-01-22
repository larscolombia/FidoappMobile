import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pawlly/components/custom_alert_dialog_widget.dart';
import 'package:pawlly/configs.dart';
import 'package:pawlly/modules/diario/diario.dart';
import 'package:pawlly/modules/home/controllers/home_controller.dart';
import 'package:pawlly/modules/home/screens/home_screen.dart';
import 'package:pawlly/modules/integracion/model/diario/actividad_mascota_modal.dart';
import 'package:pawlly/services/auth_service_apis.dart';
import 'package:path/path.dart' as path;

class PetActivityController extends GetxController {
  final HomeController homeController = Get.put(HomeController());
  var isLoading = false.obs;
  var activities = <PetActivity>[].obs;
  var filteredActivities = <PetActivity>[].obs;
  var activitiesOne =
      Rxn<PetActivity>(); // Observable para almacenar una sola actividad
  var url = '$DOMAIN_URL/api/get-diary';
  var createUrl = "$DOMAIN_URL/api/training-diaries";
  var categories = ['Actividad', 'Informe médico', 'Entrenamiento'].obs;
  var diario = {}.obs;
  var sortByDate = false.obs;
  @override
  void onInit() {
    super.onInit();
    if (homeController.selectedProfile.value != null) {
      fetchPetActivities(homeController.selectedProfile.value!.id.toString());
    }
    initDiario();
  }

  String categoria(int id) {
    switch (id) {
      case 1:
        return 'Actividad';
      case 2:
        return 'Informe médico';
      case 3:
        return 'Entrenamiento';
      default:
        return 'Actividad';
    }
  }

  String categoria_value(String name) {
    switch (name) {
      case 'Actividad':
        return '1';
      case 'Informe médico':
        return '2';
      case 'Entrenamiento':
        return '3';
      default:
        return 'Actividad';
    }
  }

  void initDiario() {
    diario.value = {
      'actividadId': '0',
      'actividad': "",
      'date': "",
      'category_id': "",
      'notas': "",
      'pet_id': '0',
      'image': "",
    };
  }

  void resetDiario() {
    diario.value = {
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
      // isLoading(true);
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
          // print('actividades ${jsonEncode(activities)}');
          filteredActivities.value = activities;
        } else {
          print(
              'Error en la respuesta del servidor: ${jsonResponse['message']}');
        }
      } else {
        print('Error en la solicitud: ${response.statusCode}');
      }
    } catch (e) {
      print('Excepción capturada en actividad_mascota_controller linea 82: $e');
    } finally {
      // isLoading(false);
    }
  }

  Future<void> addPetActivity(File? imageFile) async {
    isLoading.value = true;
    try {
      isLoading(true);
      var petId = diario['pet_id'];
      print('response actividades ${petId}');
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
        ..fields['pet_id'] =
            homeController.selectedProfile.value!.id.toString();

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
        print('response actividades ${jsonEncode(responseBody.body)}');
        Get.dialog(
          CustomAlertDialog(
            icon: Icons.check_circle_outline,
            title: 'Éxito',
            description: 'El Diario ha sido creado exitosamente.',
            primaryButtonText: 'Aceptar',
            onPrimaryButtonPressed: () {
              Get.off(() => Diario());
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

  Future<void> editPetActivity2(String diaryId, File? imageFile) async {
    isLoading.value = true;
    print('Response Body file $imageFile');
    try {
      var url = Uri.parse('${BASE_URL}training-diaries/$diaryId');
      var headers = {
        'Authorization': 'Bearer ${AuthServiceApis.dataCurrentUser.apiToken}',
        'ngrok-skip-browser-warning': 'true',
      };

      // Crear una solicitud multipart
      var request = http.MultipartRequest('PUT', url);
      request.headers.addAll(headers);

      // Agregar campos al cuerpo de la solicitud
      request.fields['actividadId'] = diario['actividadId'].toString();
      request.fields['actividad'] = diario['actividad'];
      request.fields['date'] = diario['date'];
      request.fields['category_id'] = diario['category_id'].toString();
      request.fields['notas'] = diario['notas'];
      request.fields['pet_id'] = diario['pet_id'].toString();

      // Adjuntar la imagen si existe
      if (imageFile != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'image', // Este es el nombre esperado por el servidor para la imagen
          imageFile.path,
        ));
      }

      if (imageFile != null) {
        var stream = http.ByteStream(imageFile.openRead());
        var length = await imageFile.length();
        var multipartFile = http.MultipartFile('image', stream, length,
            filename: path.basename(imageFile.path));
        request.files.add(multipartFile);
      }

      // Enviar la solicitud
      var response = await request.send();

      // Manejar la respuesta
      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.dialog(
          CustomAlertDialog(
            icon: Icons.check_circle_outline,
            title: 'Éxito',
            description: 'El Diario ha sido actualizado exitosamente.',
            primaryButtonText: 'Aceptar',
            onPrimaryButtonPressed: () {
              Get.back();
              Get.off(() => Diario());
              fetchPetActivities(diario['pet_id']);
              getActivityById(diario['actividadId']);
              Get.back();
            },
          ),
          barrierDismissible: false,
        );
      } else {
        var responseBody = await response.stream.bytesToString();
        print('Error al actualizar: $responseBody');
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
      var url = Uri.parse('${BASE_URL}training-diaries/$diaryId');
      var request = http.MultipartRequest('PUT', url);

      // Encabezados
      request.headers.addAll({
        'Authorization': 'Bearer ${AuthServiceApis.dataCurrentUser.apiToken}',
        'ngrok-skip-browser-warning': 'true',
      });

      // Agregar JSON como campo 'data'
      var jsonData = json.encode({
        'actividadId': diario['actividadId'],
        'actividad': diario['actividad'],
        'date': diario['date'],
        'category_id': diario['category_id'],
        'notas': diario['notas'],
        'pet_id': diario['pet_id'],
      });
      request.fields['data'] = jsonData;

      // Adjuntar archivo de imagen si está presente
      if (imageFile != null) {
        var stream = http.ByteStream(imageFile.openRead());
        var length = await imageFile.length();
        var multipartFile = http.MultipartFile(
          'image',
          stream,
          length,
          filename: path.basename(imageFile.path),
        );
        request.files.add(multipartFile);
      }

      print('Enviando datos y archivo: ${request.fields}');
      if (imageFile != null) {
        print('Archivo adjunto: ${imageFile.path}');
      }

      // Enviar la solicitud
      var response = await request.send();
      var responseBody = await http.Response.fromStream(response);

      print('Response Code: ${response.statusCode}');
      print('Response Body: ${responseBody.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Diario actualizado exitosamente.');
      } else {
        print('Error al actualizar: ${responseBody.body}');
      }
    } catch (e) {
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

  void buscarIdCategoria(String categoryId) {
    print('Filtrando por categoryId: $categoryId');
    if (categoryId.isEmpty) {
      filteredActivities.value = activities;
    } else {
      filteredActivities.value = activities.where((activity) {
        return activity.categoryId ==
            int.tryParse(categoryId); // Evita errores al convertir
      }).toList();
    }

    filteredActivities.refresh(); // Forzar notificación de cambio
    print('Filtrado: ${jsonEncode(filteredActivities.value)}');
  }

  //actulizar historial
  void filterPetActivities(String? reportName) {
    List<PetActivity> filtered =
        List<PetActivity>.from(activities); // Convertir a List<PetActivity>

    if (reportName != null && reportName.isNotEmpty) {
      filtered = filtered.where((activity) {
        return activity.actividad
                ?.toLowerCase()
                .contains(reportName.toLowerCase()) ??
            false;
      }).toList()
        ..sort((a, b) => a.actividad
            .toLowerCase()
            .compareTo(b.actividad.toLowerCase())); // Ordenar alfabéticamente
    }

    var categoryId = diario['category_id']?.toLowerCase() ?? '';
    if (categoryId.isNotEmpty) {
      filtered = filtered.where((activity) {
        return activity.categoryName?.toLowerCase() == categoryId;
      }).toList(); // Convertir a List<PetActivity>
    }

    if (sortByDate.value) {
      filtered.sort((a, b) {
        var dateA = DateTime.parse(convertDateFormat(a.date));
        var dateB = DateTime.parse(convertDateFormat(b.date));
        return dateB.compareTo(dateA); // Orden descendente
      });
    }

    filteredActivities.value =
        RxList<PetActivity>(filtered); // Convertir a RxList<PetActivity>
  }

  String convertDateFormat(String date) {
    List<String> parts = date.split('-');
    if (parts.length == 3) {
      return '${parts[2]}-${parts[1]}-${parts[0]}';
    }
    return date; // Si el formato no es el esperado, retorna la fecha original.
  }
}
