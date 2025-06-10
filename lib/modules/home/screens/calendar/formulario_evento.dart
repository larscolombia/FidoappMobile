import 'package:flutter/material.dart';
import 'dart:math';
import 'package:get/get.dart';
import 'package:pawlly/components/button_default_widget.dart';
import 'package:pawlly/components/custom_select_form_field_widget.dart';
import 'package:pawlly/components/custom_snackbar.dart';
import 'package:pawlly/modules/components/input_select.dart';
import 'package:pawlly/modules/components/input_text.dart';
import 'package:pawlly/modules/components/regresr_components.dart';
import 'package:pawlly/modules/components/style.dart';
import 'package:pawlly/modules/components/user_select.dart';
import 'package:pawlly/modules/components/custom_checkbox.dart';
import 'package:pawlly/modules/helper/helper.dart';
import 'package:pawlly/modules/home/controllers/home_controller.dart';
import 'package:pawlly/modules/home/screens/pages/profile_dogs.dart';
import 'package:pawlly/modules/integracion/controller/balance/balance_controller.dart';
import 'package:pawlly/modules/integracion/controller/balance/producto_pay_controller.dart';
import 'package:pawlly/modules/integracion/controller/calendar_controller/calendar_controller.dart';
import 'package:pawlly/modules/integracion/controller/lista_categoria_servicio/category_controller.dart';
import 'package:pawlly/modules/integracion/controller/mascotas/mascotas_controller.dart';
import 'package:pawlly/modules/integracion/controller/servicio_entrenador_categoria/servicio_entrenador_categoria_controller.dart';
import 'package:pawlly/modules/integracion/controller/user_type/user_controller.dart';
import 'package:pawlly/modules/integracion/model/lista_categoria_servicio/category_model.dart';
import 'package:pawlly/modules/integracion/model/lista_categoria_servicio/service_model.dart';
import 'package:pawlly/modules/integracion/model/servicio_entrenador_categoria/entrenador_servicio_model.dart' as TrainerCategory;
import 'package:pawlly/modules/integracion/model/servicio_entrenador_categoria/service_duration.dart';

class CreateEvent extends StatefulWidget {
  const CreateEvent({Key? key}) : super(key: key);

  @override
  _CreateEventState createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {
  final CalendarController calendarController = Get.put(CalendarController());
  final PetControllerv2 mascotas = Get.put(PetControllerv2());
  final HomeController homeController = Get.put(HomeController());
  final UserController userController = Get.put(UserController(), permanent: true);
  final CategoryControllerVet categoryController = Get.put(CategoryControllerVet());
  final ServiceEntrenadorController serviceController = Get.put(ServiceEntrenadorController());
  final UserBalanceController balanceController = Get.put(UserBalanceController());
  final ProductoPayController payController = Get.put(ProductoPayController());
  bool _selectRandomUser = true;
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
    userController.fetchUsers(userController.type.value).then((_) {
      if (_selectRandomUser) {
        _assignRandomUser();
      }
    });
  }

