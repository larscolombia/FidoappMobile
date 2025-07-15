import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pawlly/components/button_default_widget.dart';
import 'package:pawlly/modules/components/input_select.dart';
import 'package:pawlly/modules/components/input_text.dart';
import 'package:pawlly/modules/components/regresr_components.dart';
import 'package:pawlly/modules/helper/helper.dart';
import 'package:pawlly/modules/home/controllers/home_controller.dart';
import 'package:pawlly/modules/integracion/controller/categoria/categoria_controller.dart';
import 'package:pawlly/modules/integracion/controller/historial_clinico/historial_clinico_controller.dart';
import 'package:pawlly/styles/styles.dart';

import '../../../components/custom_snackbar.dart';

class FormularioRegistro extends StatelessWidget {
  final HistorialClinicoController controller =
      Get.put(HistorialClinicoController());
  final CategoryController categoryController = Get.put(CategoryController());
  final HomeController homeController = Get.find<HomeController>();

  FormularioRegistro({super.key});
  @override
  Widget build(BuildContext context) {
    var ancho = MediaQuery.sizeOf(context).width;
    var margen = Helper.margenDefault;
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
                child: Center(
                  child: Container(
                    margin: const EdgeInsets.only(top: 40),
                    child: const Text(
                      'Registro de Historial',
                      style: Helper.tuttleStyle,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  padding: Styles.paddingAll,
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
                        SizedBox(height: margen + margen),
                        BarraBack(
                            titulo: 'Informe Médico',
                            callback: () {
                              Get.back();
                            }),
                        SizedBox(height: margen + margen),
                        SizedBox(
                          width: ancho,
                          child: InputText(
                            placeholder: 'Nombre del informe',
                            onChanged: (value) {
                              print('Nombre del informe: $value');
                              controller.updateField("name", value);
                              controller.updateField("report_name", value);
                            },
                          ),
                        ),
                        SizedBox(height: margen - 8),
                        SizedBox(
                          width: ancho,
                          child: Obx(() {
                            if (categoryController.categories.isEmpty) {
                              categoryController.fetchCategories();
                              return const Text(
                                  'No hay categorías disponibles');
                            }

                            return InputSelect(
                              prefiIcon: 'assets/icons/nota.png',
                              placeholder: 'Categoría del informe',
                              TextColor: Colors.black,
                              borderColor: const Color(0xFFFC9214),
                              prefixIconColor: const Color(0xFFFC9214),
                              iconColor: const Color(0xFFFC9214),
                              onChanged: (value) {
                                print('Categoría seleccionada: $value');
                                controller.updateField("category", value);
                              },
                              items: categoryController.categories
                                  .map((category) => DropdownMenuItem<String>(
                                        value: category.id.toString(),
                                        child: Text(
                                          category.name,
                                          style: Helper.selectStyle,
                                        ),
                                      ))
                                  .toList(),
                            );
                          }),
                        ),
                        SizedBox(height: margen),
                        SizedBox(
                          width: ancho,
                          child: InputText(
                            placeholder: 'Fecha de Aplicación',
                            placeholderSvg: 'assets/icons/svg/calendar.svg',
                            borderColor: const Color(0xFFFC9214),
                            isDateField: true,
                            onChanged: (value) {
                              print('Fecha seleccionada: $value');
                              controller.updateField("fecha_aplicacion", value);
                              controller.updateField("fecha_refuerzo", value);
                            },
                          ),
                        ),
                        SizedBox(height: margen),
                        Container(
                          child: InputText(
                            isTextArea: true,
                            placeholder: 'Notas adicionales',
                            onChanged: (value) {
                              print('Notas ingresadas: $value');
                              controller.updateField("notes", value);
                              controller.updateField(
                                  "medical_conditions", value);
                            },
                          ),
                        ),
                        SizedBox(height: margen - 8),
                        SizedBox(
                          width: ancho,
                          child: InputText(
                            label: "Adjuntar imagen",
                            isImagePicker: true,
                            placeholderSvg: 'assets/icons/svg/imagen2.svg',
                            onChanged: (filePath) {
                              print("Imagen seleccionada: $filePath");
                              controller.updateField("image", filePath);
                            },
                          ),
                        ),
                        SizedBox(height: margen - 8),
                        SizedBox(
                          width: ancho,
                          child: InputText(
                            label: "Adjuntar archivo",
                            isFilePicker: true,
                            placeholderSvg: 'assets/icons/svg/imagen2.svg',
                            onChanged: (filePath) {
                              print("Archivo PDF seleccionado: $filePath");
                              controller.updateField("file", filePath);
                            },
                          ),
                        ),
                        SizedBox(height: margen),
                        Obx(() {
                          return Center(
                            child: SizedBox(
                              width: ancho,
                              child: ButtonDefaultWidget(
                                title: controller.isEditing.value
                                    ? 'Guardando...'
                                    : 'Terminar Informe  >',
                                callback: () {
                                  controller.isEditing.value = true;
                                  if (controller.validateReportData()) {
                                    controller.submitReport();
                                  } else {
                                    CustomSnackbar.show(
                                      title: 'Error',
                                      message:
                                          'Por favor, rellene todos los campos',
                                      isError: true,
                                    );
                                  }
                                  //Get.to(ConfirmarFormulario());
                                },
                              ),
                            ),
                          );
                        }),
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
