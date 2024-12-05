import 'package:get/get.dart';
import 'package:pawlly/models/event_model.dart';
import 'package:pawlly/models/pet_list_res_model.dart';
import 'package:pawlly/models/training_model.dart';
import 'package:pawlly/models/user_data_model.dart';
import 'package:pawlly/modules/home/screens/Diario/index.dart';
import 'package:pawlly/routes/app_pages.dart';
import 'package:pawlly/services/auth_service_apis.dart';
import 'package:pawlly/services/event_service_apis.dart';
import 'package:pawlly/services/pet_service_apis.dart';
import 'package:pawlly/services/training_service_apis.dart';
import 'package:table_calendar/table_calendar.dart';

class HomeController extends GetxController {
  var selectedIndex = 0.obs;
  var profiles = <PetData>[].obs; // Lista de perfiles usando el modelo
  var selectedProfile =
      Rxn<PetData>(); // Perfil seleccionado, inicialmente null
  var training = <TrainingModel>[].obs;
  late UserData currentUser;
  var profileImagePath = ''.obs;

  var selectedDay = DateTime.now().obs;
  var focusedDay = DateTime.now().obs;

  var calendarFormat = CalendarFormat.month.obs;
  var events = <DateTime, List<EventData>>{}.obs;

  var SelectType = 0.obs;

// Llamar al método cuando el controlador se inicializa
  @override
  void onInit() {
    super.onInit();
    currentUser = AuthServiceApis.dataCurrentUser as UserData;
    profileImagePath.value = currentUser.profileImage;
    fetchProfiles();
    //   fetchTraining();
    _loadEventsFromService();
  }

  // Método para actualizar el índice seleccionado
  void updateIndex(int index) {
    selectedIndex.value = index;
  }

  void selectType(int type) {
    SelectType.value = type;
  }

  // Método para navegar a diferentes pantallas
  void pantallas(index) {
    switch (index) {
      case 0:
        // Get.toNamed(Routes.HOME);
        break;
      case 1:
        // Get.toNamed(Routes.CALENDAR);
        break;
      case 2:
        // Get.toNamed(Routes.TRAINING);
        break;
      case 4:
        Get.to(DiarioMascotas());
        break;
    }
  }

  // Método para actualizar el perfil seleccionado
  void updateProfile(PetData profile) {
    selectedProfile.value = profile;
  }

  // Método para agregar un nuevo perfil con datos de mascota
  void addProfile(Map<String, dynamic> petData) {
    profiles.add(PetData.fromJson(petData));
  }

  // Método para cargar los perfiles desde el servicio
  void fetchProfiles() async {
    // Crear una lista temporal para pasarla al servicio
    List<PetData> tempProfiles = [];

    // Llamar al servicio para obtener los perfiles
    final petsData = await PetService.getPetListApi(pets: tempProfiles);

    // Actualizar la lista observable con los datos obtenidos
    profiles.value = petsData;

    // Verificar si la lista no está vacía y actualizar el perfil seleccionado
    if (petsData.isNotEmpty) {
      selectedProfile.value =
          petsData.first; // Asignar el primer perfil completo
    }
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
    return events[eventDate] ?? [];
  }

  void onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    this.selectedDay.value = selectedDay;
    this.focusedDay.value = focusedDay;
  }

  void onFormatChanged(CalendarFormat format) {
    calendarFormat.value = format;
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

//metodo para obtener el perfil de mascota por su id
  PetData getPetById(String id) {
    try {
      // Intentar encontrar la mascota con el ID proporcionado
      return profiles.firstWhere((pet) => pet.id == id);
    } catch (e) {
      // Imprimir el error en caso de que ocurra
      print('Error al recuperar la mascota: $e');
      // Devolver una instancia de Pet con valores predeterminados si ocurre un error
      return PetData(
        id: 0,
        name: '',
        slug: '',
        pettype: '',
        breed: '',
        breedId: 0,
        size: null,
        petImage: null,
        dateOfBirth: null,
        age: '',
        gender: '',
        weight: 0.0,
        weightUnit: '',
        height: 0,
        heightUnit: '',
        userId: 0,
        status: -1,
        qrCode: '',
        createdBy: null,
        updatedBy: null,
        deletedBy: null,
      );
    }
  }
}
