import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarController extends GetxController {
  var selectedIndex = 0.obs;
  var profiles = <Map<String, dynamic>>[].obs; // Lista de perfiles
  var selectedProfile = ''.obs; // Perfil seleccionado

  var selectedDay = DateTime.now().obs;
  var focusedDay = DateTime.now().obs;

  var calendarFormat = CalendarFormat.month.obs;
  var events = <DateTime, List<String>>{}.obs; // Mapa de eventos por fecha

  @override
  void onInit() {
    super.onInit();
    _initializeSampleEvents();
  }

  void _initializeSampleEvents() {
    addEvent(DateTime(2024, 8, 10, 10, 0), 'Consulta veterinaria');
    addEvent(DateTime(2024, 8, 10, 14, 0), 'Vacunación');
    addEvent(DateTime(2024, 8, 20, 9, 0), 'Entrenamiento avanzado');
    addEvent(DateTime(2024, 8, 25, 16, 0), 'Día de juego con otros perros');
  }

  void addEvent(DateTime day, String event) {
    final DateTime eventDate =
        DateTime(day.year, day.month, day.day); // Solo usa año, mes y día
    if (events[eventDate] != null) {
      events[eventDate]!.add(event);
    } else {
      events[eventDate] = [event];
    }
    events.refresh(); // Actualiza la UI después de modificar los eventos
  }

  List<String> getEventsForDay(DateTime day) {
    final DateTime eventDate =
        DateTime(day.year, day.month, day.day); // Solo año, mes y día
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
        'time': selectedDay.value, // La hora del evento
        'title': event, // El título del evento
      };
    }).toList();
  }
}
