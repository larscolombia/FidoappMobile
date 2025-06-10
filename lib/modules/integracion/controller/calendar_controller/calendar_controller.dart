import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:pawlly/components/custom_alert_dialog_widget.dart';
import 'package:pawlly/components/custom_snackbar.dart';
import 'package:pawlly/configs.dart';
import 'package:pawlly/modules/home/controllers/home_controller.dart';
import 'package:pawlly/modules/home/screens/home_screen.dart';
import 'package:pawlly/modules/integracion/controller/user_type/user_controller.dart';
import 'package:pawlly/modules/integracion/model/calendar/calendar_model.dart';
import 'package:pawlly/services/auth_service_apis.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarController extends GetxController {
  var cateogoryName = "".obs;
  var serviceName = "".obs;
  final userController = Get.put(UserController());
  final HomeController homeController = Get.find();
  final String baseUrl = "$DOMAIN_URL/api";
  var isLoading = false.obs;
  var isSuccess = false.obs;
  var isEdit = false.obs;
  RxList<CalendarModel> allCalendars = <CalendarModel>[].obs;
  RxList<CalendarModel> filteredCalendars = <CalendarModel>[].obs;
  RxList<CalendarModel> selectedEvents = <CalendarModel>[].obs;

  var EvenName = TextEditingController();
  var fechaEvento = TextEditingController();
  var isVerMas = <String, bool>{}.obs;

  @override
  void onInit() {
    super.onInit();
    getEventos(); // Cargar eventos al iniciar
  }

  void setEdit() {
    isEdit.value = !isEdit.value;
    print(isEdit);
  }

  String? Slug(String value) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyyMMddHHmmss').format(now);
    String valueWithTimestamp = '$value$formattedDate';
    return valueWithTimestamp;
  }

  Future<void> getEventos() async {
    if (isLoading.value) return; // Evita llamadas simultáneas

    // isLoading.value = true;

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
        // print(
        //    "Respuesta del servidor: $data"); // Imprimir la respuesta completa

        allCalendars.value = (data['data'] as List).map((item) => CalendarModel.fromJson(item)).toList();
        filteredCalendars.value = allCalendars;
      } else {
        CustomSnackbar.show(
          title: "Error",
          message: "No se pudieron obtener los eventos",
          isError: true,
        );
      }
    } catch (e) {
      print("data calendario : $e");
    } finally {
      // isLoading.value = false;
    }
  }

  List<CalendarModel> getEventsForDay(DateTime day) {
    return allCalendars.where((event) {
      try {
        // Convertir la fecha del evento (string) a DateTime
        final eventDate = DateFormat('dd-MM-yyyy').parse(event.date);
        return isSameDay(eventDate, day); // Comparar con el día actual
      } catch (e) {
        print('Error al analizar la fecha: $e');
        return false;
      } // Comparar con el día actual
    }).toList();
  }

  void filterEvent(String busqueda) {
    // Si la búsqueda está vacía, simplemente asigna todos los eventos a filteredCalendars
    if (busqueda.isEmpty) {
      filteredCalendars.value = allCalendars;
    } else {
      // Filtrar eventos que contengan la búsqueda en su nombre
      filteredCalendars.value = allCalendars.where((event) => event.name.toLowerCase().contains(busqueda.toLowerCase())).toList();
    }
  }

  void filterByDate(DateTime date) {
    print('calendario $date');

    // Formatear la fecha en el formato 'dd-MM-yyyy'
    String formattedDate = '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';

    // Filtrar los eventos por la fecha formateada
    filteredCalendars.value = allCalendars.where((event) => event.date == formattedDate).toList();
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
    "start_date": "",
    'slug': "",
    'user_id': AuthServiceApis.dataCurrentUser.id,
    'user_email': '',
    'description': "",
    'location': "",
    'tipo': "salud",
    'status': true,
    'pet_id': '0',
    'owner_id': [],
  }.obs;

  Map<String, bool> validate = {
    'name': false,
    'date': false,
    'end_date': false,
    'event_time': false,
    "start_date": false,
    'slug': false,
    'description': false,
    'location': false,
    'tipo': false,
    'pet_id': false,
  }.obs;

  //resetea el formulario
  void ResetEvent() {
    event.value = {
      'name': "",
      'date': "",
      'end_date': "",
      'event_time': "",
      'slug': "",
      'user_id': AuthServiceApis.dataCurrentUser.id,
      'user_email': '',
      'description': "",
      'location': "",
      'tipo': "salud",
      'status': true,
      'pet_id': '',
      'owner_id': "",
      'evenId': "",
    };
  }

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
    print('guardando evento');
    print(event.toJson());
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/events'),
        headers: {
          'Authorization': 'Bearer ${AuthServiceApis.dataCurrentUser.apiToken}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(event.toJson()),
      );
      final jsonResponse = json.decode(response.body);
      print('response data evento  ${response.body}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        print('response : ${response.statusCode}');
        userController.selectedUser.value = null;
        Get.dialog(
          //pisa papel
          CustomAlertDialog(
            icon: Icons.check_circle_outline,
            title: 'Evento creado',
            description: 'El evento ha sido creado',
            primaryButtonText: 'Continuar',
            onPrimaryButtonPressed: () {
              getEventos();
              userController.fetchUsers();
              homeController.selectedIndex.value = 1;
              Get.to(() => HomeScreen());
            },
          ),
          barrierDismissible: true,
        );

        isSuccess(true);
      } else {
        if (jsonResponse['error'] == 'Insufficient balance') {
          Get.snackbar("Error", "Saldo insuficiente, por favor recargue");
        } else {
          Get.snackbar("Error", "comprueba los datos ");
        }
      }
    } catch (e) {
      print('Error al enviar los datos: $e');
      Get.snackbar("Error", "Error al enviar los datos");
    } finally {
      isLoading.value = false;
    }
  }

  // Método auxiliar para manejar la creación exitosa de eventos
  void handleSuccessfulEventCreation() {
    userController.selectedUser.value = null;
    Get.dialog(
      CustomAlertDialog(
        icon: Icons.check_circle_outline,
        title: 'Evento creado',
        description: 'El evento ha sido creado',
        primaryButtonText: 'Continuar',
        onPrimaryButtonPressed: () {
          getEventos();
          userController.fetchUsers();
          homeController.selectedIndex.value = 1;
          Get.to(() => HomeScreen());
        },
      ),
      barrierDismissible: true,
    );
    isSuccess(true);
  }

  var selectedPetIds = <String>[].obs;
  void selectSinglePet(String id) {
    selectedPetIds.clear();
    selectedPetIds.add(id);
  }

  // Método para seleccionar un evento por ID y asignarlo a selectedEvents
  void selectEventById(String id) {
    try {
      CalendarModel selectedEvent = allCalendars.firstWhere((event) => event.id == id);
      selectedEvents.clear();
      selectedEvents.add(selectedEvent);
    } catch (e) {
      print("Evento no encontrado: $e");
    }
  }

  //editar evento
  Future<void> updateEvento(CalendarModel event) async {
    if (isLoading.value) return; // Evita llamadas simultáneas

    isLoading.value = true;
    print("Cuerpo de la solicitud: ${jsonEncode(event.toJson())}");

    try {
      final response = await http.put(
        Uri.parse('$baseUrl/events/${event.id}'),
        headers: {
          'Authorization': 'Bearer ${AuthServiceApis.dataCurrentUser.apiToken}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(event.toJson()), // Añadir el id del evento
      );
      print('data calendario: ${json.decode(response.body)}');
      if (response.statusCode == 200 || response.statusCode == 204) {
        final data = json.decode(response.body);
        print('data calendario actualizado: $data');
        // Actualizar el evento en la lista local
        int index = allCalendars.indexWhere((e) => e.id == event.id);
        if (index != -1) {
          allCalendars[index] = CalendarModel.fromJson(data['data']['event']);
          allCalendars.refresh();
        }

        // Actualizar la lista filtrada si es necesario
        int filteredIndex = filteredCalendars.indexWhere((e) => e.id == event.id);
        if (filteredIndex != -1) {
          filteredCalendars[filteredIndex] = CalendarModel.fromJson(data['data']['event']);
          filteredCalendars.refresh();
        }

        // Desactivar el modo de edición
        isEdit.value = false;

        CustomSnackbar.show(
          title: "Éxito",
          message: "Evento actualizado correctamente",
          isError: false,
        );
      } else {
        CustomSnackbar.show(
          title: "Error",
          message: "Error al actualizar el evento",
          isError: true,
        );
      }
    } catch (e) {
      print("Error al actualizar el evento: $e");
      CustomSnackbar.show(
        title: "Error",
        message: "Error al actualizar el evento",
        isError: true,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void gg(day) {
    print('allCalendars ${allCalendars.value}');
  }

  Map<DateTime, List<CalendarModel>> getEventsForCalendar() {
    print('allCalendars ${allCalendars.value}');
    Map<DateTime, List<CalendarModel>> events = {};

    for (var event in allCalendars) {
      // Convierte la fecha del evento a DateTime
      DateTime eventDate = DateFormat('dd-MM-yyyy').parse(event.date);
      if (!events.containsKey(eventDate)) {
        events[eventDate] = [];
      }
      events[eventDate]?.add(event);
    }

    return events;
  }

  List<CalendarModel> getTwoNearestEvents() {
    // Ordenar los eventos por fecha en orden ascendente
    List<CalendarModel> sortedEvents = allCalendars
        .where((event) => event.date.isNotEmpty) // Filtrar eventos con fecha válida
        .toList()
      ..sort((a, b) {
        DateTime dateA = DateFormat('dd-MM-yyyy').parse(a.date);
        DateTime dateB = DateFormat('dd-MM-yyyy').parse(b.date);
        return dateA.compareTo(dateB);
      });

    // Obtener los dos eventos más próximos
    return sortedEvents.take(2).toList();
  }

  String formatEventTime(String eventTime, String date) {
    try {
      // Parseamos la fecha (formato dd-MM-yyyy)
      DateTime parsedDate = DateFormat('dd-MM-yyyy').parse(date);

      // Obtenemos el día y el mes en el formato deseado
      String day = DateFormat('dd').format(parsedDate);
      String month = DateFormat('MMMM', 'es_ES').format(parsedDate); // Mes en español

      // Formateamos la hora del evento (eventTime)
      String time = DateFormat('hh:mm a').format(DateFormat('HH:mm').parse(eventTime));

      // Retornamos la cadena en el formato: "02 de Agosto 08:00 am"
      return "$day de ${month[0].toUpperCase()}${month.substring(1)} ";
    } catch (e) {
      print("Error al formatear la fecha: $e");
      return "Formato inválido";
    }
  }
}
