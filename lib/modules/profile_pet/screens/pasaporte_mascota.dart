import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pawlly/components/button_default_widget.dart';
import 'package:pawlly/components/custom_alert_dialog_widget.dart';
import 'package:pawlly/modules/components/input_text.dart';
import 'package:pawlly/modules/components/regresr_components.dart';
import 'package:pawlly/modules/components/style.dart';
import 'package:pawlly/modules/home/controllers/home_controller.dart';
import 'package:pawlly/modules/integracion/controller/mascotas/mascotas_controller.dart';
import 'package:pawlly/modules/profile_pet/screens/ver_pasaporte_mascota.dart';

class PasaporteMascota extends StatelessWidget {
  final String? name;
  final String? fechaNacimiento;
  final String? imageUrl;
  final String? raza;
  final String? sexo;
  final String? peso;
  final String? edad;

  PasaporteMascota({
    super.key,
    this.name,
    this.fechaNacimiento,
    this.imageUrl,
    this.raza,
    this.sexo,
    this.peso,
    this.edad,
  });

  final HomeController _homeController = Get.find<HomeController>();
  final PetControllerv2 petController = Get.put(PetControllerv2());

  @override
  Widget build(BuildContext context) {
    var pet = _homeController.selectedProfile.value!;
    var ancho = MediaQuery.of(context).size.width - 100;
    final TextEditingController dateController = TextEditingController();

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
                        fontFamily: 'Lato',
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
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
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  children: [
                    SizedBox(
                      width: ancho,
                      child: BarraBack(
                        callback: () {
                          Get.off(VerPasaporteMascota());
                        },
                        titulo: 'Información del Perro',
                      ),
                    ),
                    SizedBox(
                      width: ancho,
                      child: InputText(
                        placeholder: pet.name,
                        label: 'Nombre',
                        initialValue: pet.name,
                        onChanged: (value) => pet.name = value,
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: ancho,
                      child: InputText(
                        placeholder: pet.pettype,
                        label: 'Especie',
                        initialValue: pet.pettype ?? "no lo ha colocado aún",
                        onChanged: (value) => pet.pettype = value,
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: ancho,
                      child: InputText(
                        label: 'Sexo',
                        initialValue: pet.gender,
                        placeholder: pet.gender,
                        onChanged: (value) => pet.gender = value,
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: ancho,
                      child: InputText(
                        label: 'Raza',
                        placeholder: pet.breed,
                        initialValue: pet.breed ?? "no lo ha colocado aún",
                        onChanged: (value) => pet.petFur = value,
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: ancho,
                      child: InputText(
                        isDateField: true,
                        label: 'Fecha de nacimiento',
                        placeholder: pet.dateOfBirth,
                        onChanged: (value) {
                          pet.dateOfBirth = value;
                          print(
                              'Fecha de nacimiento actualizada: ${pet.dateOfBirth}');
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: ancho,
                      child: InputText(
                        label: 'Color del pelaje',
                        placeholder: pet.petFur,
                        initialValue: pet.petFur ?? "no lo ha colocado aún",
                        onChanged: (value) => pet.petFur = value,
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: ancho,
                      child: InputText(
                        label: 'Edad',
                        placeholder: pet.age,
                        initialValue: pet.age ?? "no lo ha colocado aún",
                        onChanged: (value) => pet.age = value,
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: ancho,
                      child: InputText(
                        label: 'Altura',
                        placeholder: pet.size,
                        initialValue: pet.size ?? "no lo ha colocado aún",
                        onChanged: (value) => pet.size = value,
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: ancho,
                      child: InputText(
                        label: 'Peso',
                        placeholder: pet.weightUnit,
                        initialValue: pet.weightUnit ?? "no lo ha colocado aún",
                        onChanged: (value) => pet.weightUnit = value,
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: ancho,
                      child: InputText(
                        prefiIcon: const Icon(
                          Icons.archive_outlined,
                          color: Styles.fiveColor,
                        ),
                        isFilePicker: true,
                        placeholder: '',
                        label: 'Adjuntar archivo',
                        onChanged: (value) {},
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: ancho,
                      child: InputText(
                        prefiIcon: const Icon(
                          Icons.person_outline,
                          color: Styles.fiveColor,
                        ),
                        isFilePicker: true,
                        label: 'Adjuntar archivo',
                        placeholder: '',
                        onChanged: (value) {},
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: ancho,
                      height: 50,
                      child: Obx(() {
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
                          title: 'Actualizar +',
                          callback: () {
                            try {
                              // Verifica si pet.dateOfBirth no es nulo o vacío

                              // Actualizar los datos de la mascota
                              petController.updatePet(
                                pet.id,
                                {
                                  "name": pet.name,
                                  "additional_info": pet.description,
                                  "date_of_birth": pet.dateOfBirth,
                                  "breed_name": pet.breed,
                                  "gender": pet.gender,
                                  "weight": pet.weight,
                                  "eweightUnit": pet.weightUnit,
                                  "heheightUnit": pet.heightUnit,
                                  "user_id": pet.userId,
                                  "age": "${pet.age}",
                                  "pet_fur": pet.petFur,
                                  "chip": pet.chip,
                                  "size": "${pet.size}",
                                },
                              );

                              // Imprimir metadatos para depuración
                              print('Metadatos: ${json.encode(pet)}');
                            } catch (e) {
                              // Manejo de errores
                              print(
                                  'Error al formatear o actualizar la fecha: $e');
                            }
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
