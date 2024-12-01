import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:pawlly/components/button_default_widget.dart';
import 'package:pawlly/modules/components/fabrica_seleccion_perfil.dart';
import 'package:pawlly/modules/components/input_text.dart';
import 'package:pawlly/modules/components/style.dart';
import 'package:pawlly/modules/home/controllers/home_controller.dart';
import 'package:pawlly/modules/integracion/controller/calendar_controller/calendar_controller.dart';
import 'package:pawlly/modules/integracion/controller/mascotas/mascotas_controller.dart';

class CreateEvent extends StatelessWidget {
  final CalendarController calendarController = Get.put(CalendarController());
  final PetControllerv2 mascotas = Get.put(PetControllerv2());
  final HomeController homeController = Get.put(HomeController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.colorContainer,
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 168,
            decoration: BoxDecoration(
              color: Styles.colorContainer,
            ),
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Completa la Información',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontFamily: 'PoetsenOne',
                    ),
                  ),
                  SizedBox(height: 1),
                  Text(
                    'Añade los datos del evento',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontFamily: 'PoetsenOne',
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
              child: Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: SingleChildScrollView(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 10),
                      InputText(
                        label: 'Nombre del Evento',
                        placeholder: 'Nombre del Evento',
                        onChanged: (value) {
                          calendarController.updateField(
                              'name', value.toString());
                          calendarController.updateField(
                              'slug', value.toString());
                        },
                      ),
                      const SizedBox(height: 10),
                      InputText(
                        label: 'Descripción del evento',
                        placeholder: 'Describe el evento',
                        onChanged: (value) {
                          calendarController.updateField('description', value);
                        },
                      ),
                      const SizedBox(height: 10),
                      InputText(
                        label: 'Ubicación',
                        placeholder: '',
                        onChanged: (value) {
                          calendarController.updateField('location', value);
                        },
                      ),
                      const SizedBox(height: 10),
                      InputText(
                        label: 'Fecha del evento',
                        placeholder: 'Fecha del evento',
                        isDateField: true,
                        onChanged: (value) {
                          calendarController.updateField('date', value);
                        },
                        suffixIcon: const Icon(
                          Icons.arrow_drop_down,
                          color: Styles.fiveColor,
                        ),
                        prefiIcon: const Icon(
                          Icons.calendar_today,
                          color: Styles.fiveColor,
                        ),
                      ),
                      const SizedBox(height: 10),
                      InputText(
                        label: 'Hora del evento',
                        placeholder: 'Hora del evento',
                        isTimeField: true,
                        onChanged: (value) {
                          calendarController.updateField('event_time', value);
                        },
                        suffixIcon: const Icon(
                          Icons.arrow_drop_down,
                          color: Styles.fiveColor,
                        ),
                        prefiIcon: const Icon(
                          Icons.access_time_filled,
                          color: Styles.fiveColor,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        width: 302,
                        child: const Text(
                          'Selecciona la mascota vinculada a este evento',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontFamily: 'Lato',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        width: 302,
                        height: 70,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: SelccionarMascota(),
                      ),
                      Container(
                        width: 302,
                        child: Divider(
                          color: Colors.grey,
                          thickness: 0.2,
                        ),
                      ),
                      const SizedBox(height: 30),
                      Container(
                        width: 302,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: const Text(
                                'Invitar Personas a este Evento',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontFamily: 'PoetsenOne',
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 100,
                              right: 16,
                              child: FloatingActionButton(
                                elevation: 5,
                                onPressed: () {
                                  // Acción al presionar el botón flotante
                                  _showMyDialog(context);
                                },
                                backgroundColor: Styles.fiveColor,
                                child:
                                    const Icon(Icons.add, color: Colors.white),
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      Obx(() {
                        return Container(
                          width: 302,
                          child: ButtonDefaultWidget(
                            title: calendarController.isLoading.value
                                ? 'Guardando...'
                                : 'Finalizar',
                            callback: () {
                              calendarController.updateField("pet_id",
                                  homeController.selectedProfile.value!.id);
                              print("${calendarController.event.value ?? ''}");
                              calendarController.getEventos();
                              calendarController.postEvent();
                              if (calendarController.isSuccess.value) {
                                Get.back();
                              }
                            },
                          ),
                        );
                      }),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
          )),
        ],
      ),
    );
  }

  Future<void> _showMyDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible:
          false, // El usuario debe presionar un botón para cerrar el modal
      builder: (BuildContext context) {
        return Container(
          width: 302, // Ancho del modal
          height: 396, // Alto del modal

          child: AlertDialog(
            title: Text('Invita una persona'),
            content: SingleChildScrollView(
              child: Container(
                  width: 302,
                  height: 396,
                  decoration: BoxDecoration(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      InputText(
                        suffixIcon: Icon(
                          Icons.email,
                          color: Styles.fiveColor,
                          size: 24,
                        ),
                        label: '',
                        placeholder: 'Correo Electrónico',
                        onChanged: (value) {},
                      ),
                    ],
                  )),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
