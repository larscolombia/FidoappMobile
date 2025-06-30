import 'dart:convert';

import 'package:get/get.dart';
import 'package:pawlly/models/event_model.dart';
import 'package:pawlly/models/pet_data.dart';
import 'package:pawlly/models/training_model.dart';
import 'package:pawlly/models/user_data_model.dart';
import 'package:pawlly/modules/diario/diario.dart';
import 'package:pawlly/modules/home/screens/home_screen.dart';
import 'package:pawlly/repositories/pets_repository.dart';
import 'package:pawlly/services/auth_service_apis.dart';
import 'package:pawlly/services/event_service_apis.dart';
import 'package:pawlly/services/training_service_apis.dart';
import 'package:table_calendar/table_calendar.dart';


class HomeController extends GetxController {
  final petsRepository = Get.put(PetsRepository());
  
  var selectedIndex = 0.obs;
  var titulo = "Bienvenido de vuelta".obs;
  var subtitle = "¿Qué haremos hoy?".obs;

  // Variables observables para el estado de carga y los perfiles
  var isLoading = false.obs;
  Rxn<PetData> get selectedProfile => petsRepository.selectedPet;
  RxList<PetData> get profiles => petsRepository.petsProfiles;
  var filterPet = <PetData>[].obs;

  var training = <TrainingModel>[].obs;
  late UserData currentUser;
  var profileImagePath = ''.obs;
  var selectedDay = DateTime.now().obs;
  var focusedDay = DateTime.now().obs;

  var calendarFormat = CalendarFormat.month.obs;
  var events = <DateTime, List<EventData>>{}.obs;

// Llamar al método cuando el controlador se inicializa
  @override
  void onInit() {
    super.onInit();

    // Datos del usuario actual
    currentUser = AuthServiceApis.dataCurrentUser;
    profileImagePath.value = currentUser.profileImage;
    ever(AuthServiceApis.profileChange, (DateTime time) {
      currentUser = AuthServiceApis.dataCurrentUser;
      profileImagePath.value = currentUser.profileImage;
    });

    // Mascotas y eventos
    loadPetsProfiles();
    // fetchTraining();
    _loadEventsFromService();
  }

  // Método para cargar los perfiles desde el servicio
  void loadPetsProfiles() async {
    petsRepository.loadPetsData();
  }

  // Método para actualizar el índice seleccionado
  void updateIndex(int index) {
    switch (index) {
      case 0:
        titulo.value = "Bienvenido de vuelta";
        subtitle.value = "¿Qué haremos hoy?";
        break;
      case 1:
        titulo.value = "Agenda";
        subtitle.value = "¿Qué haremos hoy?";
        break;
      case 2:
        titulo.value = "Entrenamiento";
        subtitle.value = "para tu mascota";
        break;
      case 3:
        titulo.value = "Explorar Contenido";
        subtitle.value = "y consejos para tu mascota";
        break;
      case 4:
        titulo.value = "Diario";
        subtitle.value = "de tu mascota";
        break;
    }

    selectedIndex.value = index;

    if (index == 4) {
      Get.to(() => Diario());
    } else {
      Get.to(() => const HomeScreen());
    }
  }

  // Método relativos a las mascotas
  // Método para actualizar el perfil seleccionado
  void updateSelectedProfile(PetData petData) {
    print('info pert 3 ${(jsonEncode(petData.name))}');
    petsRepository.selectPet(petData);
  }

  // Método para filtrar por nombre
  // Método para buscar una mascota por su nombre
  void searchPetByName(String name) {
    try {
      // Filtrar las mascotas cuyo nombre contenga la cadena proporcionada (insensible a mayúsculas)
      filterPet.value = profiles
          .where((pet) => pet.name.toLowerCase().contains(name.toLowerCase()))
          .toList();
    } catch (e) {
      // Imprimir cualquier error y limpiar la lista en caso de error
      print('Error en la búsqueda de mascotas: $e');
      filterPet.value = [];
    }
  }

  //metodo para obtener el perfil de mascota por su id
  PetData getPetById(int? id) {
    return profiles.firstWhere(
      (pet) => pet.id == id,
      orElse: () => PetData.empty(),
    );
  }

  void fetchTraining() async {
    // Llamar al servicio para obtener los trainings
    final trainingData = await TrainingService.getTrainingServiceApi();

    // Actualizar la lista observable con los datos obtenidos
    training.value = trainingData;
  }


  // Calendar
  // Método para cargar los eventos desde el servicio
  Future<void> _loadEventsFromService() async {
    try {
      List<EventData> eventList = await EventService.getBreedsListApi();
      for (var event in eventList) {
        // Asegúrate de que la fecha del evento no sea nula
        if (event.date != null) {
          addEvent(event.date!, event);
        }
      }

      focusedDay.value = DateTime.now();
      selectedDay.value = DateTime.now();
    } catch (e) {
      print('Error al cargar los eventos: $e');
    }
    events.refresh(); // Asegúrate de actualizar la interfaz de usuario
  }

  void addEvent(DateTime day, EventData event) {
    final DateTime eventDate = DateTime(day.year, day.month, day.day);
    if (events[eventDate] != null) {
      events[eventDate]!.add(event);
    } else {
      events[eventDate] = [event];
    }
    events.refresh();
  }

  List<EventData> getEventsForDay(DateTime day) {
    final DateTime eventDate = DateTime(day.year, day.month, day.day);
    print('eventos $eventDate');
    return events[eventDate] ?? [];
  }

  // Método para obtener eventos para el día seleccionado
  List<Map<String, dynamic>> getEventsForSelectedDay() {
    final selectedEvents = getEventsForDay(selectedDay.value);
    return selectedEvents.map((event) {
      return {
        'time': event.date, // La hora del evento
        'title': event.name, // El título del evento
      };
    }).toList();
  }

  void onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    this.selectedDay.value = selectedDay;
    this.focusedDay.value = focusedDay;
  }

  void onFormatChanged(CalendarFormat format) {
    calendarFormat.value = format;
  }
}
