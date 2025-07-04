import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pawlly/components/button_default_widget.dart';
import 'package:pawlly/components/custom_date_form_field_widget.dart';
import 'package:pawlly/components/custom_select_form_field_widget.dart';
import 'package:pawlly/components/custom_text_form_field_widget.dart';
import 'package:pawlly/main.dart';
import 'package:pawlly/modules/add_pet/controllers/add_pet_controller.dart';
import 'package:pawlly/styles/styles.dart';

class AddPetScreen extends StatelessWidget {
  final AddPetController controller = Get.put(AddPetController());
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  AddPetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final headerHeight = size.height / 6;

    return Scaffold(
      body: Container(
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
                  borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
                ),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    padding: const EdgeInsets.only(top: 16),
                    children: [
                      // Información general
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
                          controller: controller.petName,
                          placeholder: locale.value.petName,
                          validators: [
                            (value) => (value?.isEmpty ?? true) ? 'El nombre es requerido' : null,
                          ],
                        ),
                      ),

                      // Campo para la descripción de la mascota
                      Container(
                        margin: const EdgeInsets.only(top: 20),
                        child: CustomTextFormFieldWidget(
                          controller: controller.petDescription,
                          placeholder: locale.value.addYourPetInformation,
                        ),
                      ),

                      // Selector de imagen
                      GestureDetector(
                        onTap: () => controller.pickImage(),
                        child: Obx(
                          () => Container(
                            margin: const EdgeInsets.only(top: 20),
                            width: size.width,
                            height: size.width,
                            decoration: BoxDecoration(
                              image: const DecorationImage(image: AssetImage('assets/icons/imagen.png'), fit: BoxFit.cover),
                              color: Styles.iconColorBack,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: controller.petImage.value != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: Image.file(
                                      File(controller.petImage.value!.path),
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
                          ),
                        ),
                      ),

                      // Selector de fecha de nacimiento
                      Container(
                        margin: const EdgeInsets.only(top: 20),
                        child: CustomDateFormFieldWidget(
                          controller: controller.petBirthDateController,
                          placeholder: 'Fecha de nacimiento',
                          imagePath: 'assets/icons/calendar2.png',
                        ),
                      ),

                      // Campo para seleccionar la raza de la mascota
                      Container(
                        margin: const EdgeInsets.only(top: 20),
                        child: Obx(() {
                          return CustomSelectFormFieldWidget(
                            controller: controller.petBreed,
                            placeholder: locale.value.petBreed,
                            icon: 'assets/icons/patica.png',
                            filcolorCustom: Styles.fiveColor,
                            items: controller.breedList.isNotEmpty ? controller.breedList.map((breed) => breed.name).toList() : ['No disponible'],
                            validators: [
                              (value) {
                                if (value == null || value.isEmpty) {
                                  return 'El campo raza es requerido'; // Mensaje de error personalizado
                                }
                                return null;
                              },
                            ], // Validación de Campo requerido
                          );
                        }),
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
                                  controller.petGender.value = 'female';
                                },
                                child: Obx(
                                  () => Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: controller.petGender.value == 'female' ? Colors.white : const Color.fromRGBO(254, 247, 229, 1),
                                      border: Border.all(
                                        color: controller.petGender.value == 'female' ? Styles.iconColorBack : Colors.transparent,
                                      ),
                                      borderRadius: BorderRadius.circular(16),
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
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            // Opción male
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  controller.petGender.value = 'male';
                                },
                                child: Obx(
                                  () => Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: controller.petGender.value == 'male' ? Colors.white : const Color.fromRGBO(254, 247, 229, 1),
                                      border: Border.all(color: controller.petGender.value == 'male' ? Styles.iconColorBack : Colors.transparent),
                                      borderRadius: BorderRadius.circular(16),
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
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Campo para el peso de la mascota
                      Container(
                        margin: const EdgeInsets.only(top: 20),
                        child: Obx(() {
                          return CustomTextFormFieldWidget(
                            controller: controller.petWeightController,
                            placeholder: locale.value.weight,
                            isNumeric: true,
                            icon: 'assets/icons/weight.png',
                            suffixText: controller.petWeightUnit.value,
                            suffixIcon: IconButton(
                              onPressed: () {
                                controller.toogleWeightUnit();
                              },
                              icon: const Icon(
                                Icons.swap_horiz,
                                color: Styles.iconColorBack,
                              ),
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 20),

                      // Botón para enviar el formulario
                      Obx(
                        () => ButtonDefaultWidget(
                          title: '${locale.value.addPet} +',
                          isLoading: controller.isLoading.value,
                          callback: () {
                            if (_formKey.currentState!.validate()) {
                              controller.submitForm(_formKey);
                              controller.resetForm();
                            }
                          },
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
    );
  }
}
