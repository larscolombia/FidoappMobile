import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pawlly/components/button_default_widget.dart';
import 'package:pawlly/modules/components/border_redondiado.dart';
import 'package:pawlly/modules/components/editar.dart';
import 'package:pawlly/modules/components/input_text.dart';
import 'package:pawlly/modules/components/regresr_components.dart';
import 'package:pawlly/modules/components/style.dart';
import 'package:pawlly/modules/integracion/controller/calendar_controller/calendar_controller.dart';

class EventoDestalles extends StatelessWidget {
  final calendarController = Get.find<CalendarController>();
  @override
  Widget build(BuildContext context) {
    final eventos = calendarController.selectedEvents.first;

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(slivers: [
        SliverList(
          delegate: SliverChildListDelegate([
            Container(
              height: 180,
              decoration: BoxDecoration(
                color: Styles.colorContainer,
              ),
              child: Stack(
                children: [
                  BorderRedondiado(top: 160),
                  Positioned(
                    top: 100,
                    left: 0,
                    right: 0,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 100,
                      child: Text(
                        textAlign: TextAlign.center,
                        'Completa la Información',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width - 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        BarraBack(
                          titulo: 'Sobre este Evento',
                          callback: () {
                            Get.back();
                          },
                        ),
                        Obx(() {
                          return Editar(
                            coloredit: !calendarController.isEdit.value
                                ? Color.fromARGB(255, 107, 106, 106)
                                : Styles.colorContainer,
                            callback: () {
                              print('aqio voy a editar');
                              calendarController.setEdit();
                            },
                          );
                        })
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  Obx(() {
                    return Container(
                      width: MediaQuery.of(context).size.width - 100,
                      child: Column(
                        children: [
                          InputText(
                            placeholder: '',
                            onChanged: (value) =>
                                calendarController.updateField('name', value),
                            initialValue: eventos.name,
                            label: 'Nombre del Evento',
                            readOnly: !calendarController.isEdit.value,
                          ),
                          const SizedBox(height: 20),
                          InputText(
                            placeholder: '',
                            onChanged: (value) => calendarController
                                .updateField('description', value),
                            initialValue: eventos.description,
                            label: 'Descripción del evento',
                            readOnly: !calendarController.isEdit.value,
                          ),
                          const SizedBox(height: 20),
                          InputText(
                            prefiIcon: Icon(
                              Icons.calendar_today,
                              color: Styles.iconColor,
                            ),
                            placeholder: '',
                            isDateField: true,
                            onChanged: (value) =>
                                calendarController.updateField('date', value),
                            initialValue: eventos.startDate,
                            label: 'Fecha del evento',
                            readOnly: !calendarController.isEdit.value,
                          ),
                          const SizedBox(height: 20),
                          InputText(
                            prefiIcon: Icon(
                              Icons.timer,
                              color: Styles.iconColor,
                            ),
                            placeholder: '',
                            isTimeField: true,
                            onChanged: (value) => calendarController
                                .updateField('event_time', value),
                            initialValue: eventos.eventime,
                            label: 'Hora del evento',
                            readOnly: !calendarController.isEdit.value,
                          ),
                          const SizedBox(height: 20),
                          if (calendarController.isEdit.value)
                            Container(
                              width: MediaQuery.of(context).size.width - 100,
                              height: 50,
                              child: ButtonDefaultWidget(
                                title: calendarController.isLoading.value
                                    ? 'cargando ... '
                                    : 'editar',
                                callback: () {
                                  print(calendarController.event.value);
                                  calendarController.updateEvento();
                                },
                              ),
                            ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ]),
        ),
      ]),
    );
  }
}
