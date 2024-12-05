import 'dart:convert';

import 'package:get/get.dart';
import 'package:pawlly/modules/integracion/model/historial_clinico/historial_clinico_model.dart';
import 'package:pawlly/modules/profile_pet/screens/profile_pet_screen.dart';
import 'package:pawlly/services/auth_service_apis.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:pawlly/configs.dart';
import 'dart:convert';

class HistorialClinicoController extends GetxController {
  var historialClinico = <HistorialClinico>[].obs;
  var categories = <String>[].obs;
  var isEditing = false.obs;
  var isLoading = false.obs;
  var isSuccess = false.obs;

  var reportData = {
    "pet_id": null,
    "report_type": null,
    "veterinarian_id": AuthServiceApis.dataCurrentUser.id,
    "report_name": "",
    "name": "",
    "fecha_aplicacion": "",
    "fecha_refuerzo": "",
    "category": null,
    "medical_conditions": "",
    "test_results": "",
    "vet_visits": null,
    "date": "",
    "weight": "",
    "notes": "",
    "file": null,
    "image": null,
  }.obs;

  @override
  void onInit() {
    super.onInit();
  }

  bool validateReportData() {
    if (reportData['pet_id'] == null ||
        reportData['report_type'] == null ||
        reportData['report_name'] == null ||
        reportData['name'] == null ||
        reportData['fecha_aplicacion'] == null ||
        reportData['category'] == null ||
        reportData['fecha_refuerzo'] == null) {
      return false;
    }
    return true;
  }

  void updateField(String key, dynamic value) {
    reportData[key] = value;
  }

  void addHistorialClinico(HistorialClinico item) {
    historialClinico.add(item);
  }

  void removeHistorialClinico(String id) {
    historialClinico.removeWhere((item) => item.id == id);
  }

  Future<void> submitReport() async {
    isLoading.value = true;
    isSuccess(true);
    final url =
        '${DOMAIN_URL}/api/pet-histories?user_id=${AuthServiceApis.dataCurrentUser.id}&pet_id=${reportData['pet_id']}';
    print('url de envio  $url');
    print('metada enviada ${jsonEncode(reportData)}');
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer ${AuthServiceApis.dataCurrentUser.apiToken}',
          'Content-Type': 'application/json',
          'ngrok-skip-browser-warning': 'true',
        },
        body: jsonEncode(reportData),
      );

      if (response.statusCode == 200) {
        print("Datos enviados correctamente: ${response.body}");
        isSuccess.value = true;
      } else {
        print("Error al enviar datos: ${response.body}");
        isSuccess.value = false;
      }
    } catch (e) {
      print("Error: $e");
      isSuccess.value = false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchHistorialClinico(int petId) async {
    final url = '${DOMAIN_URL}/api/medical-history-per-pet?pet_id=$petId';
    print('Fetching historial médico desde $url');

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer ${AuthServiceApis.dataCurrentUser.apiToken}',
          'Content-Type': 'application/json',
          'ngrok-skip-browser-warning': 'true',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['success'] == true) {
          historialClinico.value = (data['data'] as List)
              .map((item) => HistorialClinico.fromJson(item))
              .toList();
          print(
              'Historial cargado exitosamente: ${historialClinico.length} items');
        } else {
          print('Error en el servidor: ${data['message']}');
        }
      } else {
        print('Error HTTP: ${response.statusCode}');
      }
    } catch (e) {
      print('Error al recuperar el historial médico: $e');
    } finally {
      isLoading.value = false;
    }
  }

// Método para filtrar el historial clínico por report_name
  void filterHistorialClinico(String? reportName) {
    if (reportName == null || reportName.isEmpty) {
      // Si reportName es nulo o está vacío, mostrar todo el historial
      historialClinico.value = historialClinico.value;
    } else {
      // Filtrar por report_name (insensible a mayúsculas/minúsculas)
      historialClinico.value = historialClinico.where((historial) {
        return historial.reportName
            .toLowerCase()
            .contains(reportName.toLowerCase());
      }).toList();
    }
  }
}
