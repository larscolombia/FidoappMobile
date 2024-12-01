import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pawlly/configs.dart';

import 'package:pawlly/modules/integracion/model/diario/actividad_mascota_modal.dart';
import 'package:pawlly/services/auth_service_apis.dart';

class PetActivityController extends GetxController {
  var isLoading = true.obs; // Estado de carga
  var activities = <PetActivity>[].obs; // Lista observable de PetActivity
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
      'pet_id': "1", // Cambia esto si es necesario
      'image': "",
    };
  }

  // Método para obtener las actividades de las mascotas
  Future<void> fetchPetActivities(String pet_id) async {
    try {
      isLoading(true);
      final response = await http.get(
        Uri.parse('${url}?pet_id=${pet_id}'),
        headers: {
          'Authorization': 'Bearer ${AuthServiceApis.dataCurrentUser.apiToken}',
          'Content-Type': 'application/json',
        },
      );

      print('URL de actividades: ${Uri.parse('${url}?pet_id=${pet_id}')}');
      print('Respuesta del servidor para diario: ${response.body}');
      print('Estado de la solicitud: ${response.statusCode}');

      var jsonResponse = json.decode(response.body);
      print('Respuesta JSON completa: $jsonResponse');

      if (response.statusCode == 200) {
        if (jsonResponse['success']) {
          List<dynamic> data = jsonResponse['data'];
          activities.value =
              data.map((activity) => PetActivity.fromJson(activity)).toList();
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
  Future<void> addPetActivity() async {
    try {
      // Asegúrate de tener los datos correctos para el POST
      var requestData = {
        'actividad': diario['actividad'],
        'date': diario['date'],
        'category_id': diario['category_id'],
        'notas': diario['notas'],
        'pet_id': diario['pet_id'],
        'image': null, // Si tienes una imagen, adjunta la URL o base64
      };
      print('crear actividad ${Uri.parse(createUrl)}');
      isLoading(true);
      final response = await http.post(
        Uri.parse(createUrl),
        headers: {
          'Authorization': 'Bearer ${AuthServiceApis.dataCurrentUser.apiToken}',
          'Content-Type': 'application/json',
        },
        body: json.encode(requestData),
      );

      print('URL de creación de actividad: $createUrl');
      print('Respuesta del servidor para crear actividad: ${response.body}');
      print('Estado de la solicitud: ${response.statusCode}');

      var jsonResponse = json.decode(response.body);
      if (response.statusCode == 200 && jsonResponse['success']) {
        print('Actividad registrada con éxito');
        // Aquí puedes actualizar la lista de actividades si es necesario
        fetchPetActivities(diario['pet_id']);
      } else {
        print(
            'Error en la creación de la actividad: ${jsonResponse['message']}');
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

  void updateField(String key, dynamic value) {
    diario[key] = value;
  }
}
