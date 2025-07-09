import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pawlly/components/button_default_widget.dart';
import 'package:pawlly/modules/components/historia_grid.dart';
import 'package:pawlly/modules/components/input_text.dart';
import 'package:pawlly/modules/components/input_select.dart';
import 'package:pawlly/modules/components/regresr_components.dart';
import 'package:pawlly/modules/components/style.dart';
import 'package:pawlly/modules/helper/helper.dart';
import 'package:pawlly/modules/home/controllers/home_controller.dart';
import 'package:pawlly/modules/integracion/controller/historial_clinico/historial_clinico_controller.dart';
import 'package:pawlly/modules/integracion/controller/mascotas/mascotas_controller.dart';
import 'package:pawlly/modules/profile_pet/screens/form_historial.dart';
import 'package:pawlly/modules/profile_pet/screens/ver_pasaporte_mascota.dart';
import 'package:pawlly/services/auth_service_apis.dart';
import 'package:pawlly/modules/add_pet/controllers/add_pet_controller.dart';


String genderToSpanish(String gender) {
  switch (gender) {
    case 'female':
      return 'Hembra';
    case 'male':
      return 'Macho';
    default:
      return '';
  }
}

String genderToEnglish(String gender) {
  switch (gender) {
    case 'Hembra':
      return 'female';
    case 'Macho':
      return 'male';
    default:
      return '';
  }
}


class PasaporteMascota extends StatelessWidget {
  PasaporteMascota({super.key});
  final HistorialClinicoController historiaClinicaController =
      Get.put(HistorialClinicoController());
  final HomeController _homeController = Get.find<HomeController>();
  final PetControllerv2 petController = Get.put(PetControllerv2());
  final AddPetController addPetController = Get.put(AddPetController());

