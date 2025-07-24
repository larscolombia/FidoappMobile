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
import 'package:pawlly/modules/helper/helper.dart';
import 'package:pawlly/modules/home/controllers/home_controller.dart';
import 'package:pawlly/modules/home/screens/pages/profile_dogs.dart';
import 'package:pawlly/modules/integracion/controller/calendar_controller/calendar_controller.dart';
import 'package:pawlly/modules/integracion/controller/user_type/user_controller.dart';
import 'package:pawlly/modules/integracion/model/calendar/calendar_model.dart';
import 'package:pawlly/modules/integracion/model/user_type/user_datails.dart';
import 'package:pawlly/modules/integracion/model/user_type/user_model.dart';
import 'package:pawlly/services/auth_service_apis.dart';
import 'package:pawlly/components/custom_snackbar.dart';

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
  var eventCreator = Rxn<User>(); // Para almacenar la información del creador del evento
  
  @override
  void initState() {
    super.initState();

    var ownerIds = event!.owners.map((owner) => owner.id ?? 0).toList();

    userController.fetchMultipleOwners(ownerIds); // Cargar todos los dueños
    
    // Cargar información del creador del evento
    if (event?.userId != null) {
      _loadEventCreator(event!.userId!);
    }
  }
  
  // Función para cargar la información del creador del evento
  Future<void> _loadEventCreator(int userId) async {
    try {
      final creator = await userController.fetchUserById(userId);
      if (creator != null) {
        eventCreator.value = creator;
      }
    } catch (e) {
      print('Error al cargar creador del evento: $e');
    }
  }
  
  // Función para convertir el valor del backend al valor de display
  String _convertBackendValueToDisplay(String? backendValue) {
    switch (backendValue) {
      case 'evento':
        return 'Evento';
      case 'medico':
        return 'Médico';
      case 'entrenamiento':
        return 'Entrenamiento';
      default:
        return 'Evento';
    }
  }
  
  // Función para guardar los cambios del evento
  Future<void> _saveEventChanges() async {
    try {
      // Actualizar los datos del evento en el calendarController
      calendarController.updateField('id', event?.id ?? '');
      calendarController.updateField('name', event?.name ?? '');
      calendarController.updateField('description', event?.description ?? '');
      calendarController.updateField('location', event?.location ?? '');
      calendarController.updateField('date', event?.date ?? '');
      calendarController.updateField('event_time', event?.eventime ?? '');
      calendarController.updateField('tipo', event?.tipo ?? '');
      calendarController.updateField('pet_id', event?.petId ?? '');
      
      // Llamar al método de actualización del evento
      await calendarController.updateEvent();
      
      // Salir del modo de edición
      calendarController.setEdit();
      
      // Mostrar mensaje de éxito
      CustomSnackbar.show(
        title: "Éxito",
        message: "Evento actualizado correctamente",
        isError: false,
      );
      
      // Regresar a la pantalla anterior
      Get.back();
      
    } catch (e) {
      print('Error al guardar cambios del evento: $e');
      CustomSnackbar.show(
        title: "Error",
        message: "No se pudo actualizar el evento",
        isError: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final event = Get.arguments as CalendarModel?;
    var petData = homeController.getPetById(event?.petId);
    
    // Usar addPostFrameCallback para evitar actualizaciones durante el build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (petData != null && petData.id != 0) {
        homeController.updateProfile(petData);
      }
    });

    if (event?.owners.isNotEmpty == true) {
      userController.filterUsers(event!.owners.first.email);
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
                        child: Container(
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
                        padding: EdgeInsets.only(
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
                                        return calendarController.isEdit.value
                                            ? SizedBox.shrink() // No mostrar nada en modo edición
                                            : Editar(
                                                coloredit: Colors.white,
                                                callback: () {
                                                  userController.filterUsers(
                                                      '${event?.owners.first.email}');
                                                  calendarController.setEdit();
                                                },
                                              );
                                      })
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),
                              Container(
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
                              // Ubicación del evento
                              SizedBox(
                                width: MediaQuery.sizeOf(context).width,
                                height: height,
                                child: InputText(
                                  placeholder: '',
                                  onChanged: (value) => event?.location = value,
                                  initialValue: event?.location ?? "",
                                  label: 'Ubicación',
                                  readOnly: !calendarController.isEdit.value,
                                ),
                              ),
                              SizedBox(height: margen),
                              // Creador del evento
                              Container(
                                width: MediaQuery.sizeOf(context).width,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Obx(() {
                                      final creator = eventCreator.value;
                                      
                                      // Si aún no se ha cargado la información del creador, mostrar indicador de carga
                                      if (creator == null && event?.userId != null) {
                                        return Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
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
                                              child: Container(
                                                padding: EdgeInsets.all(16),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(16),
                                                  border: Border.all(
                                                    color: const Color(0xFFEFEFEF),
                                                    width: 1,
                                                  ),
                                                ),
                                                child: Row(
                                                  children: [
                                                    SizedBox(
                                                      width: 20,
                                                      height: 20,
                                                      child: CircularProgressIndicator(
                                                        strokeWidth: 2,
                                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                                                      ),
                                                    ),
                                                    SizedBox(width: 12),
                                                    Text(
                                                      'Cargando información del creador...',
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.grey,
                                                        fontFamily: 'Lato',
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      }
                                      
                                      // Si ya se cargó la información del creador
                                      return Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
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
                                              nombre: creator?.firstName ?? 'Usuario',
                                              imageUrl: creator?.profileImage ?? '',
                                              profesion: Helper.tipoUsuario(creator?.userType ?? ''),
                                            ),
                                          ),
                                        ],
                                      );
                                    }),
                                  ],
                                ),
                              ),
                              SizedBox(height: margen),
                              // Descripción del evento
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
                              // Tipo de evento
                              SizedBox(
                                width: MediaQuery.sizeOf(context).width,
                                height: height,
                                child: InputText(
                                  placeholder: '',
                                  onChanged: (value) => event?.tipo = value,
                                  initialValue: _convertBackendValueToDisplay(event?.tipo),
                                  label: 'Tipo de evento',
                                  readOnly: true, // Siempre en solo lectura
                                ),
                              ),
                              SizedBox(height: margen),
                              SizedBox(
                                width: MediaQuery.sizeOf(context).width,
                                height: height,
                                child: InputText(
                                  placeholderSvg:
                                      'assets/icons/svg/calendar.svg',
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
                                    Divider(
                                      thickness: 1,
                                      color: const Color(0xFFEFEFEF),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: margen),
                              // Ocultar "Invitar Personas" en todos los casos
                              if (false) // Nunca mostrar el botón de invitar personas
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
                                            // Configurar el tipo de usuario según el tipo del evento
                                            String userType = 'all'; // Por defecto
                                            if (event?.tipo == 'medico') {
                                              userType = 'vet';
                                            } else if (event?.tipo == 'entrenamiento') {
                                              userType = 'trainer';
                                            }
                                            
                                            // Configurar el tipo en el userController
                                            userController.type.value = userType;
                                            
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
                              // Mostrar "Personas invitadas" en ambos modos
                              if (true) // Siempre mostrar el texto
                                Container(
                                  width: MediaQuery.sizeOf(context).width,
                                  child: const Text(
                                    'Personas invitadas:',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w800,
                                      fontFamily: 'Lato',
                                    ),
                                  ),
                                ),
                              SizedBox(
                                width: MediaQuery.sizeOf(context).width,
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
                                              showArrow: false,
                                            );
                                          }).toList()
                                        ],
                                      );
                                    }),
                                  ],
                                ),
                              ),
                              SizedBox(height: margen),
                              // Botones de acción en modo edición
                              if (calendarController.isEdit.value &&
                                  event?.invited != true)
                                Column(
                                  children: [
                                    SizedBox(height: 20),
                                    // Botón Guardar
                                    SizedBox(
                                      width: MediaQuery.sizeOf(context).width,
                                      height: 50,
                                      child: ButtonDefaultWidget(
                                        title: 'Guardar',
                                        callback: () {
                                          _saveEventChanges();
                                        },
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    // Botón Cancelar
                                    SizedBox(
                                      width: MediaQuery.sizeOf(context).width,
                                      height: 50,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(color: Colors.grey),
                                        ),
                                        child: Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                            borderRadius: BorderRadius.circular(8),
                                            onTap: () {
                                              calendarController.setEdit();
                                            },
                                            child: Container(
                                              alignment: Alignment.center,
                                              child: Text(
                                                'Cancelar',
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              // Botón Editar en modo visualización
                              if (!calendarController.isEdit.value &&
                                  event?.invited != true)
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
