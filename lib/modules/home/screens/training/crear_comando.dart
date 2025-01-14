import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pawlly/components/button_default_widget.dart';
import 'package:pawlly/modules/components/input_text.dart';

import 'package:pawlly/modules/components/regresr_components.dart';
import 'package:pawlly/modules/components/style.dart';
import 'package:pawlly/modules/home/controllers/home_controller.dart';
import 'package:pawlly/modules/home/screens/home_screen.dart';
import 'package:pawlly/modules/home/screens/pages/profile_dogs.dart';
import 'package:pawlly/modules/integracion/controller/comandos/comandos_controller.dart';
import 'package:pawlly/modules/integracion/model/comandos_model/comandos_model.dart';

class CrearComando extends StatelessWidget {
  CrearComando({super.key});
  final ComandoController controller = Get.put(ComandoController());
  final HomeController homeController = Get.find<HomeController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Primer contenedor (fondo o header)
          Container(
            height: 120,
            decoration: const BoxDecoration(
              color: Styles.colorContainer,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ), // Cambia el color según tu diseño
            ),
          ),
          // Segundo contenedor (superpuesto con scroll)
          Expanded(
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
                      const SizedBox(height: 10),
                      SizedBox(
                        width: 305,
                        child: BarraBack(
                          titulo: 'Crear Comando',
                          callback: () {
                            Get.off(HomeScreen());
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      const SizedBox(
                        width: 305,
                        child: Text("Selecciona la mascota",
                            style: TextStyle(
                              fontFamily: 'Lato',
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color(0XFF383838),
                            )),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        width: 305,
                        child: ProfilesDogs(),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: 305,
                        child: InputText(
                          label: 'Nombre del Comando',
                          placeholder: 'Nombre del Comando',
                          onChanged: (value) =>
                              controller.updateField('name', value),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: 305,
                        child: InputText(
                          label: 'Descripción del Comando',
                          placeholder: 'Descripción del Comando',
                          onChanged: (value) =>
                              controller.updateField('description', value),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: 305,
                        child: InputText(
                          label: 'Voz del Comando',
                          placeholder: 'Voz del Comando',
                          onChanged: (value) =>
                              controller.updateField('voz_comando', value),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: 305,
                        child: InputText(
                          label: 'Instrucciones del Comando',
                          placeholder: 'Instrucciones del Comando',
                          onChanged: (value) =>
                              controller.updateField('instructions', value),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Obx(() {
                        return SizedBox(
                          width: 302,
                          child: ButtonDefaultWidget(
                              title: controller.isLoading.value
                                  ? 'Creando...'
                                  : 'Crear comando',
                              callback: () {
                                controller.updateField(
                                  'pet_id',
                                  homeController.selectedProfile.value!.id,
                                );
                                controller.postCommand(controller.dataComando);
                              }),
                        );
                      })
                    ],
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
