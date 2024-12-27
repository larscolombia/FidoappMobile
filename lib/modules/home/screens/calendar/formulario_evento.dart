import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:pawlly/components/button_default_widget.dart';
import 'package:pawlly/components/custom_select_form_field_widget.dart';
import 'package:pawlly/models/pet_profile_model.dart';
import 'package:pawlly/modules/components/fabrica_seleccion_perfil.dart';
import 'package:pawlly/modules/components/input_select.dart';
import 'package:pawlly/modules/components/input_text.dart';
import 'package:pawlly/modules/components/regresr_components.dart';
import 'package:pawlly/modules/components/select_user.dart';
import 'package:pawlly/modules/components/style.dart';
import 'package:pawlly/modules/components/user_select.dart';
import 'package:pawlly/modules/home/controllers/home_controller.dart';
import 'package:pawlly/modules/home/screens/pages/profile_dogs.dart';
import 'package:pawlly/modules/integracion/controller/balance/balance_controller.dart';
import 'package:pawlly/modules/integracion/controller/balance/producto_pay_controller.dart';
import 'package:pawlly/modules/integracion/controller/calendar_controller/calendar_controller.dart';
import 'package:pawlly/modules/integracion/controller/historial_clinico/historial_clinico_controller.dart';
import 'package:pawlly/modules/integracion/controller/lista_categoria_servicio/category_controller.dart';
import 'package:pawlly/modules/integracion/controller/mascotas/mascotas_controller.dart';
import 'package:pawlly/modules/integracion/controller/notificaciones/notificaciones_controller.dart';
import 'package:pawlly/modules/integracion/controller/servicio_entrenador_categoria/servicio_entrenador_categoria_controller.dart';
import 'package:pawlly/modules/integracion/controller/user_type/user_controller.dart';
import 'package:pawlly/modules/integracion/model/balance/producto_pay_model.dart';

class CreateEvent extends StatelessWidget {
  final CalendarController calendarController = Get.put(CalendarController());
  final PetControllerv2 mascotas = Get.put(PetControllerv2());
  final HomeController homeController = Get.put(HomeController());
  final UserController userController = Get.put(UserController());
  final CategoryControllerVet categoryController =
      Get.put(CategoryControllerVet());
  final NotificationController notificationController =
      Get.put(NotificationController());

  final ServiceEntrenadorController serviceController =
      Get.put(ServiceEntrenadorController());

