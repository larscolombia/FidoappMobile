import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pawlly/components/button_default_widget.dart';
import 'package:pawlly/modules/components/border_redondiado.dart';
import 'package:pawlly/modules/components/editar.dart';
import 'package:pawlly/modules/components/input_date.dart';
import 'package:pawlly/modules/components/input_text.dart';
import 'package:pawlly/modules/components/regresr_components.dart';
import 'package:pawlly/modules/components/select_user.dart';
import 'package:pawlly/modules/components/style.dart';
import 'package:pawlly/modules/helper/date_helper.dart';
import 'package:pawlly/modules/helper/helper.dart';
import 'package:pawlly/modules/home/controllers/home_controller.dart';
import 'package:pawlly/modules/home/screens/pages/profile_dogs.dart';
import 'package:pawlly/modules/integracion/controller/calendar_controller/calendar_controller.dart';
import 'package:pawlly/modules/integracion/controller/user_type/user_controller.dart';
import 'package:pawlly/modules/integracion/model/calendar/calendar_model.dart';
import 'package:pawlly/modules/integracion/model/user_type/user_datails.dart';
import 'package:pawlly/services/auth_service_apis.dart';

class EventoDestalles extends StatefulWidget {
  const EventoDestalles({super.key});

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
    homeController.updateSelectedProfile(petData);

    if (eventos.owners.isNotEmpty) {
      userController.filterUsers(eventos.owners.first.email);
    }

    //print('evento en la pantalla ${json.encode(event)}');
    var margen = Helper.margenDefault;
    var height = 99.0;
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
                        child: SizedBox(
                          width: MediaQuery.sizeOf(context).width,
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
                        padding: const EdgeInsets.only(
                          left: Styles.padding,
                          right: Styles.padding,
                        ),
                        child: Container(
                          child: Column(
                            children: [
                              SizedBox(
                                width: MediaQuery.sizeOf(context).width,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.sizeOf(context).width -
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
                                                  ? Colors.white
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
                              SizedBox(
                                width: MediaQuery.sizeOf(context).width,
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
                              SizedBox(
                                width: MediaQuery.sizeOf(context).width,
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
                                    SizedBox(
                                      width: MediaQuery.sizeOf(context).width,
                                      child: SelectedAvatar(
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
                                width: MediaQuery.sizeOf(context).width,
                                height: height,
                                child: InputDate(
                                  label: 'Fecha del evento',
                                  placeholderSvg: 'assets/icons/svg/calendar.svg',
                                  readOnly: !calendarController.isEdit.value,
                                  initialValue: DateHelper.dateFromUiShortString(event?.date) ?? DateTime.now(),
                                  firstDate: DateHelper.firstDate,
                                  lastDate: DateHelper.lastDate,
                                  onChanged: (value) {
                                    event?.startDate = DateHelper.formatUiDateShort(value);
                                  }
                                ),
                              ),
                              SizedBox(height: margen),
                              SizedBox(
                                width: MediaQuery.sizeOf(context).width,
                                height: height,
                                child: InputText(
                                  placeholderSvg: 'assets/icons/svg/hora.svg',
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
                                width: MediaQuery.sizeOf(context).width,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      width: 226,
                                      child: Text(
                                        'Selecciona la mascota vinculada a este evento',
                                        style: TextStyle(
                                            fontFamily: 'Lato',
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Color(0xFF383838)),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(
                                          color: const Color(0xFFEFEFEF),
                                          width: 1,
                                        ),
                                      ),
                                      child: ProfilesDogs(
                                        disableTap: true,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    const Divider(
                                      thickness: 1,
                                      color: Color(0xFFEFEFEF),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: margen),
                              if (event?.invited !=
                                  true) // Verificar si no es invitado
                                SizedBox(
                                  width: MediaQuery.sizeOf(context).width,
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
                                            fontWeight: FontWeight.w800,
                                            fontFamily: 'Lato',
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: FloatingActionButton(
                                          elevation: 0,
                                          onPressed: () {
                                            // Acción al presionar el botón flotante
                                            Helper.showMyDialog(
                                                context, userController);
                                          },
                                          backgroundColor: Styles.fiveColor,
                                          child: const Icon(Icons.add,
                                              color: Colors.white),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              SizedBox(
                                width: MediaQuery.sizeOf(context).width,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Obx(() {
                                      if (userController.isLoading.value) {
                                        return const CircularProgressIndicator();
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
                                          })
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
                                  width: MediaQuery.sizeOf(context).width,
                                  height: 50,
                                  child: ButtonDefaultWidget(
                                    title: 'Editar',
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
}
