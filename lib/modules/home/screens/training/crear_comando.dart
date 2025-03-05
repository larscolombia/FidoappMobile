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
import 'package:pawlly/modules/home/screens/pages/profile_dogs.dart';
import 'package:pawlly/modules/integracion/controller/comandos/comandos_controller.dart';
import 'package:pawlly/styles/recursos.dart';

class CrearComando extends StatelessWidget {
  CrearComando({super.key});

  // Busca los controladores ya existentes en lugar de inicializarlos nuevamente
  final ComandoController controller = Get.find<ComandoController>();
  final HomeController homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    const double margen = 16.0;
    var width = MediaQuery.of(context).size.width;
    var headerHeight = 140.00;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Header o Fondo
          Container(
            height: headerHeight,
            decoration: const BoxDecoration(
              color: Styles.colorContainer,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: BorderRedondiado(
                    top: headerHeight - 20,
                  ),
                ),
              ],
            ),
          ),
          // Contenido
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(Helper.paddingDefault),
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20),
                        // Barra de Navegación
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: BarraBack(
                            titulo: 'Crear Comando',
                            callback: () {
                              Get.off(HomeScreen());
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Selección de Mascota
                        const SizedBox(
                          width: 300,
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
                        const SizedBox(height: margen),
                        SizedBox(
                          width: width,
                          child: ProfilesDogs(),
                        ),
                        const SizedBox(height: margen),
                        // Campos de Entrada para el Comando
                        SizedBox(
                          width: width,
                          child: InputField(
                            label: 'Nombre del Comando',
                            placeholder: 'Nombre del Comando',
                            onChanged: (value) =>
                                controller.updateField('name', value),
                          ),
                        ),
                        const SizedBox(height: margen),
                        SizedBox(
                          width: width,
                          child: InputField(
                            label: 'Descripción del Comando',
                            placeholder: 'Descripción del Comando',
                            onChanged: (value) =>
                                controller.updateField('description', value),
                          ),
                        ),
                        const SizedBox(height: margen),
                        SizedBox(
                          width: width,
                          child: InputField(
                            label: 'Voz del Comando',
                            placeholder: 'Voz del Comando',
                            onChanged: (value) =>
                                controller.updateField('voz_comando', value),
                          ),
                        ),
                        const SizedBox(height: margen),
                        SizedBox(
                          width: width,
                          child: InputField(
                            label: 'Instrucciones del Comando',
                            placeholder: 'Instrucciones del Comando',
                            onChanged: (value) =>
                                controller.updateField('instructions', value),
                          ),
                        ),
                        const SizedBox(height: margen),
                        // Botón de Crear
                        Obx(() {
                          return SizedBox(
                            width: width,
                            child: ButtonDefaultWidget(
                              title: controller.isLoading.value
                                  ? 'Creando...'
                                  : 'Crear comando',
                              callback: controller.isLoading.value
                                  ? null // Desactiva el botón mientras se carga
                                  : () {
                                      // Actualizar el ID de la mascota seleccionada
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
    return SizedBox(
      width: 305,
      child: InputText(
        fondoColor: Colors.white,
        borderColor: Recursos.ColorBorderSuave,
        label: label,
        placeholder: placeholder,
        onChanged: onChanged,
      ),
    );
  }
}
