import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pawlly/components/button_default_widget.dart';
import 'package:pawlly/components/custom_select_widget.dart';
import 'package:pawlly/components/custom_snackbar.dart';
import 'package:pawlly/components/regresr_components.dart';
import 'package:pawlly/modules/components/input_text.dart';
import 'package:pawlly/modules/components/style.dart';
import 'package:pawlly/modules/helper/helper.dart';
import 'package:pawlly/modules/home/controllers/home_controller.dart';
import 'package:pawlly/modules/integracion/controller/categoria/categoria_controller.dart';
import 'package:pawlly/modules/integracion/controller/diario/activida_mascota_controller.dart';

class FormularioDiario extends StatelessWidget {
  final bool isEdit;
  final bool? cambio;
  final String? ImagenEdit;

  FormularioDiario({
    super.key,
    this.isEdit = false,
    this.cambio = false,
    this.ImagenEdit,
  });

  final PetActivityController controller = Get.put(PetActivityController());
  final CategoryController categoryController = Get.put(CategoryController());
  final HomeController homeController = Get.put(HomeController());
  final RxMap<String, RxBool> validate = {
    'actividad': false.obs,
    'date': false.obs,
    'notas': false.obs,
  }.obs;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final margen = 16.0;
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 200,
              color: Styles.colorContainer,
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Completa la Información',
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'PoetsenOne',
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      'Añade los datos de este diario',
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Lato',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 150,
            left: 0,
            right: 0,
            bottom: 0,
            child: SingleChildScrollView(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: margen),
                    Padding(
                      padding: const EdgeInsets.all(Helper.paddingDefault),
                      child: Column(
                        children: [
                          BarraBack(
                            titulo: 'Nuevo Registro',
                            size: 20,
                            callback: () => Get.back(),
                          ),
                          SizedBox(height: margen),
                          // Título del registro
                          SizedBox(
                            width: width,
                            child: InputText(
                              initialValue: isEdit ? controller.activitiesOne.value!.actividad ?? "" : "",
                              label: 'Título del registro',
                              placeholder: '',
                              errorText: validate['actividad']!.value ? 'Campo requerido' : '',
                              onChanged: (value) {
                                controller.updateField('actividad', value);
                                validate['actividad']!.value = value.isEmpty;
                              },
                            ),
                          ),
                          SizedBox(height: margen),
                          // Categoría
                          SizedBox(
                            width: width,
                            child: // Campo para seleccionar la categoría
                                Container(
                              margin: const EdgeInsets.only(top: 20),
                              child: Obx(() {
                                return CustomSelectWidget(
                                  onChange: controller.updateCategoryField,
                                  placeholder: 'Seleccionar categoría',
                                  icon: 'assets/icons/patica.png',
                                  filcolorCustom: Styles.colorContainer,
                                  items: categoryController.diaryCategories.isNotEmpty
                                      ? categoryController.diaryCategories.map((b) => SelectItem(label: b.name, value: b.id.toString())).toList()
                                      : [SelectItem(label: 'No disponible', value: '')],
                                  validators: [
                                    (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'El campo categoría es requerido'; // Mensaje de error personalizado
                                      }
                                      return null;
                                    },
                                  ],
                                  controller: null, // Validación de Campo requerido
                                );
                              }),
                            ),
                          ),
                          SizedBox(height: margen),
                          // Fecha
                          SizedBox(
                            width: width,
                            child: InputText(
                              initialValue: isEdit ? controller.activitiesOne.value!.date : '',
                              label: 'Fecha del registro',
                              placeholder: '',
                              isDateField: true,
                              placeholderSvg: 'assets/icons/svg/calendar.svg',
                              placeholderSuffixSvg: 'assets/icons/svg/flecha_select.svg',
                              suffixIcon: const Icon(
                                Icons.arrow_drop_down_sharp,
                                color: Styles.iconColorBack,
                              ),
                              errorText: validate['date']!.value ? 'Campo requerido' : '',
                              onChanged: (value) {
                                controller.updateField('date', value);
                                validate['date']!.value = value.isEmpty;
                              },
                            ),
                          ),
                          SizedBox(height: margen),
                          // Descripción
                          SizedBox(
                            width: width,
                            child: InputText(
                              isTextArea: true,
                              initialValue: isEdit ? controller.activitiesOne.value!.notas : '',
                              label: 'Descripción',
                              placeholder: 'Describe el evento',
                              errorText: validate['notas']!.value ? 'Campo requerido' : '',
                              onChanged: (value) {
                                controller.updateField('notas', value);
                                validate['notas']!.value = value.isEmpty;
                              },
                            ),
                          ),
                          SizedBox(height: margen),
                          // Adjuntar imagen
                          SizedBox(
                            width: width,
                            child: InputText(
                              label: 'Adjuntar imagen',
                              placeholderSvg: 'assets/icons/svg/imagen2.svg',
                              placeholder: 'Añadir imagen',
                              placeholderSuffixSvg: 'assets/icons/svg/vector_select_images.svg',
                              isImagePicker: true,
                              onChanged: (value) {
                                controller.updateField('image', value);
                              },
                            ),
                          ),
                          if (isEdit && cambio == false && ImagenEdit != null)
                            Column(
                              children: [
                                const Text("Imagen Actual"),
                                Image.network(
                                  controller.activitiesOne.value!.image ?? "",
                                  width: width,
                                  height: 220,
                                  fit: BoxFit.cover,
                                  loadingBuilder: (context, child, loadingProgress) {
                                    return loadingProgress == null ? child : const Center(child: CircularProgressIndicator());
                                  },
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      width: 250,
                                      height: 150,
                                      child: const Icon(Icons.image, color: Colors.blue),
                                    );
                                  },
                                ),
                              ],
                            ),
                          SizedBox(height: margen),
                          // Botón Finalizar
                          SizedBox(
                            width: width,
                            height: 54,
                            child: Obx(() {
                              return ButtonDefaultWidget(
                                title: isEdit
                                    ? controller.isLoading.value
                                        ? 'Cargando ...'
                                        : 'Editar'
                                    : controller.isLoading.value
                                        ? 'Cargando ...'
                                        : 'Finalizar',
                                callback: () {
                                  if (validate['actividad']!.value || validate['date']!.value || validate['notas']!.value) {
                                    CustomSnackbar.show(
                                      title: 'Error',
                                      message: 'Por favor, rellene todos los campos requeridos',
                                      isError: true,
                                    );
                                    return;
                                  }
                                  //este es el id del animal
                                  controller.updateField('pet_id', homeController.selectedProfile.value!.id.toString());
                                  isEdit
                                      ? controller.editPetActivity2(
                                          "${controller.activitiesOne.value!.id}",
                                          File(controller.diario['image'] ?? ''),
                                        )
                                      : controller.addPetActivity(File(controller.diario['image'] ?? ''));
                                },
                              );
                            }),
                          ),
                          SizedBox(height: margen + 30),
                        ],
                      ),
                    ),
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
