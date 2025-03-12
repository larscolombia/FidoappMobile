import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pawlly/components/button_default_widget.dart';
import 'package:pawlly/modules/components/border_redondiado.dart';
import 'package:pawlly/modules/components/input_text.dart';
import 'package:pawlly/modules/components/regresr_components.dart';
import 'package:pawlly/modules/components/style.dart';
import 'package:pawlly/modules/helper/helper.dart';
import 'package:pawlly/modules/home/controllers/home_controller.dart';
import 'package:pawlly/modules/home/screens/home_screen.dart';
import 'package:pawlly/modules/home/screens/pages/header_notification.dart';
import 'package:pawlly/modules/home/screens/pages/profile_dogs.dart';
import 'package:pawlly/modules/integracion/controller/comandos/comandos_controller.dart';
import 'package:pawlly/styles/recursos.dart';

class CrearComando extends StatefulWidget {
  CrearComando({super.key});

  @override
  State<CrearComando> createState() => _CrearComandoState();
}

class _CrearComandoState extends State<CrearComando> {
  // Busca los controladores ya existentes en lugar de inicializarlos nuevamente
  final ComandoController controller = Get.find<ComandoController>();

  final HomeController homeController = Get.find<HomeController>();
  Map<String, bool> validate = {
    'name': true,
    'voz_comando': true,
    'instructions': true,
    'description': true,
  };
  @override
  void initState() {
    super.initState();
    validate = {
      'name': true,
      'voz_comando': true,
      'instructions': true,
      'description': true,
    };
  }

  void validateForm() {
    if (controller.dataComando['name'] == "") {
      setState(() {
        validate['name'] = true;
      });
    }

    if (controller.dataComando['voz_comando'] == "") {
      setState(() {
        validate['voz_comando'] = true;
      });
    }

    if (controller.dataComando['instructions'] == "") {
      setState(() {
        validate['instructions'] = true;
      });
    }

    if (controller.dataComando['description'] == "") {
      setState(() {
        validate['description'] = true;
      });
    }
  }

  Widget build(BuildContext context) {
    const double margen = 16.0;
    var headerHeight = 150.00;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 148,
            decoration: const BoxDecoration(
              color: Styles.colorContainer,
            ),
            child: Container(
              color: Styles.colorContainer,
              height: 140,
              child: Stack(
                children: [
                  Row(
                    children: [
                      Container(
                        height: 120,
                        width: width,
                        padding: Styles.paddingAll,
                        decoration: const BoxDecoration(
                          color: Styles.colorContainer,
                        ),
                        child: const Align(
                          alignment: Alignment
                              .bottomCenter, // Alinea el contenido en la parte inferior
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 0, vertical: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment
                                  .end, // Alinea los hijos al final de la Row
                              children: [],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    top: 120,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 40,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(36),
                          topRight: Radius.circular(36),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Contenido
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 26),
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(90),
                    topRight: Radius.circular(90),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Barra de Navegación
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: BarraBack(
                            titulo: 'Crear Comando',
                            size: 20,
                            callback: () {
                              Get.off(HomeScreen());
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Selección de Mascota
                        const SizedBox(height: margen),
                        // Campos de Entrada para el Comando
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 1),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const SizedBox(
                                width: double.infinity,
                                child: Text(
                                  "Selecciona la mascota",
                                  style: TextStyle(
                                    fontFamily: 'Lato',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0XFF383838),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              SizedBox(
                                width: double.infinity,
                                child: ProfilesDogs(
                                  showAge: true,
                                ),
                              ),
                              const SizedBox(height: margen),
                              InputText(
                                label: 'Nombre del Comando',
                                placeholder: '',
                                errorText: (validate['description'] ?? false)
                                    ? 'Campo requerido'
                                    : '',
                                onChanged: (value) {
                                  controller.updateField('name', value);
                                  if (value.isNotEmpty) {
                                    setState(() {
                                      validate['name'] = false;
                                    });
                                  }
                                },
                              ),
                              InputText(
                                label: 'Descripción del Comando',
                                placeholder: '',
                                onChanged: (value) {
                                  controller.updateField('description', value);
                                  if (value.isNotEmpty) {
                                    setState(() {
                                      validate['description'] = false;
                                    });
                                  }
                                },
                                errorText: (validate['description'] ?? false)
                                    ? 'Campo requerido'
                                    : '', // Mensaje de error
                              ),
                              InputText(
                                label: 'Voz del Comando',
                                placeholder: '',
                                errorText: (validate['voz_comando'] ?? false)
                                    ? 'Campo requerido'
                                    : '',
                                onChanged: (value) {
                                  controller.updateField('voz_comando', value);
                                  if (value.isNotEmpty) {
                                    setState(() {
                                      validate['voz_comando'] = false;
                                    });
                                  }
                                },
                              ),
                              InputText(
                                  label: 'Instrucciones del Comando',
                                  placeholder: '',
                                  errorText: (validate['instructions'] ?? false)
                                      ? 'Campo requerido'
                                      : '',
                                  onChanged: (value) {
                                    controller.updateField(
                                        'instructions', value);
                                    if (value.isNotEmpty) {
                                      setState(() {
                                        validate['instructions'] = false;
                                      });
                                    }
                                  }),
                            ],
                          ),
                        ),
                        const SizedBox(height: margen),
                        // Botón de Crear
                        Obx(() {
                          return SizedBox(
                            width: double.infinity,
                            child: ButtonDefaultWidget(
                              title: controller.isLoading.value
                                  ? 'Creando...'
                                  : 'Crear comando',
                              callback: controller.isLoading.value
                                  ? null // Desactiva el botón mientras se carga
                                  : () {
                                      // Actualizar el ID de la mascota seleccionada
                                      validateForm();
                                      if (validate['name'] == true) {
                                        return;
                                      }
                                      if (validate['voz_comando'] == true) {
                                        return;
                                      }

                                      if (validate['instructions'] == true) {
                                        return;
                                      }
                                      if (validate['description'] == true) {
                                        return;
                                      }

                                      controller.updateField(
                                        'pet_id',
                                        homeController
                                                .selectedProfile.value?.id ??
                                            '',
                                      );

                                      // Llamar a la API para crear el comando
                                      controller
                                          .postCommand(controller.dataComando);
                                    },
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Widget Auxiliar para los Campos de Entrada
class InputField extends StatelessWidget {
  final String label;
  final String placeholder;
  final Function(String) onChanged;

  const InputField({
    super.key,
    required this.label,
    required this.placeholder,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Lato',
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0XFF383838),
          ),
        ),
        const SizedBox(height: 8),
        InputText(
          fondoColor: Colors.white,
          borderColor: Recursos.ColorBorderSuave,
          placeholder: placeholder,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