  final UserBalanceController balanceController =
      Get.put(UserBalanceController());
  ProductoPayController payController = Get.put(ProductoPayController());
  CreateEvent({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.colorContainer,
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 168,
            decoration: const BoxDecoration(
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
                      SizedBox(
                        width: 302,
                        child: BarraBack(
                          titulo: 'Evento Nuevo',
                          callback: () {
                            Get.back();
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      InputText(
                        label: 'Nombre del Evento',
                        placeholder: 'Nombre del Evento',
                        onChanged: (value) {
                          calendarController.updateField(
                            'name',
                            value.toString(),
                          );

                          calendarController.updateField(
                            'slug',
                            calendarController.Slug(value.toString()),
                          );
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
                      SizedBox(
                        width: 302,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
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
                                items: const [
                                  'evento',
                                  'medico',
                                  'entrenamiento',
                                ],
                                icon: "assets/icons/paginas.png",
                                controller: null,
                                placeholder: 'Tipo de evento ',
                                filcolorCustom: Styles.colorContainer,
                              ),
                            ]),
                      ),
                      const SizedBox(height: 8),
                      Obx(() {
                        if (calendarController.event['tipo'] != 'medico') {
                          return const SizedBox();
                        }

                        return Column(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width - 100,
                              child: InputSelect(
                                label: 'Servicio de evento medico',
                                placeholder: 'Servicio de evento medico',
                                TextColor: Colors.black,
                                onChanged: (value) {
                                  calendarController.updateField('category_id',
                                      value); // Actualizamos el controlador
                                  calendarController.updateField(
                                      'service_id', value);
                                  print('value $value');
                                  categoryController.fetchprecio(value ?? "");
                                },
                                items: categoryController.categories
                                    .map((category) => DropdownMenuItem<String>(
                                          value: category.id
                                              .toString(), // ID de la categoría como valor
                                          child: Text(category
                                              .name), // Nombre de la categoría como texto
                                        ))
                                    .toList(),
                              ),
                            ),
                            const SizedBox(height: 8),
                            SizedBox(
                              width: MediaQuery.of(context).size.width - 100,
                              height: 20,
                              child: Text(
                                  "Total del servicio ${calendarController.event['tipo']}: ${categoryController.totalAmount.value}f"),
                            ),
                          ],
                        );
                      }),
                      const SizedBox(height: 8),
                      Obx(() {
                        if (calendarController.event['tipo'] !=
                            'entrenamiento') {
                          return const SizedBox();
                        }

                        return Column(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width - 100,
                              child: InputSelect(
                                label: 'Servicio del entrenamiento',
                                placeholder: 'Servicio del entrenamiento',
                                TextColor: Colors.black,
                                onChanged: (value) {
                                  calendarController.updateField('category_id',
                                      value); // Actualizamos el controlador
                                  calendarController.updateField(
                                      'service_id', value);
                                },
                                items: serviceController.services
                                    .map(
                                      (category) => DropdownMenuItem<String>(
                                        value: category.id
                                            .toString(), // ID de la categoría como valor
                                        child: Text(category
                                            .name), // Nombre de la categoría como texto
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                            const SizedBox(height: 8),
                            SizedBox(
                              width: MediaQuery.of(context).size.width - 100,
                              height: 20,
                              child: Text(
                                  "Total del servicio ${calendarController.event['tipo']}: ${categoryController.totalAmount.value}f"),
                            ),
                          ],
                        );
                      }),
                      const SizedBox(height: 10),
                      InputText(
                        label: 'Fecha del evento',
                        placeholder: 'Fecha del evento',
                        isDateField: true,
                        onChanged: (value) {
                          calendarController.updateField(
                              'date', value.replaceAll('/', '-').toString());
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
                          calendarController.updateField('end_date',
                              value.replaceAll('/', '-').toString());
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
                      const SizedBox(
                        width: 302,
                        child: Text(
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
                        width: 340,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ProfilesDogs(),
                      ),
                      const SizedBox(
                        width: 302,
                        child: Divider(
                          color: Colors.grey,
                          thickness: 0.2,
                        ),
                      ),
                      const SizedBox(height: 30),
                      SizedBox(
                        width: 302,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Invitar Personas a este Evento',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontFamily: 'PoetsenOne',
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
                      SizedBox(
                          width: MediaQuery.of(context).size.width - 100,
                          child: UserEventoSeleccionado()),
                      const SizedBox(height: 30),
                      Obx(() {
                        return SizedBox(
                          width: 302,
                          child: ButtonDefaultWidget(
                            title: calendarController.isLoading.value
                                ? 'Guardando...'
                                : 'Finalizar',
                            callback: () async {
                              userController.filteredUsers.clear();
                              calendarController.updateField("pet_id",
                                  homeController.selectedProfile.value!.id);
                              notificationController.updateField("pet_id",
                                  homeController.selectedProfile.value!.id);
                              notificationController.updateField(
                                  "category_id", 1);
                              notificationController.updateField(
                                  "date",
                                  // ignore: invalid_use_of_protected_member
                                  calendarController.event.value['date']);
                              notificationController.updateField(
                                  "actividad",
                                  // ignore: invalid_use_of_protected_member
                                  calendarController.event.value['name']);
                              notificationController.updateField(
                                  "notas",
                                  calendarController
                                      // ignore: invalid_use_of_protected_member
                                      .event
                                      .value['description']);

                              if (calendarController
                                  .validateEvent(calendarController.event)) {
                                if (calendarController.event.value['tipo'] !=
                                    'evento') {
                                  payController.setProduct(
                                    ProductoPayModel(
                                      precio:
                                          categoryController.totalAmount.value,
                                      nombreProducto: "Servicio",
                                      imagen: calendarController
                                                  .event.value['tipo'] ==
                                              'medico'
                                          ? "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTTDsiOSLQ5UvO73L2AtydpiTYHYvox0FBXUA&s"
                                          : "https://d3puay5pkxu9s4.cloudfront.net/curso/2136/800_imagen.jpg",
                                      descripcion: "Servicio",
                                      slug: "servicio",
                                      id: 1,
                                    ),
                                  );
                                }

                                balanceController.showPurchaseModal(context);
                                // Asegúrate de que el proceso sea esperado
                                //  await calendarController
                                //    .postEvent();

                                // Solo regresa si no está cargando
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
