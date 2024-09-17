import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pawlly/modules/home/controllers/home_controller.dart';
import 'package:pawlly/styles/styles.dart';

class ActivityListScreen extends StatelessWidget {
  final HomeController controller = Get.put(HomeController());

  ActivityListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Lista de Actividades',
            style: TextStyle(
              fontSize: 20,
              color: Styles.primaryColor,
              fontFamily: 'PoetsenOne',
            ),
            textAlign: TextAlign.left,
          ),
          SizedBox(height: 10),
          // Muestra la fecha seleccionada
          Container(
            alignment: Alignment.centerRight,
            child: Obx(() {
              // Formatear el mes a texto y el día en número con dos dígitos
              final selectedDate = controller.selectedDay.value;
              final formattedDay =
                  DateFormat('dd').format(selectedDate); // Día con dos dígitos
              String formattedMonth = DateFormat('MMMM', 'es_ES')
                  .format(selectedDate); // Mes en texto completo

              // Capitalizar la primera letra del mes
              formattedMonth =
                  formattedMonth[0].toUpperCase() + formattedMonth.substring(1);

              return Text(
                '$formattedDay de $formattedMonth',
                style: const TextStyle(
                  fontFamily: 'Lato',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Styles.blackColor,
                ),
              );
            }),
          ),
          SizedBox(height: 16),
          // Lista de actividades para la fecha seleccionada
          Obx(() {
            final eventsForDay = controller.getEventsForSelectedDay();
            if (eventsForDay.isEmpty) {
              return Center(child: Text('No hay actividades.'));
            }
            return ListView.builder(
              physics:
                  NeverScrollableScrollPhysics(), // Desactiva el scroll interno
              shrinkWrap: true, // Deja que la lista se ajuste al contenido
              itemCount: eventsForDay.length,
              itemBuilder: (context, index) {
                final eventTime = eventsForDay[index]['time'] as DateTime;
                final eventTitle = eventsForDay[index]['title'];

                return Container(
                  margin: EdgeInsets.only(bottom: 16),
                  padding: EdgeInsets.all(12),
                  width: Get.width,
                  decoration: BoxDecoration(
                    color: Styles.fiveColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        eventTitle.toString(),
                        style: TextStyle(
                          fontFamily: 'Lato',
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: Styles.blackColor,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Descripción de la actividad aquí.',
                        style: TextStyle(
                          fontFamily: 'Lato',
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Styles.greyTextColor,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Hora: ${eventTime.hour}:${eventTime.minute.toString().padLeft(2, '0')}',
                        style: TextStyle(
                          fontFamily: 'Lato',
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Styles.iconColorBack,
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }),
        ],
      ),
    );
  }
}
