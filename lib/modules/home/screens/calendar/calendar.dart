import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pawlly/modules/components/input_text.dart';
import 'package:pawlly/modules/components/recarga_componente.dart';
import 'package:pawlly/modules/home/controllers/home_controller.dart';
import 'package:pawlly/modules/home/screens/calendar/formulario_evento.dart';
import 'package:pawlly/modules/integracion/controller/calendar_controller/calendar_controller.dart';
import 'package:pawlly/modules/integracion/controller/user_type/user_controller.dart';

import 'package:pawlly/styles/styles.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatelessWidget {
  final HomeController controller = Get.find<HomeController>();
  final UserController userController = Get.put(UserController());
  final CalendarController calendarController = Get.put(CalendarController());
  // final CalendarController calendarController = Get.find<CalendarController>();
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
              fontFamily: 'PoetsenOne',
            ),
          ),
          const SizedBox(height: 10),
          // Calendario
          Obx(() {
            return TableCalendar(
              firstDay: DateTime.utc(2022, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: controller.focusedDay.value,
              selectedDayPredicate: (day) =>
                  isSameDay(controller.selectedDay.value, day),
              onDaySelected: (selectedDay, focusedDay) {
                controller.onDaySelected(selectedDay, focusedDay);
              },
              eventLoader: (day) {
                return controller.getEventsForDay(day);
              },
              calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: Styles.blackColor,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(10),
                ),
                selectedDecoration: BoxDecoration(
                  color: Styles.fiveColor,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(10),
                ),
                markerDecoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
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
            );
          }),
          const SizedBox(height: 16),
          Container(
            width: 325,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 248,
                  child: InputText(
                    fondoColor: Colors.white,
                    onChanged: (value) {
                      calendarController.filterEvent(value);
                    },
                    prefiIcon: Icon(Icons.search_outlined),
                    placeholder: 'Realiza tu búsqueda',
                  ),
                ),
                const SizedBox(width: 16),
                FloatingActionButton(
                  onPressed: () {
                    Get.to(() => CreateEvent());
                  },
                  clipBehavior: Clip.antiAlias,
                  backgroundColor: Styles.primaryColor,
                  shape: CircleBorder(), // Forma redonda asegurada
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            child: RecargaComponente(
              callback: () {
                calendarController.getEventos();
              },
            ),
          ),
        ],
      ),
    );
  }
}
