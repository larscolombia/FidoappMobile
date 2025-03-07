import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pawlly/components/button_default_widget.dart';
import 'package:pawlly/components/custom_alert_dialog_widget.dart';
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

class PasaporteMascota extends StatelessWidget {
  PasaporteMascota({super.key});
  final HistorialClinicoController historiaClinicaController =
      Get.put(HistorialClinicoController());
  final HomeController _homeController = Get.find<HomeController>();
  final PetControllerv2 petController = Get.put(PetControllerv2());

  @override
  Widget build(BuildContext context) {
    var pet = _homeController.selectedProfile.value!;
    var ancho = MediaQuery.of(context).size.width;
    var altoInput = 107.0;
    var peso = pet.weight.toString().obs;
    final TextEditingController dateController = TextEditingController();

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
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      'Verifica la información',
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Lato',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
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
                            Get.off(VerPasaporteMascota());
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
                        child: InputText(
                          placeholder: '',
                          label: 'Especie',
                          initialValue: pet.pettype ?? "",
                          onChanged: (value) => pet.pettype = value,
                        ),
                      ),
                      SizedBox(
                        width: ancho,
                        height: altoInput,
                        child: InputText(
                          label: 'Sexo',
                          initialValue:
                              pet.gender == 'female' ? 'Mujer' : 'Hombre',
                          placeholder: '',
                          onChanged: (value) => pet.gender = value,
                        ),
                      ),
                      SizedBox(
                        width: ancho,
                        height: altoInput,
                        child: InputText(
                          label: 'Raza',
                          placeholder: '',
                          initialValue: pet.breed ?? "",
                          onChanged: (value) => pet.petFur = value,
                        ),
                      ),
                      SizedBox(
                        width: ancho,
                        height: altoInput,
                        child: InputText(
                          isDateField: true,
                          label: 'Fecha de nacimiento',
                          placeholder: '',
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
                          label: 'Edad',
                          placeholder: '',
                          initialValue: pet.age ?? "",
                          onChanged: (value) => pet.age = value,
                        ),
                      ),
                      SizedBox(
                        width: ancho,
                        height: altoInput,
                        child: InputText(
                            label: 'Altura',
                            placeholder: "Altura",
                            initialValue: pet.height.toString(),
                            onChanged: (value) => pet.height = value),
                      ),
                      SizedBox(
                        width: ancho,
                        height: altoInput,
                        child: InputText(
                          label: 'Unidad de la Altura',
                          placeholder: "m/cm",
                          initialValue: pet.heightUnit.toString(),
                          onChanged: (value) {
                            pet.heightUnit = value;
                          },
                        ),
                      ),
                      SizedBox(
                        width: ancho,
                        height: altoInput,
                        child: InputText(
                          label: 'Peso',
                          placeholder: "Peso",
                          initialValue:
                              pet.weight.toString() ?? "no lo ha colocado aún",
                          onChanged: (value) {
                            pet.weight = double.parse(value);
                          },
                        ),
                      ),
                      SizedBox(
                        width: ancho,
                        height: altoInput,
                        child: InputText(
                          label: 'Unidad de Peso',
                          placeholder: "Peso",
                          initialValue: pet.weightUnit.toString() ?? "",
                          onChanged: (value) {
                            pet.weightUnit = value;
                          },
                        ),
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
                                Get.off(VerPasaporteMascota());
                              },
                            );
                          }
                          return ButtonDefaultWidget(
                            title: petController.isLoading.value
                                ? 'Actualizando ...'
                                : 'Actualizar +',
                            callback: () {
                              // Verifica si pet.dateOfBirth no es nulo o vacío
                              print('objeto actulizado ${jsonEncode(pet)}');
                              // Actualizar los datos de la mascota
                              petController.updatePet(
                                pet.id,
                                {
                                  "name": pet.name,
                                  "additional_info": pet.description,
                                  "date_of_birth": pet.dateOfBirth,
                                  "breed_name": pet.breed,
                                  //"gender": pet.gender,
                                  "weight": pet.weight,
                                  "weight_unit": pet.weightUnit,
                                  "height_unit": pet.heightUnit,
                                  "height": num.parse(pet.size ?? "0"),
                                  "user_id": pet.userId,
                                  "age": "${pet.age}",
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
          ),
        ],
      ),
    );
  }
}
