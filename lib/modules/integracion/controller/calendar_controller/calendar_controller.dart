import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pawlly/configs.dart';

import 'package:pawlly/modules/integracion/model/calendar/calendar_model.dart';
import 'package:pawlly/services/auth_service_apis.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class CalendarController extends GetxController {
  final String baseUrl = "${DOMAIN_URL}/api";
  var isLoading = false.obs;
  var isSuccess = false.obs;
  RxList<CalendarModel> allCalendars = <CalendarModel>[].obs;
  RxList<CalendarModel> filteredCalendars = <CalendarModel>[].obs;

  var EvenName = TextEditingController();
  var fechaEvento = TextEditingController();
  var isVerMas = <String, bool>{}.obs;
  @override
  void onInit() {
    super.onInit();
    getEventos(); // Cargar eventos al iniciar
  }

  Future<void> getEventos() async {
    if (isLoading.value) return; // Evita llamadas simultáneas

    isLoading.value = true;

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/events/user/${AuthServiceApis.dataCurrentUser.id}'),
        headers: {
          'Authorization': 'Bearer ${AuthServiceApis.dataCurrentUser.apiToken}',
          'Content-Type': 'application/json',
        },
      );
      print('data calendario: ${json.decode(response.body)}');
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('data calendario: $data');
        allCalendars.value = (data['data'] as List)
            .map((item) => CalendarModel.fromJson(item))
            .toList();
        filteredCalendars.value = allCalendars;
      } else {
        Get.snackbar("Error", "Failed to fetch histories");
      }
    } catch (e) {
      print("data calendario : $e");
    } finally {
      isLoading.value = false;
    }
  }

  void filterEvent(String busqueda) {
    // Si la búsqueda está vacía, simplemente asigna todos los eventos a filteredCalendars
    if (busqueda.isEmpty) {
      filteredCalendars.value = allCalendars;
    } else {
      // Filtrar eventos que contengan la búsqueda en su nombre
      filteredCalendars.value = allCalendars
          .where((event) =>
              event.name.toLowerCase().contains(busqueda.toLowerCase()))
          .toList();
    }
  }

  void filterByDate(DateTime date) {
    String formattedDate = date.toIso8601String().split('T')[0];
    filteredCalendars.value =
        allCalendars.where((event) => event.date == formattedDate).toList();
  }

  void toggleVerMas(String eventId) {
    isVerMas[eventId] = !(isVerMas[eventId] ?? false);
    isVerMas.refresh();
  }

  var event = {
    'name': "",
    'date': "",
    'end_date': "",
    'event_time': "",
    'slug': "",
    'user_id': AuthServiceApis.dataCurrentUser.id,
    'description': "",
    'location': "",
    'tipo': "salud",
    'status': true,
    'pet_id': '',
    'owner_id': '',
  }.obs;
  bool validateEvent(Map<String, dynamic> event) {
    return event['name']?.isNotEmpty == true &&
        event['date']?.isNotEmpty == true &&
        event['event_time']?.isNotEmpty == true &&
        event['slug']?.isNotEmpty == true &&
        event['user_id'] != null &&
        event['description']?.isNotEmpty == true &&
        event['location']?.isNotEmpty == true &&
        event['tipo']?.isNotEmpty == true &&
        event['status'] != null &&
        event['pet_id'] != null &&
        event['owner_id'] != null;
  }

  void updateField(String key, dynamic value) {
    event[key] = value;
  }

  Future<void> postEvent() async {
    isLoading.value = true;
    isSuccess.value = false;
    print('metadata evento : ${jsonEncode(event.toJson())}');
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/events'),
        headers: {
          'Authorization': 'Bearer ${AuthServiceApis.dataCurrentUser.apiToken}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(event.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Evento creado exitosamente {$response.body}");

        isSuccess(true);
      } else {}
    } catch (e) {
      print('Error al enviar los datos: $e');
      Get.snackbar("Error", "Error al enviar los datos");
    } finally {
      isLoading.value = false;
    }
  }

  var selectedPetIds = <String>[].obs;
  void selectSinglePet(String id) {
    selectedPetIds.clear();
    selectedPetIds.add(id);
  }
}
