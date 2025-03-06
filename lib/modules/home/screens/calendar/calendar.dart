import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pawlly/modules/components/input_text.dart';
import 'package:pawlly/modules/components/recarga_componente.dart';
import 'package:pawlly/modules/home/controllers/home_controller.dart';
import 'package:pawlly/modules/home/screens/calendar/formulario_evento.dart';
import 'package:pawlly/modules/integracion/controller/calendar_controller/calendar_controller.dart';
import 'package:pawlly/modules/integracion/controller/user_type/user_controller.dart';
import 'package:pawlly/modules/integracion/model/calendar/calendar_model.dart';
import 'package:pawlly/styles/recursos.dart';
import 'package:pawlly/styles/styles.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatelessWidget {
  final HomeController controller = Get.find<HomeController>();
  final UserController userController = Get.put(UserController());
  final CalendarController calendarController = Get.put(CalendarController());

  Calendar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Calendario',
            style: TextStyle(
              fontSize: 20,
              color: Styles.primaryColor,
              fontWeight: FontWeight.w400,
              fontFamily: 'PoetsenOne',
            ),
          ),
          const SizedBox(height: 10),
          Obx(() {
            return Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Recursos.ColorBorderSuave,
                  width: 1,
                ),
              ),
              child: TableCalendar(
                daysOfWeekHeight: 70,
                firstDay: DateTime.utc(2022, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                locale: 'es_ES',
                focusedDay: controller.focusedDay.value,
                selectedDayPredicate: (day) =>
                    isSameDay(controller.selectedDay.value, day),
                onDaySelected: (selectedDay, focusedDay) {
                  calendarController.filterByDate(selectedDay);
                  calendarController.gg(selectedDay);
                },
                eventLoader: (day) {
                  return calendarController.getEventsForDay(day);
                },
                calendarStyle: CalendarStyle(
                  defaultTextStyle: const TextStyle(
                    fontFamily: 'Lato',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  weekendTextStyle: const TextStyle(
                    fontFamily: 'Lato',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  todayDecoration: BoxDecoration(
                    color: Styles.blackColor,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  selectedDecoration: BoxDecoration(
                    color: const Color(0xFFFFFC9214),
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  markerDecoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        Colors.red, // Puedes cambiar el color del punto aquí.
                  ),
                ),
                calendarBuilders: CalendarBuilders(
                  defaultBuilder: (context, day, focusedDay) {
                    return Center(
                      child: Text(
                        day.day.toString(),
                        style: const TextStyle(
                          fontFamily: 'Lato',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  },
                ),
                headerStyle: const HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                  titleTextStyle: TextStyle(
                    fontFamily: 'Lato',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Styles.blackColor,
                  ),
                  leftChevronIcon: Icon(
                    Icons.chevron_left,
                    color: Styles.blackColor,
                  ),
                  rightChevronIcon: Icon(
                    Icons.chevron_right,
                    color: Styles.blackColor,
                  ),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Recursos.ColorBorderSuave,
                        width: 1,
                      ),
                    ),
                  ),
                ),
                daysOfWeekStyle: const DaysOfWeekStyle(
                  weekendStyle: TextStyle(
                    fontFamily: 'Lato',
                    fontWeight: FontWeight.w600,
                    color: Styles.blackColor,
                  ),
                  weekdayStyle: TextStyle(
                    fontFamily: 'Lato',
                    fontWeight: FontWeight.w600,
                    color: Styles.blackColor,
                  ),
                ),
              ),
            );
          }),
          const SizedBox(height: 16),
          const Text(
            'Lista de Actividades',
            style: TextStyle(
              fontSize: 20,
              color: Styles.primaryColor,
              fontFamily: Styles.fuente2,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 280,
                  child: InputText(
                    fondoColor: Colors.white,
                    onChanged: (value) {
                      calendarController.filterEvent(value);
                    },
                    placeholderSvg: 'assets/icons/svg/search-status.svg',
                    placeholderFontFamily: 'lato',
                    borderColor: Recursos.ColorBorderSuave,
                    placeholder: 'Realiza tu búsqueda',
                    placeHolderColor: true,
                  ),
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: FloatingActionButton(
                    onPressed: () {
                      calendarController.ResetEvent();
                      Get.to(() => CreateEvent());
                    },
                    elevation: 0,
                    clipBehavior: Clip.antiAlias,
                    backgroundColor: Styles.primaryColor,
                    shape: const CircleBorder(), // Forma redonda asegurada
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          RecargaComponente(
            callback: () {
              calendarController.getEventos();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMarkers(DateTime date, List events) {
    if (events.isEmpty)
      return const SizedBox(); // Sin eventos, no renderizar nada.

    // Si hay eventos, renderiza un punto por cada uno
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: events.map((event) {
        return Container(
          margin: const EdgeInsets.symmetric(
              horizontal: 1.5), // Espaciado entre puntos
          width: 7.0,
          height: 7.0,
          decoration: BoxDecoration(
            color: _getEventColor(event),
            shape: BoxShape.circle,
          ),
        );
      }).toList(),
    );
  }

  Color _getEventColor(CalendarModel event) {
    switch (event.tipo) {
      case 'medico':
        return const Color(0xFFFF4931);
      case 'evento':
        return const Color(0xFFFC9214);
      case 'entrenamiento':
        return const Color(0xFF3177FF);
      default:
        return Colors.grey;
    }
  }
}
