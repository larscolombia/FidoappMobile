import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pawlly/components/button_default_widget.dart';
import 'package:pawlly/components/custom_select_form_field_widget.dart';
import 'package:pawlly/models/pet_profile_model.dart';
import 'package:pawlly/modules/auth/model/employee_model.dart';
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
import 'package:pawlly/modules/integracion/model/lista_categoria_servicio/category_model.dart';

class CreateEvent extends StatefulWidget {
  const CreateEvent({Key? key}) : super(key: key);

  @override
  _CreateEventState createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {
  final CalendarController calendarController = Get.put(CalendarController());
  final PetControllerv2 mascotas = Get.put(PetControllerv2());
  final HomeController homeController = Get.put(HomeController());
  final UserController userController = Get.put(UserController());
  final CategoryControllerVet categoryController =
      Get.put(CategoryControllerVet());
  final ServiceEntrenadorController serviceController =
      Get.put(ServiceEntrenadorController());
  final UserBalanceController balanceController =
      Get.put(UserBalanceController());
  ProductoPayController payController = Get.put(ProductoPayController());

  @override
  void initState() {
    super.initState();
    // Llamamos a fetchUsers una sola vez cuando se inicie el widget
    userController.fetchUsers();
    // Si requieres llamar a otros métodos (por ejemplo, homeController.fetchProfiles()),
    // también puedes hacerlo aquí.
  }

  @override
  Widget build(BuildContext context) {
    final ancho = MediaQuery.of(context).size.width - 100;
    var doubleHeight = 10.00;
    var margen = 16.00;
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
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 25,
                    ),
                    SizedBox(
                      width: ancho,
                      child: BarraBack(
                        titulo: 'Evento Nuevo',
                        callback: () {
                          Get.back();
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Container(
                      width: ancho,
                      child: InputText(
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
                    ),
                    SizedBox(height: margen),
                    Container(
                      width: ancho,
                      child: InputText(
                        isTextArea: true,
                        label: 'Descripción del evento ',
                        placeholder: 'Describe el evento',
                        onChanged: (value) {
                          calendarController.updateField('description', value);
                        },
                      ),
                    ),
                    SizedBox(height: doubleHeight),
                    Container(
                      width: ancho,
                      child: InputText(
                        label: 'Ubicación',
                        placeholder: 'Ubicación',
                        onChanged: (value) {
                          calendarController.updateField('location', value);
                        },
                      ),
                    ),
                    SizedBox(height: margen),
                    SizedBox(
                      width: ancho,
                      child: CustomSelectFormFieldWidget(
                        label: 'Categoria del evento',
                        onChange: (value) {
                          calendarController.updateField('tipo', value);
                          userController.type.value =
                              value == 'medico' ? 'vet' : 'trainer';
                          userController
                              .fetchUsers(); // Esta llamada se actualizará, pero sigue siendo necesaria si cambia el tipo
                        },
                        items: const [
                          'evento',
                          'medico',
                          'entrenamiento',
                        ],
                        controller: null,
                        placeholder: 'Tipo de evento ',
                        filcolorCustom: Styles.colorContainer,
                      ),
                    ),
                    Obx(() {
                      if (calendarController.event['tipo'] != 'medico') {
                        return const SizedBox();
                      }
                      if (categoryController.isLoading.value) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return Column(
                        children: [
                          SizedBox(height: margen),
                          SizedBox(
                            width: ancho,
                            child: InputSelect(
                              label: 'Servicio de evento medico',
                              placeholder:
                                  calendarController.cateogoryName.value,
                              TextColor: Colors.black,
                              onChanged: (value) {
                                calendarController.cateogoryName.value =
                                    value ?? "";
                                final selectedCategory =
                                    categoryController.categories.firstWhere(
                                  (category) => category.id.toString() == value,
                                  orElse: () => Category(
                                    id: 0,
                                    name: 'Unknown',
                                    slug: '',
                                    status: 1,
                                    categoryImage: '',
                                    createdAt: '',
                                    updatedAt: '',
                                  ),
                                );
                                calendarController.cateogoryName.value =
                                    selectedCategory.name;
                                calendarController.updateField(
                                    'category_id', value);
                                calendarController.updateField(
                                    'service_id', value);
                                categoryController.fetchprecio(
                                    value ?? "", context);
                              },
                              items: categoryController.categories
                                  .map((category) => DropdownMenuItem<String>(
                                        value: category.id.toString(),
                                        child: Text(category.name),
                                      ))
                                  .toList(),
                            ),
                          ),
                        ],
                      );
                    }),
                    Obx(() {
                      if (calendarController.event['tipo'] != 'entrenamiento') {
                        return const SizedBox();
                      }
                      if (serviceController.isLoading.value) {
                        return const CircularProgressIndicator();
                      }
                      return Column(
                        children: [
                          SizedBox(height: margen),
                          SizedBox(
                            width: ancho,
                            child: InputSelect(
                              label: 'Servicio del entrenamiento',
                              placeholder:
                                  calendarController.cateogoryName.value,
                              TextColor: Colors.black,
                              onChanged: (value) {
                                final selectedCategory =
                                    categoryController.categories.firstWhere(
                                  (category) => category.id.toString() == value,
                                  orElse: () => Category(
                                    id: 0,
                                    name: 'Unknown',
                                    slug: '',
                                    status: 1,
                                    categoryImage: '',
                                    createdAt: '',
                                    updatedAt: '',
                                  ),
                                );
                                calendarController.cateogoryName.value =
                                    selectedCategory.name;
                                calendarController.updateField(
                                    'training_id', value);
                                calendarController.updateField(
                                    'duration_id', value);
                                serviceController.fetchprecio(
                                    value.toString(), context);
                              },
                              items: serviceController.services
                                  .map((category) => DropdownMenuItem<String>(
                                        value: category.id.toString(),
                                        child: Text(category.name),
                                      ))
                                  .toList(),
                            ),
                          ),
                        ],
                      );
                    }),
                    SizedBox(height: margen),
                    SizedBox(
                      width: ancho,
                      child: InputText(
                        label: 'Fecha del evento',
                        placeholder: 'Fecha del evento',
                        isDateField: true,
                        onChanged: (value) {
                          calendarController.updateField('start_date',
                              value.replaceAll('/', '-').toString());
                          calendarController.updateField(
                              'date', value.replaceAll('/', '-').toString());
                        },
                        suffixIcon:
                            Image.asset('assets/icons/flecha_select.png'),
                        placeholderImage:
                            Image.asset('assets/icons/calendar2.png'),
                      ),
                    ),
                    SizedBox(height: margen),
                    Container(
                      width: ancho,
                      child: InputText(
                        label: 'Hora del evento',
                        placeholder: 'Hora del evento',
                        isTimeField: true,
                        onChanged: (value) {
                          calendarController.updateField('event_time', value);
                        },
                        suffixIcon:
                            Image.asset('assets/icons/flecha_select.png'),
                        placeholderImage: Image.asset('assets/icons/time.png'),
                      ),
                    ),
                    SizedBox(height: margen),
                    SizedBox(
                      width: ancho,
                      child: InputText(
                        label: 'Fecha final del evento',
                        placeholder: 'Fecha final del evento',
                        isDateField: true,
                        onChanged: (value) {
                          calendarController.updateField('end_date',
                              value.replaceAll('/', '-').toString());
                        },
                        suffixIcon:
                            Image.asset('assets/icons/flecha_select.png'),
                        placeholderImage:
                            Image.asset('assets/icons/calendar2.png'),
                      ),
                    ),
                    SizedBox(height: margen),
                    SizedBox(
                      width: ancho,
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
                    SizedBox(height: doubleHeight),
                    Container(
                      width: ancho,
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
                    SizedBox(height: doubleHeight),
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
                                _showMyDialog(context);
                              },
                              backgroundColor: Styles.fiveColor,
                              child: const Icon(Icons.add, color: Colors.white),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: doubleHeight),
                    Center(
                        child: SizedBox(
                            width: 302, child: UserEventoSeleccionado())),
                    const SizedBox(height: 30),
                    Obx(() {
                      return SizedBox(
                        width: 302,
                        child: ButtonDefaultWidget(
                          title: calendarController.isLoading.value
                              ? 'Guardando...'
                              : 'Finalizar',
                          callback: () async {
                            calendarController.updateField("pet_id",
                                homeController.selectedProfile.value!.id);
                            if (calendarController.event.value['pet_id'] ==
                                null) {
                              Get.snackbar("Error", "Seleccione una mascota");
                              return;
                            }
                            if (calendarController
                                .validateEvent(calendarController.event)) {
                              if (calendarController.event.value['tipo'] !=
                                  'evento') {
                                payController.setProduct(
                                  ProductoPayModel(
                                    precio: calendarController.event['tipo'] ==
                                            "medico"
                                        ? categoryController.totalAmount.value
                                        : serviceController.totalAmount.value,
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
                                balanceController.showPurchaseModal(context);
                              } else {
                                calendarController.postEvent();
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
                    SizedBox(height: doubleHeight),
                  ],
                ),
              ),
            ),
          ),
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
                      var filteredUsers = userController.filteredUsers;
                      if (filteredUsers.isEmpty) {
                        return const Text("No se encontraron usuarios");
                      }
                      return Column(
                        children: [
                          if (filteredUsers.isNotEmpty)
                            SelectedAvatar(
                              nombre: filteredUsers.first.firstName,
                              imageUrl: filteredUsers.first.profileImage,
                            ),
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      );
                    }),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: 300,
                      child: ButtonDefaultWidget(
                        title: 'Invitar Persona',
                        callback: () {
                          if (userController.filteredUsers.isNotEmpty) {
                            calendarController.updateField('owner_id',
                                [userController.filteredUsers.first.id]);
                            userController.deselectUser();
                            userController
                                .selectUser(userController.filteredUsers.first);
                            Navigator.of(context).pop();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'No hay usuarios disponibles para invitar'),
                              ),
                            );
                          }
                        },
                      ),
                    )
                  ],
                ),
              ),
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
