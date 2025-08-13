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
import 'package:pawlly/services/auth_service_apis.dart';
import 'package:intl/intl.dart';

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

  // Función para convertir valores con acentos a valores del backend
  String _convertToBackendValue(String? displayValue) {
    switch (displayValue) {
      case 'Evento':
        return 'evento';
      case 'Médico':
        return 'medico';
      case 'Entrenamiento':
        return 'entrenamiento';
      default:
        return displayValue?.toLowerCase() ?? '';
    }
  }

  // Parse current event date and time into a local DateTime, or null if incomplete/invalid
  DateTime? _parseEventDateTime() {
    try {
  final dynamic rawDate = calendarController.event.value['start_date'] ?? calendarController.event.value['date'];
  final String? dateStrRaw = rawDate is String ? rawDate : null;
  final dynamic rawTime = calendarController.event.value['event_time'];
  final String? timeStr = rawTime is String ? rawTime : null;
      if (dateStrRaw == null || dateStrRaw.isEmpty || timeStr == null || timeStr.isEmpty) return null;
      // Normalizar separadores y limpiar
      final String cleanedDate = dateStrRaw.trim().replaceAll('/', '-');
      // Normalizar hora a HH:mm (añadir cero a la izquierda si hace falta)
      final timePartsRaw = timeStr.split(':');
      if (timePartsRaw.length < 2) return null;
      final hourStr = timePartsRaw[0].padLeft(2, '0');
      final minuteStr = timePartsRaw[1].padLeft(2, '0');
      final normalizedTime = '$hourStr:$minuteStr';

      // Patrones aceptados
      final patterns = <String>['yyyy-MM-dd', 'dd-MM-yyyy', 'yyyy/MM/dd', 'dd/MM/yyyy'];
      DateTime? dateOnly;
      for (final p in patterns) {
        try {
          dateOnly = DateFormat(p).parseStrict(cleanedDate);
          break;
        } catch (_) {
          continue;
        }
      }
      if (dateOnly == null) {
        debugPrint('[PARSE EVENTO][FALLA] rawDate=$dateStrRaw cleaned=$cleanedDate sin patrón coincidente');
        return null;
      }

      int? hour = int.tryParse(hourStr);
      int? minute = int.tryParse(minuteStr);
      if (hour == null || minute == null) return null;

      final parsed = DateTime(dateOnly.year, dateOnly.month, dateOnly.day, hour, minute);
      debugPrint('[PARSE EVENTO] rawDate=$dateStrRaw -> dateOnly=$dateOnly time=$normalizedTime parsed=$parsed');
      return parsed;
    } catch (_) {
      return null;
    }
  }

  // Validación robusta: permite
  // - cualquier fecha futura (independiente de la hora)
  // - misma fecha con hora >= ahora (con tolerancia negativa de 2 minutos por desfases)
  bool _isEventInPast(DateTime event) {
  final now = DateTime.now();
  final todayDateOnly = DateTime(now.year, now.month, now.day);
  final eventDateOnly = DateTime(event.year, event.month, event.day);
  // 1. Fecha futura => válido
  if (eventDateOnly.isAfter(todayDateOnly)) return false;
  // 2. Fecha pasada => inválido
  if (eventDateOnly.isBefore(todayDateOnly)) return true;
  // 3. Misma fecha: validar hora/minuto con tolerancia de -2 min
  final toleranceMinutes = 2;
  final adjustedNow = now.subtract(Duration(minutes: toleranceMinutes));
  // Si el evento es antes del adjustedNow => pasado, de lo contrario válido
  return event.isBefore(adjustedNow);
  }

  @override
  void initState() {
    super.initState();
    userController.fetchUsers(userController.type.value).then((_) {
      // No asignar automáticamente al inicio, solo cuando se seleccione un tipo específico
    });
  }

  void _assignRandomUser() {
    if (userController.users.isNotEmpty) {
      // Filtrar usuarios excluyendo al usuario actual
      final currentUserId = AuthServiceApis.dataCurrentUser.id;
      final availableUsers = userController.users.where((user) => user.id != currentUserId).toList();
      
      if (availableUsers.isNotEmpty) {
        final randomUser = availableUsers[Random().nextInt(availableUsers.length)];
      userController.selectUser(randomUser);
      calendarController.updateField('owner_id', [randomUser.id]);
      } else {
        // Si no hay usuarios disponibles (solo está el usuario actual), mostrar mensaje
        CustomSnackbar.show(
          title: 'Aviso',
          message: 'No hay otros usuarios disponibles para asignar aleatoriamente',
          isError: false,
        );
      }
    }
  }

  // Widget para mostrar el servicio de evento médico
  Widget _buildMedicoCategory(double inputWidth, double defaultMargin) {
    return Obx(() {
      print('DEBUG: Comparando tipo de evento: ${calendarController.event['tipo']} con "medico"');
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
                          'Evento',
                          'Médico',
                          'Entrenamiento',
                        ],
                        onChange: (value) {
                          // Convertir el valor de display al valor que espera el backend
                          final backendValue = _convertToBackendValue(value);
                          print('DEBUG: Valor seleccionado: $value');
                          print('DEBUG: Valor convertido para backend: $backendValue');
                          calendarController.updateField('tipo', backendValue);
                          print('DEBUG: Valor guardado en calendarController: ${calendarController.event['tipo']}');
                          
                          // Limpiar usuario asignado al cambiar tipo de evento
                          userController.deselectUser();
                          calendarController.updateField('owner_id', []);
                          
                          final type = value == 'Médico'
                              ? 'vet'
                              : value == 'Entrenamiento'
                                  ? 'trainer'
                                  : 'all';
                          userController.type.value = type;
                          userController.fetchUsers(type).then((_) {
                            // Para tipo "Evento", no asignar automáticamente
                            if (value == 'Evento') {
                              setState(() {
                                _selectRandomUser = false;
                              });
                            } else {
                              // Para tipo "Médico" y "Entrenamiento", mantener la asignación automática
                              if (_selectRandomUser) {
                                _assignRandomUser();
                              }
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
                        Obx(() => Text(
                          calendarController.event['tipo'] == 'evento' 
                              ? 'Asignar invitado aleatoriamente'
                              : 'Asignar usuario aleatoriamente',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontFamily: 'Lato',
                            fontWeight: FontWeight.w500,
                          ),
                        )),
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
                            Obx(() => Text(
                              calendarController.event['tipo'] == 'evento' 
                                  ? 'Invitar Personas a este Evento'
                                  : 'Seleccionar Profesional',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontFamily: 'Lato',
                                fontWeight: FontWeight.w800,
                              ),
                            )),
                            FloatingActionButton(
                              elevation: 0,
                              backgroundColor: Styles.fiveColor,
                              onPressed: () {
                                // Limpiar usuario seleccionado antes de abrir el modal
                                userController.deselectUser();
                                Helper.showMyDialog(context, userController);
                              },
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

                            // Block events in the past (relative to device time)
                            final DateTime? eventDateTime = _parseEventDateTime();
                            if (eventDateTime != null) {
                              final inPast = _isEventInPast(eventDateTime);
                              debugPrint('[VALIDACION EVENTO] now=${DateTime.now()} event=$eventDateTime inPast=$inPast rawDate=' + (calendarController.event.value['start_date']?.toString() ?? calendarController.event.value['date']?.toString() ?? 'null') + ' rawTime=' + (calendarController.event.value['event_time']?.toString() ?? 'null'));
                              if (inPast) {
                                CustomSnackbar.show(
                                  title: "Fecha y hora inválidas",
                                  message: "No puedes crear eventos en fechas u horas anteriores a la actual.",
                                  isError: true,
                                );
                                return;
                              }
                            } else {
                              debugPrint('[VALIDACION EVENTO] Parse falló. Valores raw: date=' + (calendarController.event.value['start_date']?.toString() ?? calendarController.event.value['date']?.toString() ?? 'null') + ' time=' + (calendarController.event.value['event_time']?.toString() ?? 'null'));
                            }

                            // Validar que se haya seleccionado una persona si no está activado el checkbox de asignación aleatoria
                            if (!_selectRandomUser && userController.selectedUser.value == null) {
                              CustomSnackbar.show(
                                title: "Error",
                                message: "Por favor selecciona una persona o activa la asignación aleatoria",
                                isError: true,
                              );
                              return;
                            }

                            if (calendarController.event.value['tipo'] != 'evento') {
                              // Verificar disponibilidad antes de crear el evento
                              calendarController.createEventWithAvailabilityCheck(context);
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