  void _assignRandomUser() {
    if (userController.users.isNotEmpty) {
      final randomUser = userController.users[Random().nextInt(userController.users.length)];
      userController.selectUser(randomUser);
      calendarController.updateField('owner_id', [randomUser.id]);
    }
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
              label: 'Categoría de evento medico',
              placeholder: calendarController.cateogoryName.value,
              TextColor: Colors.black,
              borderColor: Color(0XFFFCBA67),
              onChanged: (value) {
                calendarController.cateogoryName.value = value ?? "";
                final selectedCategory = categoryController.categories.firstWhere(
                  (category) => category.id.toString() == value,
                  orElse: () => Category(
                    id: 0,
                    name: '',
                    slug: '',
                    status: 1,
                    categoryImage: '',
                    createdAt: '',
                    updatedAt: '',
                  ),
                );
                calendarController.cateogoryName.value = selectedCategory.name;
                calendarController.updateField('category_id', value);
                categoryController.fetchServices(value);
                //categoryController.fetchprecio(value ?? "", context);
              },
              items: categoryController.categories
                  .map(
                    (category) => DropdownMenuItem<String>(
                      value: category.id.toString(),
                      child: Text(
                        category.name,
                        style: TextStyle(
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      );
    });
  }

  // Widget para mostrar el servicio de evento médico
  Widget _buildMedicoService(double inputWidth, double defaultMargin) {
    return Obx(() {
      if (categoryController.services.isEmpty || calendarController.event['tipo'] != 'medico') return const SizedBox();

      return Column(
        children: [
          SizedBox(height: defaultMargin),
          SizedBox(
            width: inputWidth,
            child: InputSelect(
              label: 'Servicio',
              placeholder: calendarController.serviceName.value,
              TextColor: Colors.black,
              borderColor: Color(0XFFFCBA67),
              onChanged: (value) {
                final selectedService = categoryController.services.firstWhere((service) => service.id.toString() == value,
                    orElse: () => Service(slug: '', name: '', durationMin: 0, defaultPrice: 0, status: 0));
                calendarController.serviceName.value = selectedService.name;
                calendarController.updateField('service_id', value);
                categoryController.fetchprecio(value ?? "", context);
              },
              items: categoryController.services
                  .map(
                    (Service) => DropdownMenuItem<String>(
                      value: Service.id.toString(),
                      child: Text(
                        Service.name,
                        style: TextStyle(
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.normal,
                        ),
                      ),
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
      if (calendarController.event['tipo'] != 'entrenamiento') return const SizedBox();
      if (serviceController.isLoading.value) return const CircularProgressIndicator();
      return Column(
        children: [
          SizedBox(height: defaultMargin),
          SizedBox(
            width: inputWidth,
            child: InputSelect(
              label: 'Servicio',
              placeholder: calendarController.cateogoryName.value,
              TextColor: Colors.black,
              borderColor: Color(0XFFFCBA67),
              onChanged: (value) {
                calendarController.cateogoryName.value = value ?? "";
                final selectedCategory = serviceController.services.firstWhere((service) => service.id.toString() == value,
                    orElse: () => TrainerCategory.Service(id: 0, name: '', description: '', status: 0, slug: ''));
                calendarController.cateogoryName.value = selectedCategory.name;
                calendarController.updateField('training_id', value);
              },
              items: serviceController.services
                  .map(
                    (category) => DropdownMenuItem<String>(
                      value: category.id.toString(),
                      child: Text(
                        category.name,
                        style: TextStyle(
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.normal,
                        ),
                      ),
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
  Widget _buildEntrenamientoDuration(double inputWidth, double defaultMargin) {
    return Obx(() {
      if (calendarController.event['tipo'] != 'entrenamiento') return const SizedBox();
      return Column(
        children: [
          SizedBox(height: defaultMargin),
          SizedBox(
            width: inputWidth,
            child: InputSelect(
              label: 'Duración',
              placeholder: '',
              TextColor: Colors.black,
              borderColor: Color(0XFFFCBA67),
              onChanged: (value) {
                calendarController.serviceName.value = value ?? "";
                final selectedDuration = serviceController.serviceDurations.firstWhere((duration) => duration.id.toString() == value,
                    orElse: () => ServiceDuration(id: 0, duration: '0', price: 0, status: 0));
                calendarController.updateField('duration_id', value);
                serviceController.fetchprecio(value.toString(), context);
              },
              items: serviceController.serviceDurations
                  .map(
                    (duration) => DropdownMenuItem<String>(
                      value: duration.id.toString(),
                      child: Text(
                        duration.duration,
                        style: TextStyle(
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.normal,
                        ),
                      ),
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
    final double ancho = MediaQuery.sizeOf(context).width;
    final EdgeInsets defaultPadding = const EdgeInsets.symmetric(horizontal: 26.0);
    final double inputWidth = ancho - defaultPadding.horizontal;
    const double defaultMargin = 1.0;
    const alto = 105.0;
    return Scaffold(
      backgroundColor: Styles.colorContainer,
      body: Column(
        children: [
          // Cabecera
          Container(
            width: double.infinity,
            height: 170,
            decoration: const BoxDecoration(
              color: Styles.colorContainer,
            ),
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 30),
                  Text(
                    'Completa la Información',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontFamily: 'PoetsenOne',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 1),
                  Text(
                    'Añade los datos del evento',
                    style: TextStyle(
                      fontSize: 14,
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
                        size: 20,
                        callback: () => Get.back(),
                      ),
                    ),
                    SizedBox(height: 26),

                    SizedBox(
                      width: inputWidth,
                      height: alto,
                      child: InputText(
                        label: 'Nombre del Evento',
                        labelColor: Color(0xFF383838),
                        placeholder: (validate['name'] ?? false) ? 'Campo requerido' : '',
                        errorPadding: (validate['name'] ?? false),
                        errorText: (validate['name'] ?? false) ? 'Campo requerido' : '', // Mensaje de error
                        onChanged: (value) {
                          calendarController.updateField('name', value.toString());
                          calendarController.updateField('slug', calendarController.Slug(value.toString()));
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
                          labelColor: Color(0xFF383838),
                          errorPadding: (validate['description'] ?? false),
                          errorText: (validate['description'] ?? false) ? 'Campo requerido' : '', // Mensaje de error
                          placeholder: 'Describe el evento',
                          onChanged: (value) {
                            calendarController.updateField('description', value);
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
                          labelColor: Color(0xFF383838),
                          placeholder: '',
                          errorPadding: (validate['location'] ?? false),
                          errorText: (validate['location'] ?? false) ? 'Campo requerido' : '', // Mensaje de error
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
                        label: 'Tipo de evento',
                        placeholder: 'Tipo de evento ',
                        filcolorCustom: Styles.colorContainer,
                        borderColor: Color(0XFFFCBA67),
                        controller: null,
                        items: const [
                          'evento',
                          'medico',
                          'entrenamiento',
                        ],
                        onChange: (value) {
                          calendarController.updateField('tipo', value);
                          final type = value == 'medico'
                              ? 'vet'
                              : value == 'entrenamiento'
                                  ? 'trainer'
                                  : 'all';
                          userController.type.value = type;
                          userController.fetchUsers(type).then((_) {
                            if (_selectRandomUser) {
                              _assignRandomUser();
                            }
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: defaultMargin),
                    // Servicio para evento médico (si aplica)
                    _buildMedicoCategory(inputWidth, defaultMargin),

                    const SizedBox(height: defaultMargin),
                    _buildMedicoService(inputWidth, defaultMargin + 10),
                    // Servicio para entrenamiento (si aplica)
                    const SizedBox(height: defaultMargin),
                    _buildEntrenamientoCategory(inputWidth, defaultMargin),
                    const SizedBox(height: defaultMargin),
                    _buildEntrenamientoDuration(inputWidth, defaultMargin + 10),
                    // Fecha del evento
                    SizedBox(
                      width: inputWidth,
                      height: alto,
                      child: InputText(
                        label: 'Fecha del evento',
                        placeholder: '',
                        borderColor: Color(0XFFFCBA67),
                        labelColor: Color(0xFF383838),

                        isDateField: true,
                        errorPadding: (validate['start_date'] ?? false),
                        errorText: (validate['start_date'] ?? false) ? 'Campo requerido' : '', // Mensaje de error
                        suffixIcon: Image.asset('assets/icons/flecha_select.png'),
                        placeholderSvg: 'assets/icons/svg/calendar.svg',
                        onChanged: (value) {
                          final formattedDate = value.replaceAll('/', '-').toString();
                          calendarController.updateField('start_date', formattedDate);
                          calendarController.updateField('date', formattedDate);
                          //para no mandar campos vacios
                          calendarController.updateField('end_date', value.replaceAll('/', '-').toString());

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
                          labelColor: Color(0xFF383838),
                          errorText: (validate['event_time'] ?? false) ? 'Campo requerido' : "",
                          isTimeField: true,
                          borderColor: Color(0XFFFCBA67),
                          errorPadding: (validate['event_time'] ?? false),
                          suffixIcon: Image.asset('assets/icons/flecha_select.png'),
                          placeholderSvg: 'assets/icons/svg/time.svg',
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
                        'Selecciona la mascota vinculada\na este evento',
                        style: TextStyle(fontFamily: 'Lato', fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF383838)),
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
                    Row(
                      children: [
                        CustomCheckbox(
                          isChecked: _selectRandomUser,
                          onChanged: (v) {
                            setState(() {
                              _selectRandomUser = v;
                              if (_selectRandomUser) {
                                _assignRandomUser();
                              } else {
                                userController.deselectUser();
                                calendarController.updateField('owner_id', []);
                              }
                            });
                          },
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Asignar usuario aleatoriamente',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontFamily: 'Lato',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: defaultMargin),
                    // Invitación de personas
                    if (!_selectRandomUser)
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
                                fontFamily: 'Lato',
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            FloatingActionButton(
                              elevation: 0,
                              backgroundColor: Styles.fiveColor,
                              onPressed: () => Helper.showMyDialog(context, userController),
                              child: const Icon(Icons.add, color: Colors.white),
                            )
                          ],
                        ),
                      ),
                    SizedBox(height: defaultMargin + 15),
                    UserEventoSeleccionado(),
                    SizedBox(height: defaultMargin + 20),
                    // Botón Finalizar o Guardando
                    Obx(() {
                      return SizedBox(
                        width: inputWidth,
                        child: ButtonDefaultWidget(
                          disabled: calendarController.isLoading.value,
                          title: calendarController.isLoading.value ? 'Guardando...' : 'Finalizar',
                          callback: () async {
                            if (homeController.selectedProfile.value == null) {
                              CustomSnackbar.show(
                                title: "Error",
                                message: "Seleccione una mascota",
                                isError: true,
                              );
                              return;
                            }
                            var petId = homeController.selectedProfile.value!.id ?? '0';
                            calendarController.updateField("pet_id", petId);
                            if (calendarController.event.value['pet_id'] == '0' ||
                                calendarController.event.value['name'] == "" ||
                                calendarController.event.value['date'] == "" ||
                                calendarController.event.value['end_date'] == "" ||
                                calendarController.event.value['event_time'] == "" ||
                                calendarController.event.value['description'] == "") {
                              if (calendarController.event.value['pet_id'] == '0') {
                                CustomSnackbar.show(
                                  title: "Error",
                                  message: "Seleccione una mascota",
                                  isError: true,
                                );
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
                              Helper.showErrorSnackBar(
                                'Por favor, rellene todos los campos requeridos.',
                              );

                              CustomSnackbar.show(
                                title: "Campos Incompletos",
                                message: "Por favor, rellene todos los campos requeridos.",
                                isError: true,
                              );
                              return;
                            }

                            if (calendarController.event.value['tipo'] != 'evento') {
                              // En lugar de mostrar el modal de pago, simplemente publicamos el evento
                              // ya que ahora todos los eventos son gratuitos
                              calendarController.postEvent();
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
}