  @override
  Widget build(BuildContext context) {
    var pet = _homeController.selectedProfile.value!;
    var ancho = MediaQuery.sizeOf(context).width;
    var altoInput = 107.0;
    var peso = pet.weight.toString().obs;
    final TextEditingController dateController = TextEditingController();
    final RxString genderValue = pet.gender.obs;

    var margin = Helper.margenDefault;
    if (pet.dateOfBirth != null) {
      dateController.text = pet.dateOfBirth!;
    }

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
                      'Pasaporte Canino',
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'PoetsenOne',
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      'Verifica la información',
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Lato',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    )
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
                padding: Styles.paddingAll,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Container(
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      SizedBox(
                        width: ancho,
                        child: BarraBack(
                          callback: () {
                            Get.back();
                          },
                          titulo: 'Información del Perro',
                        ),
                      ),
                      SizedBox(height: margin),
                      SizedBox(
                        width: ancho,
                        height: altoInput,
                        child: InputText(
                          placeholder: '',
                          label: 'Nombre',
                          initialValue: pet.name,
                          onChanged: (value) => pet.name = value,
                        ),
                      ),
                      SizedBox(
                        width: ancho,
                        height: altoInput,
                        child: InputSelect(
                          label: 'Especie',
                          value: pet.pettype,
                          TextColor: Colors.black,
                          borderColor: const Color(0xFFFCBA67),
                          onChanged: (value) => pet.pettype = value ?? '',
                          items: const [
                            DropdownMenuItem(
                              value: 'Perro',
                              child: Text('Perro', style: Helper.selectStyle),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: ancho,
                        height: altoInput,
                        child: InputSelect(
                          label: 'Sexo',
                          value: genderToSpanish(pet.gender),
                          TextColor: Colors.black,
                          borderColor: const Color(0xFFFCBA67),
                          onChanged: (value) {
                            genderValue.value = genderToEnglish(value ?? '');
                            pet.gender = genderToEnglish(value ?? '');
                          },
                          items: const [
                            DropdownMenuItem(
                              value: 'Hembra',
                              child: Text('Hembra', style: Helper.selectStyle),
                            ),
                            DropdownMenuItem(
                              value: 'Macho',
                              child: Text('Macho', style: Helper.selectStyle),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: ancho,
                        height: altoInput,
                        child: Obx(() {
                          return InputSelect(
                            key: ValueKey(
                                '${addPetController.breedList.length}-${pet.breed}'),
                            label: 'Raza',
                            value: pet.breed,
                            TextColor: Colors.black,
                            borderColor: const Color(0xFFFCBA67),
                            onChanged: (value) => pet.breed = value ?? '',
                            items: addPetController.breedList
                                .map((breed) => DropdownMenuItem(
                                      value: breed.name,
                                      child: Text(breed.name,
                                          style: Helper.selectStyle),
                                    ))
                                .toList(),
                          );
                        }),
                      ),
                      SizedBox(
                        width: ancho,
                        height: altoInput,
                        child: InputText(
                          isDateField: true,
                          label: 'Fecha de nacimiento',
                          placeholder: '',
                          controller: dateController,
                          onChanged: (value) {
                            pet.dateOfBirth = value;
                            print(
                                'Fecha de nacimiento actualizada: ${pet.dateOfBirth}');
                          },
                        ),
                      ),
                      SizedBox(
                        width: ancho,
                        height: altoInput,
                        child: InputText(
                          label: 'Color del pelaje',
                          placeholder: '',
                          initialValue: pet.petFur ?? "",
                          onChanged: (value) => pet.petFur = value,
                        ),
                      ),
                      SizedBox(
                        width: ancho,
                        height: altoInput,
                        child: InputText(
                            label: 'Altura',
                            placeholder: "Altura",
                            initialValue: pet.height?.toString(),
                            onChanged: (value) => pet.height = value),
                      ),
                      SizedBox(
                        width: ancho,
                        height: altoInput,
                        child: InputSelect(
                          label: 'Unidad de la Altura',
                          value: pet.heightUnit,
                          TextColor: Colors.black,
                          borderColor: const Color(0xFFFCBA67),
                          onChanged: (value) {
                            pet.heightUnit = value ?? '';
                          },
                          items: const [
                            DropdownMenuItem(
                              value: 'cm',
                              child: Text('cm', style: Helper.selectStyle),
                            ),
                            DropdownMenuItem(
                              value: 'm',
                              child: Text('m', style: Helper.selectStyle),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: ancho,
                        height: altoInput,
                        child: InputText(
                          label: 'Peso',
                          placeholder: "Peso",
                          initialValue: pet.weight.toString(),
                          onChanged: (value) {
                            pet.weight = double.tryParse(value) ?? 0;
                          },
                        ),
                      ),
                      SizedBox(
                        width: ancho,
                        height: altoInput,
                        child: InputSelect(
                          label: 'Unidad de Peso',
                          value: pet.weightUnit,
                          TextColor: Colors.black,
                          borderColor: const Color(0xFFFCBA67),
                          onChanged: (value) {
                            pet.weightUnit = value ?? '';
                          },
                          items: const [
                            DropdownMenuItem(
                              value: 'Kg',
                              child: Text('Kg', style: Helper.selectStyle),
                            ),
                            DropdownMenuItem(
                              value: 'Lb',
                              child: Text('Lb', style: Helper.selectStyle),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: ancho,
                        height: altoInput,
                        child: InputText(
                          label: 'Descripción',
                          placeholder: "",
                          initialValue: pet.description,
                          onChanged: (value) {
                            pet.description = value;
                          },
                        ),
                      ),
                      SizedBox(
                        width: ancho,
                        height: altoInput,
                        child: InputText(
                          isFilePicker: true,
                          placeholderSvg: 'assets/icons/svg/imagen2.svg',
                          placeholder: 'Añadir archivo .pdf',
                          label: 'Adjuntar archivo',
                          onChanged: (value) {},
                        ),
                      ),
                      SizedBox(
                        width: ancho,
                        height: altoInput,
                        child: InputText(
                          placeholderSvg: 'assets/icons/svg/imagen2.svg',
                          isFilePicker: true,
                          label: 'Adjuntar archivo',
                          placeholder: 'Añadir archivo .pdf',
                          onChanged: (value) {},
                        ),
                      ),
                      const SizedBox(height: 10),
                      Helper.titulo('Datos de Vacunación y Tratamientos'),
                      SizedBox(height: margin),
                      if (AuthServiceApis.dataCurrentUser.userType != 'user')
                        ButtonDefaultWidget(
                          title: 'Añadir Informe >',
                          callback: () {
                            Get.to(
                              () => FormularioRegistro(),
                            );
                          },
                          defaultColor: Styles.fiveColor,
                        ),
                      SizedBox(height: margin + margin),
                      //pisa papel
                      HistorialGrid(controller: historiaClinicaController),
                      SizedBox(height: margin + margin),
                      SizedBox(
                        width: ancho,
                        child: Obx(() {
                          if (petController.isLoading.value) {
                            return ButtonDefaultWidget(
                              title: 'Actualizando ...',
                              callback: () {},
                            );
                          }
                          if (petController.succesApdate.value) {
                            return ButtonDefaultWidget(
                              title: 'ok',
                              callback: () {
                                petController.succesApdate(false);
                                Get.back();
                              },
                            );
                          }
                          return ButtonDefaultWidget(
                            title: petController.isLoading.value
                                ? 'Actualizando ...'
                                : 'Finalizar',
                            svgIconPath: 'assets/icons/svg/flecha_derecha.svg',
                            svgIconColor: Colors.white,
                            svgIconPathSize: 12,
                            callback: () {
                              // Verifica si pet.dateOfBirth no es nulo o vacío
                              print('objeto actulizado ${jsonEncode(pet)}');
                              
                              // Crear el mapa de datos para actualizar
                              Map<String, dynamic> updateData = {
                                "name": pet.name,
                                "additional_info": pet.description,
                                "breed_name": pet.breed,
                                //"gender": pet.gender,
                                "weight": pet.weight,
                                "weight_unit": pet.weightUnit,
                                "height_unit": pet.heightUnit,
                                "height": num.parse(pet.height ?? "0"),
                                "user_id": pet.userId,
                                // "age": pet.age,
                                "pet_fur": pet.petFur,
                                "chip": pet.chip,
                              };
                              
                              // Solo agregar date_of_birth si no está vacío
                              if (pet.dateOfBirth != null && pet.dateOfBirth!.isNotEmpty) {
                                updateData["date_of_birth"] = pet.dateOfBirth;
                              }
                              
                              // Actualizar los datos de la mascota
                              petController.updatePet(pet.id, updateData);

                              // Imprimir metadatos para depuración
                              print('Metadatos: ${json.encode(pet)}');
                            },
                          );
                        }),
                      ),
                      const SizedBox(height: 20),
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
