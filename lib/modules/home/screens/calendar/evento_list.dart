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
import 'package:pawlly/modules/helper/helper.dart';
import 'package:pawlly/modules/home/controllers/home_controller.dart';
import 'package:pawlly/modules/home/screens/pages/profile_dogs.dart';
import 'package:pawlly/modules/integracion/controller/calendar_controller/calendar_controller.dart';
import 'package:pawlly/modules/integracion/controller/user_type/user_controller.dart';
import 'package:pawlly/modules/integracion/model/calendar/calendar_model.dart';
import 'package:pawlly/modules/integracion/model/user_type/user_datails.dart';
import 'package:pawlly/services/auth_service_apis.dart';

class EventoDestalles extends StatefulWidget {
  EventoDestalles({super.key});

  @override
  _EventoDestallesState createState() => _EventoDestallesState();
}

class _EventoDestallesState extends State<EventoDestalles> {
  final calendarController = Get.find<CalendarController>();
  final HomeController homeController = Get.find<HomeController>();
  final UserController userController = Get.put(UserController());
  final event = Get.arguments as CalendarModel?;
  var userSelected = <UserDetail>[].obs;
  @override
  void initState() {
    super.initState();

    var ownerIds = event!.owners.map((owner) => owner.id ?? 0).toList();

    userController.fetchMultipleOwners(ownerIds); // Cargar todos los dueños
  }

  @override
  Widget build(BuildContext context) {
    final eventos = calendarController.selectedEvents.first;
    var petData = homeController.getPetById(eventos.petId);
    final event = Get.arguments as CalendarModel?;
    homeController.updateProfile(petData);

    if (eventos.owners.isNotEmpty) {
      userController.filterUsers(eventos.owners.first.email);
    }

    //print('evento en la pantalla ${json.encode(event)}');
    var margen = Helper.margenDefault;
    var height = 97.0;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          CustomScrollView(slivers: [
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
                        top: 50,
                        left: 0,
                        right: 0,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 100,
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                textAlign: TextAlign.center,
                                'Completa la Información',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                textAlign: TextAlign.center,
                                'Añade los datos de tu mascota',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontFamily: 'Lato',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Column(
                  children: [
                    Obx(() {
                      return Padding(
                        padding: EdgeInsets.only(
                          left: Styles.padding,
                          right: Styles.padding,
                        ),
                        child: Container(
                          child: Column(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width -
                                          110,
                                      child: BarraBack(
                                        titulo: 'Sobre este Evento',
                                        callback: () {
                                          Get.back();
                                        },
                                      ),
                                    ),
                                    if (event?.invited !=
                                        true) // Verificar si no es invitado
                                      Obx(() {
                                        return Editar(
                                          coloredit:
                                              !calendarController.isEdit.value
                                                  ? const Color.fromARGB(
                                                      255, 107, 106, 106)
                                                  : Styles.colorContainer,
                                          callback: () {
                                            userController.filterUsers(
                                                '${eventos.owners.first.email}');

                                            calendarController.setEdit();
                                          },
                                        );
                                      })
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height: height,
                                child: InputText(
                                  placeholder: '',
                                  onChanged: (value) => event?.name = value,
                                  initialValue: event?.name ?? "w",
                                  label: 'Nombre del Evento',
                                  readOnly: !calendarController.isEdit.value,
                                ),
                              ),
                              SizedBox(height: margen),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Creador del evento:',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                        fontFamily: 'Lato',
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(height: margen - 8),
                                    SelectedAvatar(
                                      nombre: AuthServiceApis
                                              .dataCurrentUser.firstName ??
                                          '',
                                      imageUrl: AuthServiceApis
                                              .dataCurrentUser.profileImage ??
                                          '',
                                      profesion: Helper.tipoUsuario(
                                          AuthServiceApis
                                                  .dataCurrentUser.userType ??
                                              ''),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: margen),
                              InputText(
                                isTextArea: true,
                                placeholder: '',
                                onChanged: (value) =>
                                    event?.description = value,
                                initialValue: event?.description ?? "",
                                label: 'Descripción del evento',
                                readOnly: !calendarController.isEdit.value,
                              ),
                              SizedBox(height: margen),
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                height: height,
                                child: InputText(
                                  prefiIcon: const Icon(
                                    Icons.calendar_today,
                                    color: Styles.iconColor,
                                  ),
                                  placeholder: '',
                                  isDateField: true,
                                  onChanged: (value) =>
                                      event?.startDate = value,
                                  initialValue: event?.date ?? "",
                                  label: 'Fecha del evento',
                                  readOnly: !calendarController.isEdit.value,
                                ),
                              ),
                              SizedBox(height: margen),
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                height: height,
                                child: InputText(
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
                              ),
                              SizedBox(height: margen),
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      width: 200,
                                      child: Text(
                                        'Selecciona la mascota vinculada a este evento',
                                        style: Styles.AvatarComentario,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    ProfilesDogs(disableTap: true),
                                  ],
                                ),
                              ),
                              SizedBox(height: margen),
                              if (event?.invited !=
                                  true) // Verificar si no es invitado
                                SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  height: 60,
                                  child: Stack(
                                    children: [
                                      const Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          'Invitar Personas a este Evento',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black,
                                            fontFamily: 'PoetsenOne',
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: FloatingActionButton(
                                          elevation: 0,
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
                              Container(
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Obx(() {
                                      if (userController.isLoading.value) {
                                        return CircularProgressIndicator();
                                      }

                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(height: 10),
                                          ...userController.usersDetails
                                              .map((user) {
                                            return SelectedAvatar(
                                              nombre: user.fullName ?? '',
                                              imageUrl: user.profileImage ?? '',
                                              profesion: Helper.tipoUsuario(
                                                  user.userType ?? ''),
                                            );
                                          }).toList()
                                        ],
                                      );
                                    }),
                                  ],
                                ),
                              ),
                              SizedBox(height: margen),
                              if (calendarController.isEdit.value &&
                                  event?.invited !=
                                      true) // Verificar si no es invitado
                                SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  height: 50,
                                  child: ButtonDefaultWidget(
                                    title: 'editar',
                                    callback: () {
                                      print(
                                          'evento editr  ${json.encode(event)}');
                                      calendarController.updateEvento(event!);
                                    },
                                  ),
                                ),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ]),
            ),
          ]),
          Obx(() {
            if (calendarController.isLoading.value) {
              return Container(
                color: Colors.black.withOpacity(0.5),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else {
              return const SizedBox.shrink();
            }
          }),
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
        return SizedBox(
          width: 302, // Ancho del modal
          height: 396, // Alto del modal

          child: AlertDialog(
            title: const Text('Invita una persona',
                style: TextStyle(
                  fontSize: 20,
                  color: Styles.fiveColor,
                  fontFamily: 'Lato',
                )),
            content: SingleChildScrollView(
              child: Container(
                  width: 302,
                  height: 300,
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
