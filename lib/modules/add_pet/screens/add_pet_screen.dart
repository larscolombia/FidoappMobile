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
                children: [
                  Text(
                    'Completa la Información',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Styles.tertiaryColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Añade los datos de tu mascota',
                    style: TextStyle(
                      fontSize: 14,
                      color: Styles.tertiaryColor,
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
                margin: EdgeInsets.only(top: 16),
                decoration: BoxDecoration(
                  color: Styles.whiteColor,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
                ),
                child: Form(
                  key: _formKey, // Asignar la clave del formulario
                  child: ListView(
                    padding: EdgeInsets.only(top: 16),
                    children: [
                      Container(
                        padding: EdgeInsets.only(
                          top: 20,
                        ),
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.only(
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
                                  SizedBox(
                                    width: 10,
                                  ),
                                  const Text(
                                    'Lista de Mascotas',
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
                        margin: EdgeInsets.only(top: 20),
                        child: CustomTextFormFieldWidget(
                          controller: controller.petName,
                          placeholder: locale.value.petName,
                          icon: 'assets/icons/profile.png',
                          validators: [
                            (value) => (value?.isEmpty ?? true)
                                ? 'El nombre es requerido'
                                : null,
                          ],
                        ),
                      ),

                      // Campo para la descripción de la mascota
                      Container(
                        margin: EdgeInsets.only(top: 20),
                        child: CustomTextFormFieldWidget(
                          controller: controller.petDescription,
                          placeholder: locale.value.addYourPetInformation,
                          icon: 'assets/icons/profile.png',
                        ),
                      ),
                      // Selector de imagen
                      GestureDetector(
                        onTap: () => controller.pickImage(),
                        child: Obx(
                          () => Container(
                            margin: EdgeInsets.only(top: 20),
                            width: size.width,
                            height: size.width,
                            decoration: BoxDecoration(
                              color: Styles.iconColorBack,
                              border: Border.all(color: Styles.iconColorBack),
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
                                : Icon(
                                    Icons.add_a_photo,
                                    size: 50,
                                    color: Colors.white,
                                  ),
                          ),
                        ),
                      ),
                      // Selector de fecha de nacimiento
                      Container(
                        margin: EdgeInsets.only(top: 20),
                        child: CustomDateFormFieldWidget(
                          controller: controller.petBirthDateController,
                          placeholder: locale.value.birthday,
                        ),
                      ),
                      // Campo para seleccionar la raza de la mascota
                      Container(
                        margin: EdgeInsets.only(top: 20),
                        child: Obx(() {
                          return CustomSelectFormFieldWidget(
                            controller: controller.petBreed,
                            placeholder: locale.value.petBreed,
                            icon: 'assets/icons/tag-user.png',
                            items: controller.breedList.isNotEmpty
                                ? controller.breedList
                                    .map((breed) => breed.name)
                                    .toList()
                                : [
                                    'No disponible'
                                  ], // Si la lista está vacía, muestra "No disponible"
                          );
                        }),
                      ),
                      // Selector de género
                      Container(
                        margin: EdgeInsets.only(top: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            // Opción Hembra
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  controller.petGender.value = 'Hembra';
                                },
                                child: Obx(
                                  () => Container(
                                    padding: EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: controller.petGender.value ==
                                              'Hembra'
                                          ? Colors.white
                                          : Color.fromRGBO(254, 247, 229, 1),
                                      border: Border.all(
                                        color: controller.petGender.value ==
                                                'Hembra'
                                            ? Styles.iconColorBack
                                            : Colors.transparent,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Hembra',
                                        style: TextStyle(
                                          color: Styles.iconColorBack,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 16), // Espacio entre los cuadros
                            // Opción Macho
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  controller.petGender.value = 'Macho';
                                },
                                child: Obx(
                                  () => Container(
                                    padding: EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: controller.petGender.value ==
                                              'Macho'
                                          ? Colors.white
                                          : Color.fromRGBO(254, 247, 229, 1),
                                      border: Border.all(
                                          color: controller.petGender.value ==
                                                  'Macho'
                                              ? Styles.iconColorBack
                                              : Colors.transparent),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Macho',
                                        style: TextStyle(
                                          color: Styles.iconColorBack,
                                          fontWeight: FontWeight.bold,
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
                        margin: EdgeInsets.only(top: 20),
                        child: CustomTextFormFieldWidget(
                          controller: controller.petWeightController,
                          placeholder: locale.value.weight,
                          isNumeric: true,
                          icon: 'assets/icons/profile.png',
                        ),
                      ),
                      SizedBox(height: 20),
                      // Botón para enviar el formulario
                      ButtonDefaultWidget(
                        title: locale.value.addPet + ' +',
                        callback: () {
                          if (_formKey.currentState!.validate()) {
                            controller.submitForm(
                                _formKey); // Llama al método para enviar el formulario
                          }
                        },
                      ),
                      SizedBox(height: 20),
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
