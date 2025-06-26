import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pawlly/components/button_default_widget.dart';
import 'package:pawlly/components/custom_select_form_field_widget.dart';
import 'package:pawlly/models/pet_list_res_model.dart';
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

class PasaporteMascota extends StatefulWidget {
  const PasaporteMascota({super.key});

  @override
  State<PasaporteMascota> createState() => _PasaporteMascotaState();
}

class _PasaporteMascotaState extends State<PasaporteMascota> {
  final _historiaClinicaController = Get.put(HistorialClinicoController());
  final _homeController = Get.find<HomeController>();
  final _petController = Get.put(PetControllerv2());

  // name
  // especie
  final sexTextController = TextEditingController(); // sexo
  final petBreedTextController = TextEditingController(); // raza
  // fecha de nacimiento
  // color de pelaje
  // Altura
  final heightUnitTextController = TextEditingController(); // unidad de altura


  final weightUnitTextController = TextEditingController();

  late final PetData pet;

  @override
  void initState() {
    super.initState();
    // Cargar la mascota seleccionada al iniciar

    pet = _homeController.selectedProfile.value!;

    sexTextController.text = pet.gender == 'female' ? 'Hembra' : 'Macho';
    petBreedTextController.text = pet.breed;
    heightUnitTextController.text = pet.heightUnit.isNotEmpty ? pet.heightUnit : 'cm';
    weightUnitTextController.text = pet.weightUnit.isNotEmpty ? pet.weightUnit : 'Kg';
  }

  @override
  void dispose() {
    // Limpiar los controladores al cerrar la pantalla
    sexTextController.dispose();
    petBreedTextController.dispose();
    heightUnitTextController.dispose();
    weightUnitTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var ancho = MediaQuery.sizeOf(context).width;
    var altoInput = 107.0;
    var margin = Helper.margenDefault;

    // var pet = _homeController.selectedProfile.value!;

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
                    CustomSelectFormFieldWidget(
                      controller: sexTextController,
                      placeholder: '',
                      label: 'Sexo',
                      filcolorCustom: Styles.colorContainer,
                      borderColor: Styles.colorContainer,
                      items: const ['Hembra', 'Macho'],
                      onChange: (value) {
                        pet.gender = value == 'Hembra'
                          ? 'female'
                          : 'male';
                      }
                    ),
                    SizedBox(height: margin),
                    
                    // Raza
                    Obx(() {
                      return CustomSelectFormFieldWidget(
                        controller: petBreedTextController,
                        placeholder: '',
                        label: 'Raza',
                        // icon: 'assets/icons/patica.png',
                        filcolorCustom: Styles.colorContainer,
                        borderColor: Styles.colorContainer,
                        items: _petController.breedList.isEmpty ? ['No disponible'] : _petController.breedList.map((breed) => breed.name).toList(),
                        onChange: (value) => pet.breed = value ?? '',
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
                        initialValue: pet.dateOfBirth ?? "",
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
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                          signed: false,
                        ),
                        onChanged: (value) {
                          if (value.isEmpty) {
                            pet.height = 0;
                          } else {
                            double parsedValue = double.parse(value);
                            
                            // Si tiene decimales, redondear a 2 decimales
                            if (parsedValue % 1 != 0) {
                              // Redondear a 2 decimales
                              pet.height = double.parse(parsedValue.toStringAsFixed(2));
                            } else {
                              pet.height = parsedValue.toInt();
                            }
                          }
                        }
                      ),
                    ),
                    
                    // Unidad de altura
                    CustomSelectFormFieldWidget(
                      controller: heightUnitTextController,
                      placeholder: '',
                      label: 'Unidad de la Altura',
                      filcolorCustom: Styles.colorContainer,
                      borderColor: Styles.colorContainer,
                      items: const ['cm', 'in'],
                      onChange: (value) {
                        pet.heightUnit = value ?? '';
                      }
                    ),
                    
                    // Peso
                    SizedBox(
                      width: ancho,
                      height: altoInput,
                      child: InputText(
                        label: 'Peso',
                        placeholder: "",
                        initialValue: pet.weight.toString(),
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                          signed: false,
                        ),
                        onChanged: (value) {
                          if (value.isEmpty) {
                            pet.weight = 0;
                          } else {
                            double parsedValue = double.parse(value);
                            
                            // Si tiene decimales, redondear a 2 decimales
                            if (parsedValue % 1 != 0) {
                              // Redondear a 2 decimales
                              pet.weight = double.parse(parsedValue.toStringAsFixed(2));
                            }
                            pet.weight = parsedValue.toInt();
                          }
                        }
                      ),
                    ),
                    
                    // Selector de unidad de peso
                    CustomSelectFormFieldWidget(
                      controller: weightUnitTextController,
                      placeholder: '',
                      label: 'Unidad de Peso',
                      filcolorCustom: Styles.colorContainer,
                      borderColor: Styles.colorContainer,
                      items: const ['Kg', 'Lb'],
                      onChange: (value) {
                        pet.weightUnit = value ?? 'Kg';
                      }
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
                    
                    // Pisa papel
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

                        // Este código no tiene efecto, la variable nunca es true
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
                            final body = pet.mapToUpdate();
                            print('objeto actulizado ${jsonEncode(pet)}');
                            // Actualizar los datos de la mascota

                            _petController.updatePet(
                              pet.id,
                              body
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
