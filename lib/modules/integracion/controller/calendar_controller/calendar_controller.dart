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

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        allCalendars.value = (data['data'] as List)
            .map((item) => CalendarModel.fromJson(item))
            .toList();
        filteredCalendars.value = allCalendars;
      } else {
        Get.snackbar("Error", "Failed to fetch histories");
      }
    } catch (e) {
      print("Calendario error: $e");
    } finally {
      isLoading.value = false;
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
    'owner_id': 12,
  }.obs;

  void updateField(String key, dynamic value) {
    event[key] = value;
  }

  Future<void> postEvent() async {
    isLoading.value = true;
    isSuccess.value = true;
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
      print('response ${response.body}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Evento creado exitosamente");

        isSuccess.value = false;
      } else {
        print("Error al crear el evento: ${response.body}");
      }
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
