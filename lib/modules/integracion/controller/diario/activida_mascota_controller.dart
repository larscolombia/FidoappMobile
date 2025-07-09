import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:pawlly/components/custom_alert_dialog_widget.dart';
import 'package:pawlly/configs.dart';
import 'package:pawlly/modules/diario/diario.dart';
import 'package:pawlly/modules/home/controllers/home_controller.dart';
import 'package:pawlly/modules/integracion/model/diario/actividad_mascota_modal.dart';
import 'package:pawlly/services/auth_service_apis.dart';

class PetActivityController extends GetxController {
  final HomeController homeController = Get.put(HomeController());
  var isLoading = false.obs;
  var activities = <PetActivity>[].obs;
  var filteredActivities = <PetActivity>[].obs;
  var activitiesOne = Rxn<PetActivity>(); // Observable para almacenar una sola actividad
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

  // ignore: non_constant_identifier_names
  String categoria_user_type() {
    switch (AuthServiceApis.dataCurrentUser.userType) {
      case 'user':
        return "1";
      case 'vet':
        return "2";
      case 'trainer':
        return "3";
      default:
        return "3";
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
      'category_id': '',
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
          activities.value = data.map((activity) => PetActivity.fromJson(activity)).toList();
          // print('actividades ${jsonEncode(activities)}');
          filteredActivities.value = activities;
        } else {
          print('Error en la respuesta del servidor: ${jsonResponse['message']}');
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

      petId = petId != null ? petId.toString() : '';
      
      // Obtener el category_id según el tipo de usuario
      final userType = AuthServiceApis.dataCurrentUser.userType;
      var categoryIdToSend = '';
      
      if (userType == 'user') {
        // Para usuarios tipo "user", usar la categoría seleccionada
        categoryIdToSend = diario['category_id'] ?? '';
      } else {
        // Para vet/trainer, usar la categoría automática
        categoryIdToSend = categoria_user_type();
      }
      
      // Log para debuggear
      print('=== DATOS DEL FORMULARIO DIARIO ===');
      print('Tipo de usuario: $userType');
      print('Actividad: ${diario['actividad']}');
      print('Fecha: ${diario['date']}');
      print('Categoría seleccionada: ${diario['category_id']}');
      print('Categoría que se enviará: $categoryIdToSend');
      print('Notas: ${diario['notas']}');
      print('Pet ID: ${homeController.selectedProfile.value!.id}');
      print('Categoría por tipo de usuario: ${categoria_user_type()}');
      print('=====================================');
      
      var request = http.MultipartRequest('POST', Uri.parse(createUrl))
        ..headers.addAll({
          'Authorization': 'Bearer ${AuthServiceApis.dataCurrentUser.apiToken}',
          'ngrok-skip-browser-warning': 'true',
        })
        ..fields['actividad'] = diario['actividad'] ?? ''
        ..fields['date'] = diario['date'] ?? ''
        ..fields['category_id'] = categoryIdToSend
        ..fields['notas'] = diario['notas'] ?? ''
        ..fields['pet_id'] = homeController.selectedProfile.value!.id.toString();

      // Log del body que se envía
      print('=== BODY ENVIADO AL API ===');
      request.fields.forEach((key, value) {
        print('$key: $value');
      });
      print('============================');

      if (imageFile != null) {
        var stream = http.ByteStream(imageFile.openRead());
        var length = await imageFile.length();
        var multipartFile = http.MultipartFile('image', stream, length, filename: path.basename(imageFile.path));
        request.files.add(multipartFile);
      }

      var response = await request.send();
      var responseBody = await http.Response.fromStream(response);

      print('=== RESPUESTA DEL API ===');
      print('Status Code: ${response.statusCode}');
      print('Response Body: ${responseBody.body}');
      print('==========================');

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.dialog(
          CustomAlertDialog(
            icon: Icons.check_circle_outline,
            title: 'Éxito',
            description: 'El Diario ha sido creado exitosamente.',
            primaryButtonText: 'Aceptar',
            onPrimaryButtonPressed: () {
              diario.value = {
                'actividad': "",
                'date': "",
                'category_id': categoria_user_type(),
                'notas': "",
                'pet_id': '0',
                'image': "",
              };
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
      };

      var request = http.MultipartRequest('POST', url);
      request.headers.addAll(headers);

      // Campos
      request.fields.addAll({
        '_method': 'PUT',
        'actividadId': categoria_user_type(),
        'actividad': diario['actividad'],
        'date': diario['date'],
        'category_id': diario['category_id'],
        'notas': diario['notas'],
        'pet_id': diario['pet_id'].toString(),
      });

      // Adjuntar imagen
      if (imageFile != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'image',
          imageFile.path,
        ));
      }

      // Campos del formulario
      print('\nCampos:');
      request.fields.forEach((key, value) {
        print('$key: $value');
      });

      // Archivos adjuntos

      if (request.files.isEmpty) {
      } else {
        for (var file in request.files) {}
      }

      var response = await request.send();

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.dialog(
          CustomAlertDialog(
            icon: Icons.check_circle_outline,
            title: 'Éxito',
            description: 'El Diario ha sido editado exitosamente.',
            primaryButtonText: 'Aceptar',
            onPrimaryButtonPressed: () {
              diario.value = {
                'actividad': "",
                'date': "",
                'category_id': '',
                'notas': "",
                'pet_id': '0',
                'image': "",
              };
              Get.off(() => Diario());
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
      isLoading.value = false;
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
        'category_id': categoria_user_type(),
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

  void updateCategoryField(dynamic value) {
    print('=== ACTUALIZANDO CATEGORÍA ===');
    print('Valor seleccionado: $value');
    print('Tipo de valor: ${value.runtimeType}');
    diario["category_id"] = value;
    print('Categoría guardada en diario: ${diario["category_id"]}');
    print('==============================');
  }

  // Método para obtener el nombre de la categoría automática según el tipo de usuario
  String getAutoCategoryName() {
    final userType = AuthServiceApis.dataCurrentUser.userType;
    switch (userType) {
      case 'vet':
        return 'Informe médico';
      case 'trainer':
        return 'Entrenamiento';
      case 'user':
        return 'Actividad';
      default:
        return 'Actividad';
    }
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
        return activity.categoryId == int.tryParse(categoryId); // Evita errores al convertir
      }).toList();
    }

    filteredActivities.refresh(); // Forzar notificación de cambio
    print('Filtrado: ${jsonEncode(filteredActivities.value)}');
  }

  //Actualizar historial
  void filterPetActivities(String? reportName) {
    List<PetActivity> filtered = List<PetActivity>.from(activities); // Convertir a List<PetActivity>

    if (reportName != null && reportName.isNotEmpty) {
      filtered = filtered.where((activity) {
        return activity.actividad?.toLowerCase().contains(reportName.toLowerCase()) ?? false;
      }).toList()
        ..sort((a, b) => a.actividad.toLowerCase().compareTo(b.actividad.toLowerCase())); // Ordenar alfabéticamente
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

    filteredActivities.value = RxList<PetActivity>(filtered); // Convertir a RxList<PetActivity>
  }

  String convertDateFormat(String date) {
    List<String> parts = date.split('-');
    if (parts.length == 3) {
      return '${parts[2]}-${parts[1]}-${parts[0]}';
    }
    return date; // Si el formato no es el esperado, retorna la fecha original.
  }

  void applyFilters({
    String? categoryName,
    String? sortType, // "Más recientes", "A-Z", "Z-A"
    String? dateLabel, // Por ejemplo: "Hace 1 año", "Hace 2 meses", etc.
  }) {
    // Partimos de todas las actividades
    List<PetActivity> result = List.from(activities);

    // 1. Filtrar por categoría
    if (categoryName != null && categoryName.isNotEmpty) {
      // Convertimos el nombre de categoría a su ID
      final catId = categoria_value(categoryName);
      // Filtramos
      result = result.where((act) => act.categoryId == int.tryParse(catId)).toList();
    }

    // 2. Filtrar por fecha (opcional: tu lógica para cada rango)
    // Aquí puedes hacer parse de la fecha en 'act.date' y compararlo
    // con la fecha actual según el "dateLabel".
    if (dateLabel != null && dateLabel.isNotEmpty) {
      // Ejemplo simplificado: si es "Hace 1 año", filtramos las actividades
      // con fecha en el último año. Ajusta según tu formato real de fecha.
      if (dateLabel == "Hace 1 año") {
        final hoy = DateTime.now();
        final haceUnAnio = DateTime(hoy.year - 1, hoy.month, hoy.day);
        result = result.where((act) {
          final actDate = DateTime.parse(convertDateFormat(act.date));
          return actDate.isAfter(haceUnAnio);
        }).toList();
      }
      // Agrega más condiciones para "Hace 2 meses", "Hace 1 semana", etc.
    }

    // 3. Ordenar
    if (sortType == "Más recientes") {
      // Orden descendente por fecha (más recientes primero)
      result.sort((a, b) {
        final dateA = DateTime.parse(convertDateFormat(a.date));
        final dateB = DateTime.parse(convertDateFormat(b.date));
        return dateB.compareTo(dateA);
      });
    } else if (sortType == "A-Z") {
      // Orden alfabético ascendente
      result.sort((a, b) => a.actividad.toLowerCase().compareTo(b.actividad.toLowerCase()));
    } else if (sortType == "Z-A") {
      // Orden alfabético descendente
      result.sort((b, a) => a.actividad.toLowerCase().compareTo(b.actividad.toLowerCase()));
    }
    print('filtro ${jsonEncode(result)}');
    // Asignamos a filteredActivities
    filteredActivities.value = result;
  }

  // Método para eliminar una actividad del diario
  Future<void> deletePetActivity(int diaryId) async {
    try {
      isLoading(true);
      final url = Uri.parse('${BASE_URL}training-diaries/$diaryId');
      
      final response = await http.delete(
        url,
        headers: {
          'Authorization': 'Bearer ${AuthServiceApis.dataCurrentUser.apiToken}',
          'Content-Type': 'application/json',
        },
      );

      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Eliminar la actividad de la lista local
        activities.removeWhere((activity) => activity.id == diaryId);
        filteredActivities.removeWhere((activity) => activity.id == diaryId);
        
        Get.dialog(
          CustomAlertDialog(
            icon: Icons.check_circle_outline,
            title: 'Éxito',
            description: 'El registro ha sido eliminado exitosamente.',
            primaryButtonText: 'Aceptar',
            onPrimaryButtonPressed: () {
              Get.back(); // Cerrar el modal de éxito
              Get.back(); // Regresar a la pantalla anterior
            },
          ),
          barrierDismissible: false,
        );
      } else {
        Get.dialog(
          CustomAlertDialog(
            icon: Icons.error_outline,
            title: 'Error',
            description: 'Hubo un problema al eliminar el registro.',
            primaryButtonText: 'Aceptar',
            onPrimaryButtonPressed: () => Get.back(),
          ),
          barrierDismissible: false,
        );
      }
    } catch (e) {
      print('Error al eliminar la actividad: $e');
      Get.dialog(
        CustomAlertDialog(
          icon: Icons.error_outline,
          title: 'Error',
          description: 'Error al eliminar el registro: $e',
          primaryButtonText: 'Aceptar',
          onPrimaryButtonPressed: () => Get.back(),
        ),
        barrierDismissible: false,
      );
    } finally {
      isLoading(false);
    }
  }

  // Método para mostrar confirmación de eliminación
  void showDeleteConfirmation(int diaryId, String activityName) {
    Get.dialog(
      CustomAlertDialog(
        icon: Icons.delete_outline,
        title: "Confirmar eliminación",
        description: "¿Estás seguro de que deseas eliminar '$activityName'?",
        buttonCancelar: true,
        primaryButtonText: "Eliminar",
        onPrimaryButtonPressed: () async {
          Get.back(); // Cierra el modal de confirmación
          await deletePetActivity(diaryId);
        },
      ),
    );
  }
}
