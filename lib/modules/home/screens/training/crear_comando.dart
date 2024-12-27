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
              color: Styles.colorContainer, // Cambia el color según tu diseño
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
                      SizedBox(
                        width: 305,
                        child: const Text("Selecciona la mascota",
                            style: Styles.TextTituloAutor),
                      ),
                      SizedBox(
                        width: 325,
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
                          label: 'Acción',
                          placeholder: 'Nombre del Comando',
                          onChanged: (value) =>
                              controller.updateField('description', value),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: 305,
                        child: InputText(
                          label: 'Comando',
                          placeholder: 'Nombre del Comando',
                          onChanged: (value) =>
                              controller.updateField('voz_comando', value),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: 305,
                        child: InputText(
                          label: 'Comando',
                          placeholder: 'Nombre del Comando',
                          onChanged: (value) =>
                              controller.updateField('instructions', value),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: 302,
                        child: ButtonDefaultWidget(
                            title: controller.isLoading.value
                                ? 'Creando...'
                                : 'Guardar',
                            callback: () {
                              controller.updateField(
                                'pet_id',
                                homeController.selectedProfile.value!.id,
                              );
                              controller.postCommand(controller.dataComando);
                            }),
                      ),
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
