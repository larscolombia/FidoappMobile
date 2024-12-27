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

class EventoDestalles extends StatelessWidget {
  final calendarController = Get.find<CalendarController>();
  final HomeController homeController = Get.find<HomeController>();
  final UserController userController = Get.put(UserController());

  EventoDestalles({super.key});

  @override
  Widget build(BuildContext context) {
    final eventos = calendarController.selectedEvents.first;
    var petData = homeController.getPetById(eventos.petId);

    homeController.updateProfile(petData);

    userController.filterUsers('${eventos.owners.first.email}');
    userController.selectedUser(userController.filteredUsers.first);

    calendarController.updateField(
        'evenId', eventos.id ?? -1); // Añadido para el id de la mascota
    calendarController.updateField('pet_id', eventos.petId ?? -1);
    calendarController.updateField('name', eventos.name ?? '');
    calendarController.updateField('description', eventos.description ?? '');
    calendarController.updateField('start_date', eventos.startDate ?? '');
    calendarController.updateField('end_date', eventos.endDate ?? '');
    calendarController.updateField('date', eventos.date ?? '');
    calendarController.updateField('event_time', eventos.date ?? "");
    calendarController.updateField('slug', eventos.slug ?? "");
    calendarController.updateField('user_id', eventos.userId ?? -1);
    calendarController.updateField('tipo', eventos.tipo ?? "");
    calendarController.updateField('status', eventos.status ?? "");
    calendarController.updateField('location', eventos.location ?? "");
    calendarController.updateField('owner_id', [eventos.owners.first.id ?? -1]);
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
                  SizedBox(
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
                                ? const Color.fromARGB(255, 107, 106, 106)
                                : Styles.colorContainer,
                            callback: () {
                              userController
                                  .filterUsers('${eventos.owners.first.email}');

                              calendarController.setEdit();
                            },
                          );
                        })
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  Obx(() {
                    return SizedBox(
                      width: MediaQuery.of(context).size.width - 100,
                      child: Column(
                        children: [
                          InputText(
                            placeholder: '',
                            onChanged: (value) =>
                                calendarController.updateField('name', value),
                            initialValue:
                                calendarController.selectedEvents.first.name,
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
                            prefiIcon: const Icon(
                              Icons.calendar_today,
                              color: Styles.iconColor,
                            ),
                            placeholder: '',
                            isDateField: true,
                            onChanged: (value) => calendarController
                                .updateField('start_date', value),
                            initialValue: eventos.startDate,
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
                            onChanged: (value) => calendarController
                                .updateField('event_time', value),
                            initialValue: eventos.date ?? '',
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
                            onChanged: (value) =>
                                calendarController.updateField('date', value),
                            initialValue: eventos.endDate,
                            label: 'Fecha del evento',
                            readOnly: !calendarController.isEdit.value,
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: MediaQuery.of(context).size.width - 100,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Mascota selecionada:',
                                  style: Styles.AvatarComentario,
                                ),
                                ProfilesDogs(),
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
                              width: MediaQuery.of(context).size.width - 80,
                              height: 50,
                              child: ButtonDefaultWidget(
                                title: calendarController.isLoading.value
                                    ? 'cargando ... '
                                    : 'editar',
                                callback: () {
                                  calendarController.updateField(
                                      'slug', 'slug editado');
                                  print(
                                      'evento editr  ${calendarController.event}');
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
