import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pawlly/components/button_default_widget.dart';
import 'package:pawlly/components/custom_date_form_field_widget.dart';
import 'package:pawlly/components/custom_select_form_field_widget.dart';
import 'package:pawlly/components/custom_text_form_field_widget.dart';
import 'package:pawlly/main.dart';
import 'package:pawlly/modules/add_pet/controllers/add_pet_controller.dart';
import 'package:pawlly/styles/styles.dart';

class AddPetScreen extends GetView<AddPetController> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController petName = TextEditingController();
  final TextEditingController petDescription = TextEditingController();
  final TextEditingController petWeightController = TextEditingController();
  final TextEditingController petBirthDateController = TextEditingController();
  final TextEditingController petBreed = TextEditingController();

  final Rx<XFile?> petImage = Rx<XFile?>(null);
  final RxString petGender = ''.obs;

  AddPetScreen({super.key});

  @override
  void dispose() {
    petName.dispose();
    petDescription.dispose();
    petWeightController.dispose();
    petBirthDateController.dispose();
    petBreed.dispose();
  }

  void clearForm() {
    petName.clear();
    petDescription.clear();
    petWeightController.clear();
    petBirthDateController.clear();
    petBreed.clear();
    petImage.value = null;
    petGender.value = '';
    controller.clearForm();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final headerHeight = size.height / 6;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: Styles.fiveColor,
            child: Column(
              children: [
                // Encabezado de la pantalla
                Container(
                  height: headerHeight,
                  width: double.infinity,
                  padding: Styles.paddingAll,
                  decoration: const BoxDecoration(
                    color: Styles.fiveColor,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(35),
                      bottomRight: Radius.circular(35),
                    ),
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 60),
                      Text(
                        'Completa la Información',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                          fontFamily: 'PoetsenOne',
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        'Añade los datos de tu mascota',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          fontFamily: 'PoetsenOne',
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                // Contenido del formulario
                Expanded(
                  child: Container(
                    padding: Styles.paddingAll,
                    margin: const EdgeInsets.only(top: 16),
                    decoration: const BoxDecoration(
                      color: Styles.whiteColor,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(25)),
                    ),
                    child: Form(
                      key: _formKey, // Asignar la clave del formulario
                      child: ListView(
                        padding: const EdgeInsets.only(top: 16),
                        children: [
                          Container(
                            padding: const EdgeInsets.only(
                              top: 20,
                            ),
                            alignment: Alignment.center,
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.only(
                                    bottom: 20,
                                  ),
                                  child: Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () => Navigator.pop(context),
                                        child: const Icon(
                                          Icons.arrow_back_ios,
                                          color: Styles.primaryColor,
                                          size: 22,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      const Text(
                                        'Información General',
                                        style: Styles.dashboardTitle20,
                                      ),
                                    ],
                                  ),
                                ),
                                // Divider(height: 0, thickness: 1),
                              ],
                            ),
                          ),

                          // Campo para el nombre de la mascota
                          Container(
                            margin: const EdgeInsets.only(top: 20),
                            child: CustomTextFormFieldWidget(
                              controller: petName,
                              placeholder: locale.value.petName,
                              validators: [
                                (value) => (value?.isEmpty ?? true)
                                    ? 'El nombre es requerido'
                                    : null,
                              ],
                            ),
                          ),
                          // Campo para la descripción de la mascota
                          Container(
                            margin: const EdgeInsets.only(top: 20),
                            child: CustomTextFormFieldWidget(
                              controller: petDescription,
                              placeholder: locale.value.addYourPetInformation,
                            ),
                          ),
                          // Selector de imagen
                          GestureDetector(
                            onTap: () async {
                              final ImagePicker picker = ImagePicker();
                              final XFile? image = await picker.pickImage(
                                  source: ImageSource.gallery);
                              if (image != null) {
                                petImage.value = image;
                              }
                            },
                            child: Obx(() => Container(
                                  margin: const EdgeInsets.only(top: 20),
                                  width: size.width,
                                  height: size.width,
                                  decoration: BoxDecoration(
                                    image: const DecorationImage(
                                        image: AssetImage(
                                            'assets/icons/imagen.png'),
                                        fit: BoxFit.cover),
                                    color: Styles.iconColorBack,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: petImage.value != null
                                      ? ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          child: Image.file(
                                            File(petImage.value!.path),
                                            fit: BoxFit.cover,
                                            width: size.width,
                                            height: size.width,
                                          ),
                                        )
                                      : const Icon(
                                          Icons.add_a_photo,
                                          size: 50,
                                          color: Colors.white,
                                        ),
                                )),
                          ),
                          // Selector de fecha de nacimiento
                          Container(
                            margin: const EdgeInsets.only(top: 20),
                            child: CustomDateFormFieldWidget(
                                controller: petBirthDateController,
                                placeholder: 'Fecha de aplicación',
                                imagePath: 'assets/icons/calendar2.png'),
                          ),
                          // Campo para seleccionar la raza de la mascota
                          Container(
                            margin: const EdgeInsets.only(top: 20),
                            child: CustomSelectFormFieldWidget(
                              controller: petBreed,
                              placeholder: locale.value.petBreed,
                              icon: 'assets/icons/patica.png',
                              filcolorCustom: Styles.fiveColor,
                              items: controller.breedList.isNotEmpty
                                  ? controller.breedList
                                      .map((breed) => breed.name)
                                      .toList()
                                  : ['No disponible'],
                              validators: [
                                (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'El campo raza es requerido'; // Mensaje de error personalizado
                                  }
                                  return null;
                                },
                              ], // Validación de campo requerido
                            ),
                          ),

                          // Selector de género
                          Container(
                            margin: const EdgeInsets.only(top: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                // Opción female
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      petGender.value = 'female';
                                    },
                                    child: Obx(() => Container(
                                          padding: const EdgeInsets.all(16),
                                          decoration: BoxDecoration(
                                            color: petGender.value == 'female'
                                                ? Colors.white
                                                : const Color.fromRGBO(
                                                    254, 247, 229, 1),
                                            border: Border.all(
                                              color: petGender.value == 'female'
                                                  ? Styles.iconColorBack
                                                  : Colors.transparent,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(16),
                                          ),
                                          child: const Center(
                                            child: Text(
                                              'Hembra',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w400,
                                                fontFamily: 'Lato',
                                              ),
                                            ),
                                          ),
                                        )),
                                  ),
                                ),
                                const SizedBox(
                                    width: 16), // Espacio entre los cuadros
                                // Opción male
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      petGender.value = 'male';
                                    },
                                    child: Obx(() => Container(
                                          padding: const EdgeInsets.all(16),
                                          decoration: BoxDecoration(
                                            color: petGender.value == 'male'
                                                ? Colors.white
                                                : const Color.fromRGBO(
                                                    254, 247, 229, 1),
                                            border: Border.all(
                                                color: petGender.value == 'male'
                                                    ? Styles.iconColorBack
                                                    : Colors.transparent),
                                            borderRadius:
                                                BorderRadius.circular(16),
                                          ),
                                          child: const Center(
                                            child: Text(
                                              'Macho',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w400,
                                                fontFamily: 'Lato',
                                              ),
                                            ),
                                          ),
                                        )),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Campo para el peso de la mascota
                          Container(
                            margin: const EdgeInsets.only(top: 20),
                            child: CustomTextFormFieldWidget(
                              controller: petWeightController,
                              placeholder: locale.value.weight,
                              isNumeric: true,
                              icon: 'assets/icons/weight.png',
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Botón para enviar el formulario
                          ButtonDefaultWidget(
                            title: '${locale.value.addPet} +',
                            isLoading: controller.isLoading
                                .value, // Mostrar loader si está cargando
                            callback: () async {
                              if (_formKey.currentState!.validate()) {
                                bool success = await controller.submitForm(
                                    _formKey,
                                    petName.text,
                                    petDescription.text,
                                    petWeightController.text,
                                    petBirthDateController.text,
                                    petBreed.text,
                                    petGender.value,
                                    petImage.value?.path ??
                                        ''); // Enviar formulario si es válido
                                if (success) {
                                  clearForm(); // Limpiar el formulario después de enviar
                                  Get.back(); // Navegar hacia atrás
                                }
                              }
                            },
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
          Obx(() {
            if (controller.isLoading.value) {
              return Container(
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else {
              return SizedBox.shrink();
            }
          }),
        ],
      ),
    );
  }
}
