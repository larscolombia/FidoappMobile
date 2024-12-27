import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:pawlly/components/button_default_widget.dart';
import 'package:pawlly/modules/components/input_select.dart';
import 'package:pawlly/modules/components/input_text.dart';
import 'package:pawlly/modules/home/controllers/home_controller.dart';
import 'package:pawlly/modules/integracion/controller/categoria/categoria_controller.dart';
import 'package:pawlly/modules/integracion/controller/historial_clinico/historial_clinico_controller.dart';
import 'package:pawlly/modules/profile_pet/screens/confirmar_formulario.dart';
import 'package:pawlly/styles/styles.dart';

class FormularioRegistro extends StatelessWidget {
  final HistorialClinicoController controller =
      Get.put(HistorialClinicoController());
  final CategoryController categoryController = Get.put(CategoryController());
  final HomeController homeController = Get.find<HomeController>();

  FormularioRegistro({super.key});
  @override
  Widget build(BuildContext context) {
    var ancho = MediaQuery.of(context).size.width - 80;
    controller.updateField("pet_id", homeController.selectedProfile.value!.id);

    return Scaffold(
      backgroundColor: Styles.fiveColor,
      body: Container(
        color: Styles.fiveColor,
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 150,
                decoration: const BoxDecoration(
                  color: Styles.fiveColor,
                ),
                child: const Text(
                  'Registro de Historial',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.all(10),
                          width: 302,
                          child: GestureDetector(
                            onTap: () {
                              Get.back();
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  child: const Icon(
                                    Icons.arrow_back_ios,
                                    color: Styles.primaryColor,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                const Text(
                                  "Informe Médico",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Styles.primaryColor,
                                    fontFamily: 'PoetsenOne',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        InputText(
                          label: '',
                          placeholder: 'Nombre del informe',
                          onChanged: (value) {
                            print('value $value');
                            controller.updateField("name", value);
                          },
                        ),
                        SizedBox(
                          height: 90,
                          width: ancho,
                          child: Obx(() {
                            if (categoryController.categories.isEmpty) {
                              categoryController.fetchCategories();
                              return const Text(
                                  'No hay categorías disponibles');
                            }

                            return InputSelect(
                              label: '',
                              placeholder: 'Categoría del informe',
                              TextColor: Colors.black,
                              onChanged: (value) {
                                controller.updateField("category",
                                    value); // Actualizamos el controlador
                              },
                              items: categoryController.categories
                                  .map((category) => DropdownMenuItem<String>(
                                        value: category.id
                                            .toString(), // ID de la categoría como valor
                                        child: Text(category
                                            .name), // Nombre de la categoría como texto
                                      ))
                                  .toList(),
                            );
                          }),
                        ),
                        InputText(
                          label: '',
                          placeholder: 'Fecha de Aplicación',
                          isDateField: true,
                          onChanged: (value) {
                            controller.updateField("fecha_aplicacion", value);
                          },
                          suffixIcon: const Icon(
                            Icons.arrow_drop_down,
                            color: Styles.fiveColor,
                          ),
                          prefiIcon: const Icon(
                            Icons.calendar_today,
                            color: Color.fromRGBO(252, 186, 103, 1),
                          ),
                        ),
                        InputText(
                          label: '',
                          placeholder: 'Fecha de refuerzo',
                          isDateField: true,
                          onChanged: (value) {
                            controller.updateField("fecha_refuerzo", value);
                          },
                          suffixIcon: const Icon(
                            Icons.arrow_drop_down,
                            color: Color.fromRGBO(252, 186, 103, 1),
                          ),
                          prefiIcon: const Icon(
                            Icons.calendar_today,
                            color: Color.fromRGBO(252, 186, 103, 1),
                          ),
                        ),
                        InputText(
                          label: '',
                          placeholder: 'Notas adicionales',
                          onChanged: (value) {
                            controller.updateField("notes", value);
                            controller.updateField("medical_conditions", value);
                          },
                        ),
                        const SizedBox(height: 10),
                        InputText(
                          label: "Adjuntar imagen",
                          placeholder: "Sube tu archivo",
                          isFilePicker: true,
                          prefiIcon: const Icon(
                            Icons.file_copy,
                            color: Color.fromRGBO(252, 186, 103, 1),
                          ),
                          onChanged: (filePath) {
                            print("Archivo seleccionado: $filePath");
                          },
                        ),
                        const SizedBox(height: 10),
                        InputText(
                          label: "Adjuntar archivo",
                          placeholder: "Sube tu archivo",
                          isFilePicker: true,
                          prefiIcon: const Icon(
                            Icons.file_copy,
                            color: Color.fromRGBO(252, 186, 103, 1),
                          ),
                          onChanged: (filePath) {
                            print("Archivo seleccionado: $filePath");
                          },
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: SizedBox(
                            width: 302,
                            child: ButtonDefaultWidget(
                              title: 'Terminar Informe  >',
                              callback: () {
                                print(
                                    'reporte data editar${controller.reportData}');
                                controller.isEditing.value = false;
                                if (controller.validateReportData()) {
                                  Get.to(ConfirmarFormulario());
                                } else {
                                  Get.snackbar("Error",
                                      "Por favor, rellene todos los campos");
                                }
                                // Get.to(ConfirmarFormulario());
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
