import 'package:get/get.dart';
import 'package:pawlly/models/event_model.dart';
import 'package:pawlly/services/event_service_apis.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarController extends GetxController {
  var selectedIndex = 0.obs;
  var profiles = <Map<String, dynamic>>[].obs;
  var selectedProfile = ''.obs;

  var selectedDay = DateTime.now().obs;
  var focusedDay = DateTime.now().obs;

  var calendarFormat = CalendarFormat.month.obs;
  var events = <DateTime, List<EventData>>{}.obs;

  @override
  void onInit() {
    super.onInit();
    _loadEventsFromService();
  }

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
}
