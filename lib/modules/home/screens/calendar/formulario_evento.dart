import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:pawlly/components/button_default_widget.dart';
import 'package:pawlly/components/custom_select_form_field_widget.dart';
import 'package:pawlly/modules/components/fabrica_seleccion_perfil.dart';
import 'package:pawlly/modules/components/input_text.dart';
import 'package:pawlly/modules/components/regresr_components.dart';
import 'package:pawlly/modules/components/select_user.dart';
import 'package:pawlly/modules/components/style.dart';
import 'package:pawlly/modules/home/controllers/home_controller.dart';
import 'package:pawlly/modules/integracion/controller/calendar_controller/calendar_controller.dart';
import 'package:pawlly/modules/integracion/controller/historial_clinico/historial_clinico_controller.dart';
import 'package:pawlly/modules/integracion/controller/mascotas/mascotas_controller.dart';
import 'package:pawlly/modules/integracion/controller/notificaciones/notificaciones_controller.dart';
import 'package:pawlly/modules/integracion/controller/user_type/user_controller.dart';

class CreateEvent extends StatelessWidget {
  final CalendarController calendarController = Get.put(CalendarController());
  final PetControllerv2 mascotas = Get.put(PetControllerv2());
  final HomeController homeController = Get.put(HomeController());
  final UserController userController = Get.put(UserController());
  final NotificationController notificationController =
      Get.put(NotificationController());
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
                      BarraBack(
                        titulo: 'Evento Nuevo',
                        callback: () {
                          Get.back();
                        },
                      ),
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
                      Container(
                          width: 302,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Categoria del evento',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                      fontFamily: 'lato'),
                                ),
                                const SizedBox(height: 10),
                                CustomSelectFormFieldWidget(
                                  onChange: (value) => calendarController
                                      .updateField('tipo', value),
                                  items: [
                                    'salud',
                                    'entrenamiento',
                                  ],
                                  icon: "assets/icons/paginas.png",
                                  controller: null,
                                  placeholder: 'Tipo de evento ',
                                ),
                              ])),
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
                          color: Styles.iconColor,
                        ),
                        prefiIcon: const Icon(
                          Icons.calendar_today,
                          color: Styles.iconColor,
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
                      const SizedBox(height: 10),
                      InputText(
                        label: 'Fecha final del evento',
                        placeholder: 'Fecha final del evento',
                        isDateField: true,
                        onChanged: (value) {
                          calendarController.updateField('end_date', value);
                        },
                        suffixIcon: const Icon(
                          Icons.arrow_drop_down,
                          color: Styles.iconColor,
                        ),
                        prefiIcon: const Icon(
                          Icons.calendar_today,
                          color: Styles.iconColor,
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
                        var user = userController.filteredUsers;
                        if (user.isEmpty) {
                          return const SizedBox(
                            width: 302,
                            child: Text(
                                'No hay usuario seleccionado para este evento'),
                          );
                        }

                        return Container(
                          width: 305,
                          child: SelectedAvatar(
                            nombre: user.first.firstName,
                            imageUrl: user.first.profileImage,
                          ),
                        );
                      }),
                      const SizedBox(height: 30),
                      Obx(() {
                        return Container(
                          width: 302,
                          child: ButtonDefaultWidget(
                            title: calendarController.isLoading.value
                                ? 'Guardando...'
                                : 'Finalizar',
                            callback: () async {
                              // Actualizar campos
                              calendarController.updateField("pet_id",
                                  homeController.selectedProfile.value!.id);
                              notificationController.updateField("pet_id",
                                  homeController.selectedProfile.value!.id);
                              notificationController.updateField(
                                  "category_id", 1);
                              notificationController.updateField("date",
                                  calendarController.event.value!['date']);
                              notificationController.updateField("actividad",
                                  calendarController.event.value!['name']);
                              notificationController.updateField(
                                  "notas",
                                  calendarController
                                      .event.value!['description']);

                              print("${calendarController.event.value ?? ''}");

                              if (calendarController
                                  .validateEvent(calendarController.event)) {
                                // Asegúrate de que el proceso sea esperado
                                await calendarController
                                    .postEvent(); // Espera a que se complete la petición
                                await notificationController
                                    .submitNotificacion(); // Espera a que se complete la notificación
                                await calendarController
                                    .getEventos(); // Espera la obtención de eventos

                                // Solo regresa si no está cargando
                                if (!calendarController.isLoading.value) {
                                  Get.back();
                                }
                              } else {
                                Get.snackbar(
                                  "Campos incompletos",
                                  "Por favor, rellene todos los campos.",
                                  snackPosition: SnackPosition.BOTTOM,
                                );
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
                        onChanged: (value) => userController.filterUsers(value),
                      ),
                      const SizedBox(height: 20),
                      Obx(() {
                        var user = userController.filteredUsers;
                        if (user.isEmpty) {
                          return Text("Seleccione un usuario");
                        }

                        return SelectedAvatar(
                          nombre: userController.filteredUsers.first.firstName,
                          imageUrl:
                              userController.filteredUsers.first.profileImage,
                        );
                      }),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: 300,
                        child: ButtonDefaultWidget(
                          title: 'Invitar Persona',
                          callback: () {
                            print(userController.filteredUsers.first.id);
                            calendarController.updateField('owner_id',
                                userController.filteredUsers.first.id);
                            Navigator.of(context).pop();
                          },
                        ),
                      )
                    ],
                  )),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('CLOSE'),
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
