import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pawlly/components/button_default_widget.dart';
import 'package:pawlly/components/custom_select_form_field_widget.dart';
import 'package:pawlly/modules/components/historia_grid.dart';
import 'package:pawlly/modules/components/input_text.dart';
import 'package:pawlly/modules/components/regresr_components.dart';
import 'package:pawlly/modules/components/style.dart';
import 'package:pawlly/modules/helper/helper.dart';
import 'package:pawlly/modules/home/controllers/home_controller.dart';
import 'package:pawlly/modules/integracion/controller/historial_clinico/historial_clinico_controller.dart';
import 'package:pawlly/modules/integracion/controller/mascotas/mascotas_controller.dart';
import 'package:pawlly/modules/profile_pet/screens/form_historial.dart';
import 'package:pawlly/modules/profile_pet/screens/ver_pasaporte_mascota.dart';
import 'package:pawlly/services/auth_service_apis.dart';

class PasaporteMascota extends StatelessWidget {
  PasaporteMascota({super.key});
  final _homeController = Get.find<HomeController>();
  final _historiaClinicaController = Get.put(HistorialClinicoController());
  final _petController = Get.put(PetControllerv2());

  @override
  Widget build(BuildContext context) {
    var ancho = MediaQuery.sizeOf(context).width;
    var altoInput = 107.0;
    var margin = Helper.margenDefault;

    final dateController = TextEditingController();
    final heightUnitController = TextEditingController();
    final petBreedController = TextEditingController();
    final sexController = TextEditingController();
    final weightUnitController = TextEditingController();

    var pet = _homeController.selectedProfile.value!;

    if (pet.dateOfBirth != null) {
      dateController.text = pet.dateOfBirth!;
    }

    return Scaffold(
      body: Stack(
        children: [
          // Header
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
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    // Barra de navegación hacia atrás
                    SizedBox(
                      width: ancho,
                      child: BarraBack(
                        callback: () {
                          Get.off(VerPasaporteMascota());
                        },
                        titulo: 'Información del Perro',
                      ),
                    ),
                    SizedBox(height: margin),
                    // Nombre de la mascota
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
                    // Especie
                    SizedBox(
                      width: ancho,
                      height: altoInput,
                      child: InputText(
                        placeholder: '',
                        label: 'Especie',
                        initialValue: pet.pettype,
                        readOnly: true,
                        onChanged: (_) {},
                      ),
                    ),
                    // Sexo
                    Obx(() {
                      return CustomSelectFormFieldWidget(
                        controller: sexController,
                        placeholder: '',
                        label: 'Sexo',
                        // icon: 'assets/icons/patica.png',
                        filcolorCustom: Styles.colorContainer,
                        borderColor: Styles.colorContainer,
                        items: const ['Hembra', 'Macho'],
                        onChange: (value) {
                          pet.gender = value == 'Hembra'
                            ? 'female'
                            : 'male';
                        }
                      );
                    }),
                    SizedBox(height: margin),
                    // Raza
                    Obx(() {
                      return CustomSelectFormFieldWidget(
                        controller: petBreedController,
                        placeholder: '',
                        label: 'Raza',
                        // icon: 'assets/icons/patica.png',
                        filcolorCustom: Styles.colorContainer,
                        borderColor: Styles.colorContainer,
                        items: _petController.breedList.isEmpty ? ['No disponible'] : _petController.breedList.map((breed) => breed.name).toList(),
                        onChange: (value) => pet.petFur = value,
                      );
                    }),
                    const SizedBox(height: 5),
                    // Fecha de nacimiento
                    SizedBox(
                      width: ancho,
                      height: altoInput,
                      child: InputText(
                        isDateField: true,
                        label: 'Fecha de nacimiento',
                        placeholder: '',
                        borderColor: Styles.colorContainer,
                        onChanged: (value) {
                          pet.dateOfBirth = value;
                          print('Fecha de nacimiento actualizada: ${pet.dateOfBirth}');
                        },
                      ),
                    ),
                    // Color de pelaje
                    SizedBox(
                      width: ancho,
                      height: altoInput,
                      child: InputText(
                        label: 'Color del pelaje',
                        placeholder: '',
                        initialValue: pet.petFur ?? "",
                        onChanged: (value) => pet.petFur = value,
                        keyboardType: TextInputType.text,
                      ),
                    ),
                    // Altura
                    SizedBox(
                      width: ancho,
                      height: altoInput,
                      child: InputText(
                        label: 'Altura',
                        placeholder: "",
                        initialValue: pet.height.toString(),
                        onChanged: (value) => pet.height = value.isEmpty ? 0 : num.parse(value),
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                          signed: false,
                        ),
                      ),
                    ),
                    // Unidad de altura
                    CustomSelectFormFieldWidget(
                      controller: heightUnitController,
                      placeholder: '',
                      label: 'Unidad de la Altura',
                      filcolorCustom: Styles.colorContainer,
                      borderColor: Styles.colorContainer,
                      items: const ['m', 'cm', 'in'],
                      onChange: (value) => pet.weightUnit = value ?? 'Kg',
                    ),
                    // Peso
                    SizedBox(
                      width: ancho,
                      height: altoInput,
                      child: InputText(
                        label: 'Peso',
                        placeholder: "",
                        initialValue: pet.weight,
                        onChanged: (value) => pet.weight = double.parse(value),
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                          signed: false,
                        )
                      ),
                    ),
                    // Selector de unidad de peso
                    CustomSelectFormFieldWidget(
                      controller: weightUnitController,
                      placeholder: '',
                      label: 'Unidad de Peso',
                      filcolorCustom: Styles.colorContainer,
                      borderColor: Styles.colorContainer,
                      items: const ['Kg', 'Lb'],
                      onChange: (value) => pet.weightUnit = value ?? 'Kg',
                    ),
                    SizedBox(
                      width: ancho,
                      height: altoInput,
                      child: InputText(
                        label: 'Tamaño',
                        placeholder: "",
                        initialValue: pet.size.toString(),
                        onChanged: (value) {
                          pet.size = value;
                        },
                      ),
                    ),
                    // Descripción
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
                    const SizedBox(height: 10),
                    
                    Helper.titulo('Datos de Vacunación y Tratamientos'),
                    SizedBox(height: margin),
                    // Añadir informe
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
                    HistorialGrid(controller: _historiaClinicaController),
                    SizedBox(height: margin + margin),
                    // Botón para finalizar
                    SizedBox(
                      width: ancho,
                      child: Obx(() {
                        if (_petController.isLoading.value) {
                          return ButtonDefaultWidget(
                            title: 'Actualizando ...',
                            callback: () {},
                          );
                        }

                        if (_petController.succesApdate.value) {
                          return ButtonDefaultWidget(
                            title: 'ok',
                            callback: () {
                              _petController.succesApdate(false);
                              Get.off(VerPasaporteMascota());
                            },
                          );
                        }

                        return ButtonDefaultWidget(
                          title: _petController.isLoading.value
                              ? 'Actualizando ...'
                              : 'Finalizar',
                          svgIconPath: 'assets/icons/svg/flecha_derecha.svg',
                          svgIconColor: Colors.white,
                          svgIconPathSize: 12,
                          callback: () {
                            // Verifica si pet.dateOfBirth no es nulo o vacío
                            print('objeto actulizado ${jsonEncode(pet)}');
                            // Actualizar los datos de la mascota

                            _petController.updatePet(
                              pet.id,
                              {
                                "name": pet.name,
                                "additional_info": pet.description,
                                "date_of_birth": pet.dateOfBirth,
                                "breed_name": pet.breed,
                                "gender": pet.gender,
                                "weight": pet.weight,
                                "weight_unit": pet.weightUnit,
                                "height_unit": pet.heightUnit,
                                "height": num.parse(pet.size ?? "0"),
                                "user_id": pet.userId,
                                "age": pet.age,
                                "pet_fur": pet.petFur,
                                "chip": pet.chip,
                                "size": "${pet.size}",
                              },
                            );

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
        ],
      ),
    );
  }
}
