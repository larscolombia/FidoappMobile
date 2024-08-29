import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pawlly/modules/calendar/controllers/calendar_controller.dart';
import 'package:pawlly/styles/styles.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatelessWidget {
  final CalendarController calendarController = Get.put(CalendarController());

  Calendar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Calendario',
            style: TextStyle(
              fontSize: 20,
              color: Styles.primaryColor,
              fontFamily: 'PoetsenOne',
            ),
            textAlign: TextAlign.left,
          ),
          SizedBox(height: 10),
          // Calendario
          Obx(() => TableCalendar(
                firstDay: DateTime.utc(2022, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: calendarController.focusedDay.value,
                calendarFormat: CalendarFormat.month,
                selectedDayPredicate: (day) {
                  return isSameDay(calendarController.selectedDay.value, day);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  calendarController.onDaySelected(selectedDay, focusedDay);
                },
                onFormatChanged: (format) {
                  calendarController.onFormatChanged(format);
                },
                eventLoader: (day) {
                  return calendarController.getEventsForDay(day);
                },
                calendarStyle: CalendarStyle(
                  todayDecoration: BoxDecoration(
                    color: Styles.iconColorBack,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  selectedDecoration: BoxDecoration(
                    color: Styles.fiveColor,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  markerDecoration: BoxDecoration(
                    color: Colors.red, // Punto rojo para días con eventos
                    shape: BoxShape.circle,
                  ),
                  outsideDaysVisible: true,
                ),
                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: false,
                  titleTextStyle: TextStyle(
                    fontFamily: 'Lato',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Styles.iconColorBack,
                  ),
                  leftChevronIcon: Icon(
                    Icons.chevron_left,
                    color: Styles.iconColorBack,
                  ),
                  rightChevronIcon: Icon(
                    Icons.chevron_right,
                    color: Styles.iconColorBack,
                  ),
                ),
                daysOfWeekStyle: DaysOfWeekStyle(
                  weekendStyle: TextStyle(
                    fontFamily: 'Lato',
                    fontWeight: FontWeight.w600,
                    color: Styles.primaryColor,
                  ),
                  weekdayStyle: TextStyle(
                    fontFamily: 'Lato',
                    fontWeight: FontWeight.w600,
                    color: Styles.primaryColor,
                  ),
                ),
                calendarBuilders: CalendarBuilders(
                  selectedBuilder: (context, date, _) {
                    return Container(
                      margin: const EdgeInsets.all(4.0),
                      decoration: BoxDecoration(
                        color: Styles.iconColorBack,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          '${date.day}',
                          style: TextStyle(
                            fontFamily: 'Lato',
                            color: Colors.black,
                          ),
                        ),
                      ),
                    );
                  },
                  todayBuilder: (context, date, _) {
                    return Container(
                      margin: const EdgeInsets.all(4.0),
                      decoration: BoxDecoration(
                        color: Styles.iconColorBack,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          '${date.day}',
                          style: TextStyle(
                            fontFamily: 'Lato',
                            color: Colors.black,
                          ),
                        ),
                      ),
                    );
                  },
                  markerBuilder: (context, date, events) {
                    if (events.isNotEmpty) {
                      return Positioned(
                        top: 1,
                        right: 1,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.red,
                          ),
                        ),
                      );
                    }
                    return SizedBox();
                  },
                ),
              )),
        ],
      ),
    );
  }
}
