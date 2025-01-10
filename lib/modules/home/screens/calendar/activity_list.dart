import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pawlly/modules/components/recarga_componente.dart';
import 'package:pawlly/modules/components/style.dart';
import 'package:pawlly/modules/home/controllers/home_controller.dart';
import 'package:pawlly/modules/home/screens/calendar/evento_list.dart';
import 'package:pawlly/modules/integracion/controller/calendar_controller/calendar_controller.dart';
import 'package:pawlly/modules/integracion/controller/user_type/user_controller.dart';
import 'package:pawlly/modules/integracion/model/calendar/calendar_model.dart';

class ActivityListScreen extends StatelessWidget {
  final CalendarController calendarController = Get.put(CalendarController());
  final HomeController homeController = Get.put(HomeController());
  final UserController userController = Get.put(UserController());

  ActivityListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Obx(() {
          final data = calendarController.filteredCalendars.value;

          if (calendarController.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (data.isEmpty) {
            return const Center(
              child: Text(
                'No hay actividades disponibles.',
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          // Agrupar los eventos por fecha
          Map<String, List<CalendarModel>> groupedByDate = {};
          for (var event in data) {
            String date = event.date ??
                'Sin fecha'; // Usar la propiedad 'date' para agrupar
            if (!groupedByDate.containsKey(date)) {
              groupedByDate[date] = [];
            }
            groupedByDate[date]?.add(event);
          }

          // Ordenar las fechas
          List<String> sortedDates = groupedByDate.keys.toList();
          sortedDates.sort((a, b) =>
              a.compareTo(b)); // Ordenar las fechas en orden ascendente

          final double containerWidth = MediaQuery.of(context).size.width * 0.8;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: sortedDates.map((date) {
                // Para cada fecha, mostramos un encabezado con la fecha y luego los eventos
                List<CalendarModel> eventsForDate = groupedByDate[date]!;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: Text(
                          textAlign: TextAlign.end,
                          date,
                          style: const TextStyle(
                            fontSize: 14,
                            fontFamily: 'Lato',
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    // Lista de eventos para esa fecha
                    Column(
                      children: eventsForDate.map((event) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Indicador del Timeline
                            Column(
                              children: [
                                Container(
                                  width: 12.0,
                                  height: 12.0,
                                  margin: const EdgeInsets.only(bottom: 8),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color:
                                          const Color.fromRGBO(252, 146, 20, 1),
                                      width: 1,
                                    ),
                                  ),
                                ),
                                if (event != eventsForDate.last)
                                  Container(
                                    width: 2.0,
                                    height: 80.0,
                                    color:
                                        const Color.fromRGBO(252, 146, 20, 1),
                                  ),
                              ],
                            ),
                            const SizedBox(width: 12),
                            // Contenedor del Evento
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  calendarController
                                      .selectEventById(event.id.toString());
                                  print(
                                      "evento seleccionado ${json.encode(event)}");
                                  Get.to(EventoDestalles(), arguments: event);
                                },
                                child: Container(
                                  width: containerWidth,
                                  margin: const EdgeInsets.only(bottom: 16),
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Styles.colorContainer,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: Colors.grey.withOpacity(0.2),
                                      width: 1,
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        event.name ?? 'Sin nombre',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Lato',
                                          color: Colors.black,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      GestureDetector(
                                        onTap: () {
                                          calendarController
                                              .toggleVerMas("${event.id}");
                                          log('vermas ${calendarController.isVerMas.value}');
                                        },
                                        child: Obx(() {
                                          return Text(
                                            "${event.description}",
                                            maxLines:
                                                calendarController.isVerMas[
                                                            event.id ?? ''] ??
                                                        false
                                                    ? 4
                                                    : 1,
                                            overflow:
                                                calendarController.isVerMas[
                                                            event.id ?? 0] ??
                                                        false
                                                    ? TextOverflow.visible
                                                    : TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Lato',
                                              color: Colors.black,
                                            ),
                                          );
                                        }),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        event.eventime ??
                                            'Hora no especificada',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Lato',
                                          color: Styles.fiveColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ],
                );
              }).toList(),
            ),
          );
        }),
      ],
    );
  }
}
