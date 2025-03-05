import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pawlly/components/button_default_widget.dart';
import 'package:pawlly/components/custom_select_form_field_widget.dart';
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
import 'package:pawlly/modules/integracion/controller/lista_categoria_servicio/category_controller.dart';
import 'package:pawlly/modules/integracion/controller/mascotas/mascotas_controller.dart';
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
  final UserController userController =
      Get.put(UserController(), permanent: true);
  final CategoryControllerVet categoryController =
      Get.put(CategoryControllerVet());
  final ServiceEntrenadorController serviceController =
      Get.put(ServiceEntrenadorController());
  final UserBalanceController balanceController =
      Get.put(UserBalanceController());
  final ProductoPayController payController = Get.put(ProductoPayController());
  Map<String, bool> validate = {
    'name': false,
    'date': false,
    'end_date': false,
    'event_time': false,
    "start_date": false,
    'slug': false,
    'description': false,
    'location': false,
    'tipo': false,
    'pet_id': false,
  };
  @override
  void initState() {
    super.initState();
    // Llamamos a fetchUsers una sola vez al iniciar el widget
    validate = {
      'name': false,
      'date': false,
      'end_date': false,
      'event_time': false,
      "start_date": false,
      'slug': false,
      'description': false,
      'location': false,
      'tipo': false,
      'pet_id': false,
    };

    userController.fetchUsers();
  }

  // Widget para mostrar el servicio de evento médico
  Widget _buildMedicoCategory(double inputWidth, double defaultMargin) {
    return Obx(() {
      if (calendarController.event['tipo'] != 'medico') return const SizedBox();
      if (categoryController.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      return Column(
        children: [
          SizedBox(height: defaultMargin),
          SizedBox(
            width: inputWidth,
            child: InputSelect(
              label: 'Servicio de evento medico',
              placeholder: calendarController.cateogoryName.value,
              TextColor: Colors.black,
              onChanged: (value) {
                calendarController.cateogoryName.value = value ?? "";
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
                calendarController.cateogoryName.value = selectedCategory.name;
                calendarController.updateField('category_id', value);
                calendarController.updateField('service_id', value);
                categoryController.fetchprecio(value ?? "", context);
              },
              items: categoryController.categories
                  .map(
                    (category) => DropdownMenuItem<String>(
                      value: category.id.toString(),
                      child: Text(category.name),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      );
    });
  }

  // Widget para mostrar el servicio de entrenamiento
  Widget _buildEntrenamientoCategory(double inputWidth, double defaultMargin) {
    return Obx(() {
      if (calendarController.event['tipo'] != 'entrenamiento')
        return const SizedBox();
      if (serviceController.isLoading.value)
        return const CircularProgressIndicator();
      return Column(
        children: [
          SizedBox(height: defaultMargin),
          SizedBox(
            width: inputWidth,
            child: InputSelect(
              label: 'Servicio del entrenamiento',
              placeholder: calendarController.cateogoryName.value,
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
                calendarController.cateogoryName.value = selectedCategory.name;
                calendarController.updateField('training_id', value);
                calendarController.updateField('duration_id', value);
                serviceController.fetchprecio(value.toString(), context);
              },
              items: serviceController.services
                  .map(
                    (category) => DropdownMenuItem<String>(
                      value: category.id.toString(),
                      child: Text(category.name),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // Variables globales para padding, margen y ancho de los inputs
    final double ancho = MediaQuery.of(context).size.width;
    final EdgeInsets defaultPadding =
        const EdgeInsets.symmetric(horizontal: 26.0);
    final double inputWidth = ancho - defaultPadding.horizontal;
    const double defaultMargin = 1.0;
    const alto = 100.0;
    return Scaffold(
      backgroundColor: Styles.colorContainer,
      body: Column(
        children: [
          // Cabecera
          Container(
            width: double.infinity,
            height: 140,
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
          // Contenido principal
          Expanded(
            child: Container(
              width: double.infinity,
              padding: defaultPadding,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 34),
                    SizedBox(
                      width: inputWidth,
                      child: BarraBack(
                        titulo: 'Evento Nuevo',
                        callback: () => Get.back(),
                      ),
                    ),
                    SizedBox(height: 26),

                    SizedBox(
                      width: inputWidth,
                      height: alto,
                      child: InputText(
                        label: 'Nombre del Evento',
                        placeholder: (validate['name'] ?? false)
                            ? 'campo requerido'
                            : '',
                        errorPadding: (validate['name'] ?? false),
                        errorText: (validate['name'] ?? false)
                            ? 'campo requerido'
                            : '', // Mensaje de error
                        onChanged: (value) {
                          calendarController.updateField(
                              'name', value.toString());
                          calendarController.updateField('slug',
                              calendarController.Slug(value.toString()));
                          if (value.isNotEmpty) {
                            setState(() {
                              validate['name'] = false;
                            });
                          }
                        },
                      ),
                    ),
                    SizedBox(height: defaultMargin),
                    // Descripción del evento
                    SizedBox(
                      width: inputWidth,
                      child: InputText(
                          isTextArea: true,
                          label: 'Descripción del evento ',
                          errorPadding: (validate['description'] ?? false),
                          errorText: (validate['description'] ?? false)
                              ? 'campo requerido'
                              : '', // Mensaje de error
                          placeholder: 'Describe el evento',
                          onChanged: (value) {
                            calendarController.updateField(
                                'description', value);
                            if (value.isNotEmpty) {
                              setState(() {
                                validate['description'] = false;
                              });
                            }
                          }),
                    ),
                    SizedBox(height: defaultMargin),
                    // Ubicación
                    SizedBox(
                      width: inputWidth,
                      height: alto,
                      child: InputText(
                          label: 'Ubicación',
                          placeholder: '',
                          errorPadding: (validate['location'] ?? false),
                          errorText: (validate['location'] ?? false)
                              ? 'campo requerido'
                              : '', // Mensaje de error
                          onChanged: (value) {
                            calendarController.updateField('location', value);
                            if (value.isNotEmpty) {
                              setState(() {
                                validate['location'] = false;
                              });
                            }
                          }),
                    ),
                    SizedBox(height: defaultMargin + 10),
                    // Selección de categoria del evento
                    SizedBox(
                      width: inputWidth,
                      height: alto,
                      child: CustomSelectFormFieldWidget(
                        label: 'Categoria del evento',
                        placeholder: 'Tipo de evento ',
                        filcolorCustom: Styles.colorContainer,
                        controller: null,
                        items: const [
                          'evento',
                          'medico',
                          'entrenamiento',
                        ],
                        onChange: (value) {
                          calendarController.updateField('tipo', value);
                          userController.type.value =
                              value == 'medico' ? 'vet' : 'trainer';
                          userController.fetchUsers();
                        },
                      ),
                    ),
                    const SizedBox(height: defaultMargin),
                    // Servicio para evento médico (si aplica)
                    _buildMedicoCategory(inputWidth, defaultMargin),
                    // Servicio para entrenamiento (si aplica)
                    const SizedBox(height: defaultMargin),
                    _buildEntrenamientoCategory(inputWidth, defaultMargin),
                    const SizedBox(height: defaultMargin),
                    // Fecha del evento
                    SizedBox(
                      width: inputWidth,
                      height: alto,
                      child: InputText(
                        label: 'Fecha del evento',
                        placeholder: '',
                        isDateField: true,
                        errorPadding: (validate['start_date'] ?? false),
                        errorText: (validate['start_date'] ?? false)
                            ? 'campo requerido'
                            : '', // Mensaje de error
                        suffixIcon:
                            Image.asset('assets/icons/flecha_select.png'),
                        placeholderImage:
                            Image.asset('assets/icons/calendar2.png'),
                        onChanged: (value) {
                          final formattedDate =
                              value.replaceAll('/', '-').toString();
                          calendarController.updateField(
                              'start_date', formattedDate);
                          calendarController.updateField('date', formattedDate);
                          //para no mandar campos vacios
                          calendarController.updateField('end_date',
                              value.replaceAll('/', '-').toString());

                          if (value.isNotEmpty) {
                            setState(() {
                              validate['start_date'] = false;
                            });
                          }
                        },
                      ),
                    ),
                    SizedBox(height: defaultMargin),

                    SizedBox(
                      width: inputWidth,
                      height: alto,
                      child: InputText(
                          label: 'Hora del evento',
                          placeholder: '',
                          errorText: (validate['event_time'] ?? false)
                              ? 'campo requerido'
                              : "",
                          isTimeField: true,
                          errorPadding: (validate['event_time'] ?? false),
                          suffixIcon:
                              Image.asset('assets/icons/flecha_select.png'),
                          placeholderImage:
                              Image.asset('assets/icons/time.png'),
                          onChanged: (value) {
                            calendarController.updateField('event_time', value);
                            if (value.isNotEmpty) {
                              setState(() {
                                validate['event_time'] = false;
                              });
                            }
                          }),
                    ),
                    SizedBox(height: defaultMargin + 10),
                    // Texto para selección de mascota vinculada
                    SizedBox(
                      width: inputWidth,
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
                    SizedBox(height: defaultMargin + 10),
                    // Perfiles de mascotas
                    Container(
                      width: inputWidth,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ProfilesDogs(),
                    ),
                    SizedBox(
                      width: inputWidth,
                      child: const Divider(
                        color: Colors.grey,
                        thickness: 0.2,
                      ),
                    ),
                    SizedBox(height: defaultMargin),
                    // Invitación de personas
                    SizedBox(
                      width: inputWidth,
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
                          FloatingActionButton(
                            elevation: 0,
                            backgroundColor: Styles.fiveColor,
                            onPressed: () =>
                                _showMyDialog(context, userController),
                            child: const Icon(Icons.add, color: Colors.white),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: defaultMargin + 10),
                    Center(
                      child: SizedBox(
                        width: inputWidth,
                        child: UserEventoSeleccionado(),
                      ),
                    ),
                    SizedBox(height: defaultMargin + 10),
                    // Botón Finalizar o Guardando
                    Obx(() {
                      return SizedBox(
                        width: inputWidth,
                        child: ButtonDefaultWidget(
                          title: calendarController.isLoading.value
                              ? 'Guardando...'
                              : 'Finalizar',
                          callback: () async {
                            if (homeController.selectedProfile.value == null) {
                              Get.snackbar("Error", "Seleccione una mascota");
                              return;
                            }
                            var petId =
                                homeController.selectedProfile.value!.id ?? '0';
                            calendarController.updateField("pet_id", petId);
                            if (calendarController.event.value['pet_id'] ==
                                    '0' ||
                                calendarController.event.value['name'] == "" ||
                                calendarController.event.value['date'] == "" ||
                                calendarController.event.value['end_date'] ==
                                    "" ||
                                calendarController.event.value['event_time'] ==
                                    "" ||
                                calendarController.event.value['description'] ==
                                    "") {
                              if (calendarController.event.value['pet_id'] ==
                                  '0') {
                                Get.snackbar("Error", "Seleccione una mascota");
                                return;
                              }

                              setState(() {
                                validate['name'] = true;
                                validate['date'] = true;
                                validate['start_date'] = true;
                                validate['event_time'] = true;
                                validate['description'] = true;
                                validate['location'] = true;
                              });

                              Get.snackbar("Campos Incompletos",
                                  "Por favor, rellene todos los campos requeridos.");
                              return;
                            }

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
                          },
                        ),
                      );
                    }),
                    SizedBox(height: defaultMargin + 30),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showMyDialog(
      BuildContext context, UserController controller) async {
    controller.type.value = 'vet';
    controller.fetchUsers();
    return showDialog<void>(
      context: context,
      barrierDismissible:
          false, // El usuario debe presionar un botón para cerrar el modal
      builder: (BuildContext context) {
        return SizedBox(
          width: 302,
          height: 396,
          child: AlertDialog(
            title: const Text('Invita una persona'),
            content: SingleChildScrollView(
              child: SizedBox(
                width: 302,
                height: 396,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    InputText(
                      label: '',
                      placeholder: 'Correo Electrónico',
                      suffixIcon: const Icon(
                        Icons.email,
                        color: Styles.fiveColor,
                        size: 24,
                      ),
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
                          SelectedAvatar(
                            nombre: filteredUsers.first.firstName,
                            imageUrl: filteredUsers.first.profileImage,
                          ),
                          const SizedBox(height: 20),
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
                            calendarController.updateField(
                              'owner_id',
                              [userController.filteredUsers.first.id],
                            );
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
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      },
    );
  }
}
