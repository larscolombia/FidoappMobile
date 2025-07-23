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
import 'package:pawlly/modules/integracion/model/availability/availability_model.dart';
import 'package:pawlly/modules/integracion/model/calendar/calendar_model.dart';
import 'package:pawlly/modules/components/availability_modal.dart';
import 'package:pawlly/services/auth_service_apis.dart';
import 'package:pawlly/utils/api_end_points.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:pawlly/models/pet_list_res_model.dart';

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
  RxInt selectedPetId = 0.obs;
  Rxn<DateTime> selectedDate = Rxn<DateTime>();

  var EvenName = TextEditingController();
  var fechaEvento = TextEditingController();
  var isVerMas = <String, bool>{}.obs;

  @override
  void onInit() {
    super.onInit();
    getEventos(); // Cargar eventos al iniciar
    
    // Sincronizar con la mascota seleccionada en HomeController
    if (homeController.selectedProfile.value != null) {
      selectedPetId.value = homeController.selectedProfile.value!.id;
    }
    
    // Escuchar cambios en la mascota seleccionada del HomeController
    ever(homeController.selectedProfile, (PetData? selectedPet) {
      if (selectedPet != null) {
        selectedPetId.value = selectedPet.id;
        _applyFilters(); // Aplicar filtros cuando cambie la mascota
      }
    });
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
        print("=== LOG EVENTOS CARGADOS ===");
        print("Respuesta completa del servidor: $data");
        
        allCalendars.value = (data['data'] as List).map((item) => CalendarModel.fromJson(item)).toList();
        
        print("=== EVENTOS PROCESADOS ===");
        print("Total de eventos cargados: ${allCalendars.value.length}");
        
        for (int i = 0; i < allCalendars.value.length; i++) {
          final event = allCalendars.value[i];
          print("Evento ${i + 1}:");
          print("  - ID: ${event.id}");
          print("  - Nombre: ${event.name}");
          print("  - Fecha: ${event.date}");
          print("  - Pet ID: ${event.petId}");
          print("  - Tipo: ${event.tipo}");
          print("  - Status: ${event.status}");
          print("  - Invitados: ${event.owners.length}");
          print("  - Invited: ${event.invited}");
          print("  - Owners: ${event.owners.map((o) => '${o.email}').toList()}");
          print("  ---");
        }
        
        _applyFilters();
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
        final eventDate = DateFormat('dd-MM-yyyy').parse(event.date);
        if (!isSameDay(eventDate, day)) return false;
        if (selectedPetId.value != 0 && event.petId != selectedPetId.value) {
          return false;
        }
        return true;
      } catch (e) {
        print('Error al analizar la fecha: $e');
        return false;
      }
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
    selectedDate.value = date;
    _applyFilters();
  }

  void filterByPet(int? petId) {
    selectedPetId.value = petId ?? 0;
    _applyFilters();
  }

  void _applyFilters() {
    print("=== APLICANDO FILTROS ===");
    print("Total eventos antes de filtrar: ${allCalendars.length}");
    print("Pet ID seleccionado: ${selectedPetId.value}");
    print("Fecha seleccionada: ${selectedDate.value}");
    
    Iterable<CalendarModel> events = allCalendars;
    if (selectedPetId.value != 0) {
      events = events.where((e) => e.petId == selectedPetId.value);
      print("Eventos después de filtrar por mascota: ${events.length}");
    }
    if (selectedDate.value != null) {
      final d = selectedDate.value!;
      final formattedDate = '${d.day.toString().padLeft(2, '0')}-${d.month.toString().padLeft(2, '0')}-${d.year}';
      events = events.where((e) => e.date == formattedDate);
      print("Eventos después de filtrar por fecha: ${events.length}");
    }
    
    filteredCalendars.value = events.toList();
    print("Total eventos después de filtrar: ${filteredCalendars.length}");
    
    // Mostrar detalles de los eventos filtrados
    for (int i = 0; i < filteredCalendars.length; i++) {
      final event = filteredCalendars[i];
      print("Evento filtrado ${i + 1}: ${event.name} (${event.owners.length} invitados)");
    }
    print("=== FIN FILTROS ===");
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

  // Método para verificar disponibilidad del profesional
  Future<AvailabilityResponse?> checkProfessionalAvailability({
    required int employeeId,
    required String date,
    required String time,
    required int serviceId,
  }) async {
    try {
      // Construir la URL con query parameters
      final uri = Uri.parse('$baseUrl/${APIEndPoints.professionalAvailability}').replace(
        queryParameters: {
          'employee_id': employeeId.toString(),
          'date': date,
          'time': time,
          'service_id': serviceId.toString(),
        },
      );

      print('URL de disponibilidad: $uri');
      print('Datos enviados: employee_id=$employeeId, date=$date, time=$time, service_id=$serviceId');

      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer ${AuthServiceApis.dataCurrentUser.apiToken}',
          'Content-Type': 'application/json',
        },
      );

      print('Respuesta del servidor: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return AvailabilityResponse.fromJson(jsonResponse);
      } else {
        print('Error al verificar disponibilidad: ${response.statusCode}');
        print('Cuerpo de respuesta: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error al verificar disponibilidad: $e');
      return null;
    }
  }

  // Método para crear evento con verificación de disponibilidad
  Future<void> createEventWithAvailabilityCheck(BuildContext context) async {
    // Obtener los datos necesarios del evento
    final employeeId = userController.selectedUser.value?.id ?? 0;
    final date = event.value['date']?.toString() ?? '';
    final time = event.value['event_time']?.toString() ?? '';
    
    // Obtener el service_id según el tipo de evento
    int serviceId = 1; // Valor por defecto
    if (event.value['tipo'] == 'medico') {
      serviceId = event.value['service_id'] is int 
          ? event.value['service_id'] as int 
          : 1;
    } else if (event.value['tipo'] == 'entrenamiento') {
      serviceId = event.value['training_id'] is int 
          ? event.value['training_id'] as int 
          : 1;
    }

    if (employeeId == 0 || date.isEmpty || time.isEmpty) {
      CustomSnackbar.show(
        title: "Error",
        message: "Faltan datos para verificar disponibilidad",
        isError: true,
      );
      return;
    }

    // Convertir el formato de fecha SOLO para el endpoint de disponibilidad
    String availabilityDate = _convertDateForAvailability(date);

    print('Fecha original del evento: $date');
    print('Fecha para disponibilidad: $availabilityDate');
    print('Hora: $time');
    print('Employee ID: $employeeId');
    print('Service ID: $serviceId');

    // Verificar disponibilidad
    final availabilityResponse = await checkProfessionalAvailability(
      employeeId: employeeId,
      date: availabilityDate,
      time: time,
      serviceId: serviceId,
    );

    if (availabilityResponse == null) {
      CustomSnackbar.show(
        title: "Error",
        message: "No se pudo verificar la disponibilidad",
        isError: true,
      );
      return;
    }

    // Si está disponible, proceder directamente a crear el evento
    if (!availabilityResponse.isOccupied) {
      postEvent();
    } else {
      // Si está ocupado, mostrar modal con los horarios ocupados
      AvailabilityModal.showAvailabilityModal(
        context,
        availabilityResponse,
        () {
          // Callback vacío ya que no se debe continuar si está ocupado
        },
      );
    }
  }

  // Método auxiliar para convertir fecha solo para disponibilidad
  String _convertDateForAvailability(String originalDate) {
    try {
      if (originalDate.contains('-')) {
        final parts = originalDate.split('-');
        if (parts.length == 3) {
          // Convertir de dd-MM-yyyy a yyyy-MM-dd solo para disponibilidad
          return '${parts[2]}-${parts[1]}-${parts[0]}';
        }
      }
    } catch (e) {
      print('Error al convertir fecha para disponibilidad: $e');
    }
    return originalDate; // Si no se puede convertir, devolver la original
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
