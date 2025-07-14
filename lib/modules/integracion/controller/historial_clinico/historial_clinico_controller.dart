import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:pawlly/components/custom_alert_dialog_widget.dart';
import 'package:pawlly/configs.dart';
import 'package:pawlly/modules/home/controllers/home_controller.dart';
import 'package:pawlly/modules/home/screens/home_screen.dart';
import 'package:pawlly/services/auth_service_apis.dart';
import 'package:pawlly/modules/integracion/model/historial_clinico/historial_clinico_model.dart';
import 'dart:convert';
import 'package:pawlly/components/custom_snackbar.dart';

class HistorialClinicoController extends GetxController {
  final HomeController _homeController = Get.find();
  var historialClinico = <HistorialClinico>[].obs;
  var filteredHistorialClinico = <HistorialClinico>[].obs;
  var selectedHistorial = Rxn<HistorialClinico>();
  var categories =
      ["Vacuna", "Examen", "Consulta"].obs; // Ejemplo de categorías
  var selectedCategory = "".obs; // Categoría seleccionada
  var sortOptions = ["Nombre", "Fecha", "Tipo"].obs; // Opciones de orden
  var selectedSortOption = "".obs; // Opción de orden seleccionada
  var isEditing = false.obs;
  var isLoading = false.obs;
  var isSuccess = false.obs;
  var vaccineUrl = '$DOMAIN_URL/api/vaccines-given-to-pet';

  @override
  void onInit() {
    // TODO: implement onInit
    // fetchHistorialClinico();
  }

  var reportData = {
    "pet_id": null,
    "report_type": null,
    "veterinarian_id": AuthServiceApis.dataCurrentUser.id,
    "report_name": "",
    "name": "",
    "fecha_aplicacion": "",
    "fecha_refuerzo": "",
    "category": '1',
    "medical_conditions": "",
    "notes": "no tiene nota",
  }.obs;

