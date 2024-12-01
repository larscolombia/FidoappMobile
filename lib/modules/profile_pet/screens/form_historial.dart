import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:pawlly/components/button_default_widget.dart';
import 'package:pawlly/modules/components/input_select.dart';
import 'package:pawlly/modules/components/input_text.dart';
import 'package:pawlly/modules/integracion/controller/categoria/categoria_controller.dart';
import 'package:pawlly/modules/integracion/controller/historial_clinico/historial_clinico_controller.dart';
import 'package:pawlly/modules/profile_pet/screens/confirmar_formulario.dart';
import 'package:pawlly/styles/styles.dart';

class FormularioRegistro extends StatelessWidget {
  final HistorialClinicoController controller =
      Get.put(HistorialClinicoController());
  final CategoryController categoryController = Get.put(CategoryController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.fiveColor,
      body: Container(
        color: Styles.fiveColor,
        child: Container(
          width: double.infinity,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 150,
                decoration: BoxDecoration(
                  color: Styles.fiveColor,
                ),
                child: Text(
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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                child: Icon(
                                  Icons.arrow_back_ios,
                                  color: Styles.primaryColor,
                                ),
                              ),
                              const SizedBox(width: 10),
                              GestureDetector(
                                onTap: () {
                                  Get.back();
                                },
                                child: const Text(
                                  "Informe Médico",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Styles.primaryColor,
                                    fontFamily: 'PoetsenOne',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        InputText(
                          label: '',
                          placeholder: 'Nombre',
                          onChanged: (value) {
                            print('value $value');
                            controller.updateField("name", value);
                            controller.updateField("report_name", value);
                          },
                        ),
                        Container(
                          height: 90,
                          width: 304,
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
                                print('Categoría seleccionada: $value');
                              },
                              items: categoryController.categories
                                  .map((category) => DropdownMenuItem<String>(
                                        value: category.id
                                            .toString(), // ID de la categoría como valor
                                        child: Text(category
                                            .name), // Nombre de la categoría como texto
                                      ))
                                  .toList(),
                              suffixIcon:
                                  const Icon(Icons.arrow_drop_down_sharp),
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
                          suffixIcon: Icon(
                            Icons.arrow_drop_down,
                            color: Styles.primaryColor,
                          ),
                          prefiIcon: Icon(
                            Icons.calendar_today,
                            color: Styles.primaryColor,
                          ),
                        ),
                        InputText(
                          label: '',
                          placeholder: 'Fecha de refuerzo',
                          isDateField: true,
                          onChanged: (value) {
                            controller.updateField("fecha_refuerzo", value);
                          },
                          suffixIcon: Icon(
                            Icons.arrow_drop_down,
                            color: Styles.primaryColor,
                          ),
                          prefiIcon: Icon(
                            Icons.calendar_today,
                            color: Styles.primaryColor,
                          ),
                        ),
                        InputText(
                          label: '',
                          placeholder: 'Notas adicionales',
                          onChanged: (value) {
                            controller.updateField("notes", value);
                          },
                        ),
                        const SizedBox(height: 10),
                        InputText(
                          label: "Adjuntar imagen",
                          placeholder: "Sube tu archivo",
                          isFilePicker: true,
                          prefiIcon: Icon(
                            Icons.file_copy,
                            color: Styles.primaryColor,
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
                          prefiIcon: Icon(
                            Icons.file_copy,
                            color: Styles.primaryColor,
                          ),
                          onChanged: (filePath) {
                            print("Archivo seleccionado: $filePath");
                          },
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: Container(
                            width: 302,
                            child: ButtonDefaultWidget(
                              title: 'Terminar Informe  >',
                              callback: () {
                                controller.isEditing.value = false;
                                Get.to(ConfirmarFormulario());
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
