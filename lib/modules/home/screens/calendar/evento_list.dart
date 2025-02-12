import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pawlly/components/button_default_widget.dart';
import 'package:pawlly/modules/components/border_redondiado.dart';
import 'package:pawlly/modules/components/editar.dart';
import 'package:pawlly/modules/components/input_text.dart';
import 'package:pawlly/modules/components/regresr_components.dart';
import 'package:pawlly/modules/components/select_user.dart';
import 'package:pawlly/modules/components/style.dart';
import 'package:pawlly/modules/components/user_select.dart';
import 'package:pawlly/modules/home/controllers/home_controller.dart';
import 'package:pawlly/modules/home/screens/pages/profile_dogs.dart';
import 'package:pawlly/modules/integracion/controller/calendar_controller/calendar_controller.dart';
import 'package:pawlly/modules/integracion/controller/user_type/user_controller.dart';
import 'package:pawlly/modules/integracion/model/calendar/calendar_model.dart';

class EventoDestalles extends StatelessWidget {
  final calendarController = Get.find<CalendarController>();
  final HomeController homeController = Get.find<HomeController>();
  final UserController userController = Get.put(UserController());

  EventoDestalles({super.key});

  @override
  Widget build(BuildContext context) {
    final eventos = calendarController.selectedEvents.first;
    var petData = homeController.getPetById(eventos.petId);
    final event = Get.arguments as CalendarModel?;
    homeController.updateProfile(petData);

    if (eventos.owners.isNotEmpty) {
      userController.filterUsers(eventos.owners.first.email);
    }

    print('evento en la pantalla ${json.encode(event)}');
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(slivers: [
        SliverList(
          delegate: SliverChildListDelegate([
            Container(
              height: 180,
              decoration: const BoxDecoration(
                color: Styles.colorContainer,
              ),
              child: Stack(
                children: [
                  const BorderRedondiado(top: 160),
                  Positioned(
                    top: 100,
                    left: 0,
                    right: 0,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 100,
                      child: const Text(
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
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Container(
                    padding: Styles.paddingAll,
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: BarraBack(
                            titulo: 'Sobre este Evento',
                            callback: () {
                              Get.back();
                            },
                          ),
                        ),
                        Obx(() {
                          return Editar(
                            coloredit: !calendarController.isEdit.value
                                ? const Color.fromARGB(255, 107, 106, 106)
                                : Styles.colorContainer,
                            callback: () {
                              if (eventos.owners.isNotEmpty) {
                                userController
                                    .filterUsers(eventos.owners.first.email);
                              }
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
                      padding: Styles.paddingAll,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: [
                          InputText(
                            placeholder: '',
                            onChanged: (value) => event?.name = value,
                            initialValue: event?.name ?? "",
                            label: 'Nombre del Evento',
                            readOnly: !calendarController.isEdit.value,
                          ),
                          const SizedBox(height: 20),
                          InputText(
                            isTextArea: true,
                            placeholder: '',
                            onChanged: (value) => event?.description = value,
                            initialValue: event?.description ?? "",
                            label: 'Descripción del evento',
                            readOnly: !calendarController.isEdit.value,
                          ),
                          const SizedBox(height: 20),
                          InputText(
                            prefiIcon: const Icon(
                              Icons.calendar_today,
                              color: Styles.iconColor,
                            ),
                            placeholder: '',
                            isDateField: true,
                            onChanged: (value) => event?.date = value,
                            initialValue: event?.date ?? "",
                            label: 'Fecha del evento',
                            readOnly: !calendarController.isEdit.value,
                          ),
                          const SizedBox(height: 20),
                          InputText(
                            prefiIcon: const Icon(
                              Icons.timer,
                              color: Styles.iconColor,
                            ),
                            placeholder: '',
                            isTimeField: true,
                            onChanged: (value) => event?.eventime = value,
                            initialValue: event?.eventime ?? "",
                            label: 'Hora del evento',
                            readOnly: !calendarController.isEdit.value,
                          ),
                          const SizedBox(height: 20),
                          InputText(
                            prefiIcon: const Icon(
                              Icons.calendar_today,
                              color: Styles.iconColor,
                            ),
                            placeholder: '',
                            isDateField: true,
                            onChanged: (value) => event?.endDate = value,
                            initialValue: event?.endDate ?? "",
                            label: 'Fecha final del evento',
                            readOnly: !calendarController.isEdit.value,
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Mascota selecionada:',
                                  style: Styles.AvatarComentario,
                                ),
                                ProfilesDogs(
                                  isTapEnabled: false,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Usuario Seleccionado',
                                  style: Styles.AvatarComentario,
                                ),
                                const SizedBox(height: 10),
                                UserEventoSeleccionado(),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: 302,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  child: const Text(
                                    'Cambiar Evento',
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
                                    child: const Icon(Icons.add,
                                        color: Colors.white),
                                  ),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(height: 30),
                          if (calendarController.isEdit.value)
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: 50,
                              child: Stack(
                                children: [
                                  ButtonDefaultWidget(
                                    title: 'editar',
                                    callback: calendarController.isLoading.value
                                        ? null // Deshabilitar el botón cuando está cargando
                                        : () {
                                            print(
                                                'evento editr  ${json.encode(event)}');
                                            calendarController
                                                .updateEvento(event!);
                                          },
                                  ),
                                  if (calendarController.isLoading.value)
                                    Positioned.fill(
                                      child: Container(
                                        child: const Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                      ),
                                    ),
                                ],
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

  Future<void> _showMyDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible:
          false, // El usuario debe presionar un botón para cerrar el modal
      builder: (BuildContext context) {
        return SizedBox(
          width: 302, // Ancho del modal
          height: 396, // Alto del modal

          child: AlertDialog(
            title: const Text('Invita una persona'),
            content: SingleChildScrollView(
              child: Container(
                  width: 302,
                  height: 396,
                  decoration: const BoxDecoration(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      InputText(
                        suffixIcon: const Icon(
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
                          return const Text("Seleccione un usuario");
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
                      SizedBox(
                        width: 300,
                        child: ButtonDefaultWidget(
                          title: 'Invitar Persona',
                          callback: () {
                            calendarController.updateField('owner_id',
                                [userController.filteredUsers.first.id]);
                            userController.deselectUser();
                            userController.selectedUser(
                                userController.filteredUsers.first);
                            calendarController.updateField('owner_id',
                                [userController.filteredUsers.first.id ?? -1]);
                            Navigator.of(context).pop();
                          },
                        ),
                      )
                    ],
                  )),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('CLOSE'),
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