  void updateFieldsFromSelectedHistorial() {
    if (selectedHistorial.value != null) {
      final historial = selectedHistorial.value!;
      updateField('pet_id', historial.petId);
      updateField('report_type', historial.reportType);
      updateField('report_name', historial.reportName);

      updateField('fecha_refuerzo', historial.fechaRefuerzo ?? '');
      updateField('notes', historial.notes);
      updateField('name', historial.petName);
      updateField('weight', historial.weight);
      updateField('date', historial.fechaAplicacion);
      updateField('category', historial.categoryName);
      updateField('id', historial.id);
      updateField('veterinarian_id', historial.veterinarianId);
      isEditing.value = true;
    }
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      reportData[key] = value;
    });
  }

  void reseterReportData() {
    reportData = {
      'id': 0,
      'pet_id': null,
      'report_type': 1,
      'veterinarian_id': AuthServiceApis.dataCurrentUser.id,
      'report_name': '',
      'name': '',
      'fecha_aplicacion': '',
      'fecha_refuerzo': '',
      'category_name': "",
      "category": "1",
      'medical_conditions': '',
      'vet_visits': "1",
      'date': '',
      'weight': '',
      'notes': null,
      'file': null,
      'image': null,
    }.obs;
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
        '$DOMAIN_URL/api/pet-histories?user_id=${AuthServiceApis.dataCurrentUser.id}&pet_id=${reportData['pet_id']}';
    print('url $url');
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

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.dialog(
          CustomAlertDialog(
            icon: Icons.check_circle_outline,
            title: 'Éxito',
            description: 'El Historial ha sido eliminado exitosamente.',
            primaryButtonText: 'Aceptar',
            onPrimaryButtonPressed: () {
              Get.off(HomeScreen()); // Cerrar el diálogo
            },
          ),
          barrierDismissible:
              false, // No permite cerrar el diálogo tocando fuera
        );
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
    final url = '$DOMAIN_URL/api/medical-history-per-pet?pet_id=$petId';
    final vacunasRequest = '$vaccineUrl?pet_id=$petId';

    // isLoading.value = true;
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
          List<HistorialClinico> list = (data['data'] as List)
              .map((item) => HistorialClinico.fromJson(item))
              .toList();

          // Obtener vacunas y combinarlas
          final vacResponse = await http.get(
            Uri.parse(vacunasRequest),
            headers: {
              'Authorization': 'Bearer ${AuthServiceApis.dataCurrentUser.apiToken}',
              'Content-Type': 'application/json',
              'ngrok-skip-browser-warning': 'true',
            },
          );
          if (vacResponse.statusCode == 200) {
            final vacData = json.decode(vacResponse.body);
            if (vacData['success'] == true) {
              list.addAll((vacData['data'] as List)
                  .map((v) => HistorialClinico.fromJson(v))
                  .toList());
            }
          }

          historialClinico.value = list;
          filteredHistorialClinico.value = list;
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

  void selectSortOption(String option) {
    selectedSortOption.value = option;

    filterHistorialClinico();
  }

  void selectCategory(String category) {
    selectedCategory.value = category;
    filterHistorialClinico();
  }

  void filterHistorialClinico({
    String? reportName,
    String? category,
    String? startDate,
    String? endDate,
  }) {
    var filtered = historialClinico;

    // Filtrar por nombre
    if (reportName != null && reportName.isNotEmpty) {
      filtered = filtered
          .where((historial) =>
              historial.reportName
                  ?.toLowerCase()
                  .contains(reportName.toLowerCase()) ??
              false)
          .toList()
          .obs;
    }

    // Filtrar por categoría (tipo: Vacuna, Examen, Consulta)
    if (category != null && category.isNotEmpty) {
      filtered = filtered
          .where((historial) =>
              historial.categoryName?.toLowerCase() == category.toLowerCase())
          .toList()
          .obs;
    }

    // Filtrar por rango de fechas
    if (startDate != null &&
        startDate.isNotEmpty &&
        endDate != null &&
        endDate.isNotEmpty) {
      filtered = filtered
          .where((historial) {
            final fechaAplicacion =
                DateTime.tryParse(historial.fechaAplicacion ?? '');
            final start = DateTime.tryParse(startDate);
            final end = DateTime.tryParse(endDate);

            if (fechaAplicacion != null && start != null && end != null) {
              return fechaAplicacion.isAfter(start) &&
                  fechaAplicacion.isBefore(end);
            }
            return false;
          })
          .toList()
          .obs;
    }

    // Asignar resultados filtrados
    filteredHistorialClinico.value = _sortHistorialClinico(filtered).obs;
  }

  List<HistorialClinico> _sortHistorialClinico(List<HistorialClinico> history) {
    if (selectedSortOption.value == "Fecha") {
      // Ordenar por fecha en orden descendente
      history.sort((a, b) {
        final dateA =
            DateTime.tryParse(a.fechaAplicacion ?? '') ?? DateTime(1900);
        final dateB =
            DateTime.tryParse(b.fechaAplicacion ?? '') ?? DateTime(1900);
        return dateB.compareTo(dateA); // Más recientes primero
      });
    } else if (selectedSortOption.value == "Nombre") {
      // Ordenar alfabéticamente por nombre
      history
          .sort((a, b) => (a.reportName ?? '').compareTo(b.reportName ?? ''));
    } else if (selectedSortOption.value == "Tipo") {
      // Agrupar por tipo (Vacuna, Antigarrapata, etc.)
      history
          .sort((a, b) => (a.reportType ?? '').compareTo(b.reportType ?? ''));
    }

    return history;
  }

  //Actualizar historial
  Future<void> updateReport(HistorialClinico historialClinico) async {
    isLoading.value = true;

    // Construcción de la URL de la API para actualizar

    final url =
        '$DOMAIN_URL/api/pet-histories/${historialClinico.id}'; // Usar el ID del informe
    print('lo que se va a mandar ${jsonEncode(
      {
        "pet_id": historialClinico.petId,
        "report_type": historialClinico.reportType,
        "veterinarian_id": historialClinico.veterinarianId,
        "report_name": historialClinico.reportName,
        "name": historialClinico.reportName,
        "fecha_aplicacion": historialClinico.fechaAplicacion,
        "fecha_refuerzo": historialClinico.fechaRefuerzo,
        "category_name": historialClinico.categoryName,
        "user_id": AuthServiceApis.dataCurrentUser.id,
        "medical_conditions": historialClinico.medicalConditions,
        "notes": historialClinico.notes,
      },
    )}');
    try {
      // Crear la solicitud PUT
      final response = await http.put(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer ${AuthServiceApis.dataCurrentUser.apiToken}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(
          {
            "pet_id": historialClinico.petId,
            "report_type": historialClinico.reportType,
            "veterinarian_id": historialClinico.veterinarianId,
            "report_name": historialClinico.reportName,
            "name": historialClinico.reportName,
            "fecha_aplicacion": historialClinico.fechaAplicacion,
            "fecha_refuerzo": historialClinico.fechaRefuerzo,
            "category_name": historialClinico.categoryName,
            "user_id": AuthServiceApis.dataCurrentUser.id,
            "medical_conditions": historialClinico.medicalConditions,
            "notes": historialClinico.notes,
          },
        ), // El cuerpo es el mismo que al crear el reporte
      );

      // Verificar la respuesta
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Si la respuesta es exitosa, mostrar un mensaje de éxito
        print('respuesta : ${response.body}');
        Get.dialog(
          CustomAlertDialog(
            icon: Icons.check_circle_outline,
            title: 'Éxito',
            description: 'El Historial ha sido actualizado exitosamente.',
            primaryButtonText: 'Aceptar',
            onPrimaryButtonPressed: () {
              Get.back(); // Redirigir a la pantalla principal
            },
          ),
          barrierDismissible:
              false, // No permite cerrar el diálogo tocando fuera
        );
        isSuccess.value = true;
      } else {
        // Si la respuesta es un error, mostrar el error

        CustomSnackbar.show(
          title: 'Error',
          message: 'Error al actualizar los datos: ${response.body}',
          isError: true,
        );
        print('error al actualizar los datos: ${response.body}');
        isSuccess.value = false;
      }
    } catch (e) {
      CustomSnackbar.show(
        title: 'Error',
        message: 'Error al actualizar el historial',
        isError: true,
      );

      isSuccess.value = false;
    } finally {
      // Detener el estado de carga
      isLoading.value = false;
    }
  }

  void selectHistorialById(int id) {
    final historial = historialClinico.firstWhere(
      (item) => item.id == id,
      orElse: () {
        throw Exception('No se encontró el historial con el ID: $id');
      },
    );
    selectedHistorial.value =
        historial; // Asigna el historial a la variable global
  }

  // Función para mapear el tipo de reporte
  String reporType(String? value) {
    switch (value) {
      case '1':
        return 'Vacunas';
      case '2':
        return 'Antiparasitante';
      case '3':
        return 'Antigarrapata';
      default:
        reportData['report_type'] = 1;
        reportData['report_name'] = 'Vacunas';
        return 'Vacunas';
    }
  }
}
