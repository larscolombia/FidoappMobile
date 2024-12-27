import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pawlly/components/app_scaffold.dart';
import 'package:pawlly/components/button_default_widget.dart';
import 'package:pawlly/modules/components/input_select.dart';
import 'package:pawlly/modules/components/input_text.dart';
import 'package:pawlly/modules/components/regresr_components.dart';
import 'package:pawlly/modules/components/style.dart';
import 'package:pawlly/modules/home/controllers/home_controller.dart';
import 'package:pawlly/modules/integracion/controller/diario/activida_mascota_controller.dart';

class FormularioDiario extends StatefulWidget {
  final bool isEdit;
  bool? cambio;
  String? ImagenEdit;
  FormularioDiario({
    super.key,
    this.isEdit = false,
    this.cambio = false,
    this.ImagenEdit,
  });

  @override
  _FormularioDiarioState createState() => _FormularioDiarioState();
}

class _FormularioDiarioState extends State<FormularioDiario> {
  String? _imagePath; // Para almacenar la ruta de la imagen seleccionada
  File? __imageFile;
  late final PetActivityController controller;
  final HomeController homeController = Get.put(HomeController());

  @override
  void initState() {
    super.initState();
    if (widget.isEdit) {
      controller = Get.find<PetActivityController>();
      widget.ImagenEdit = controller.activitiesOne.value!.image ?? "";

      controller.updateField('actividadId', controller.activitiesOne.value!.id);
    } else {
      controller = Get.put(PetActivityController());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Contenedor del encabezado
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 200, // Ajusta la altura del encabezado
              color: Styles.colorContainer, // Color del encabezado
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Completa la Información', // Título del encabezado
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'PoetsenOne',
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Añade los datos de este diario', // Título del encabezado
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'PoetsenOne',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),

          // Contenedor inferior con borde redondeado
          Positioned(
            top: 150, // Ajusta esta posición para la superposición
            left: 0,
            right: 0,
            bottom: 0, // Hasta el final de la pantalla
            child: SingleChildScrollView(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white, // Fondo blanco del contenedor inferior
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(
                        30), // Redondear la parte superior izquierda
                    topRight: Radius.circular(
                        30), // Redondear la parte superior derecha
                  ),
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BarraBack(
                      titulo: 'Nuevo Registro',
                      callback: () {
                        Get.back();
                      },
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: Column(
                        children: [
                          InputText(
                            initialValue: widget.isEdit
                                ? (controller.activitiesOne.value!.actividad ??
                                    "")
                                : "",
                            label: 'Título del registro',
                            placeholder: '',
                            onChanged: (value) {
                              controller.updateField('actividad', value);
                              print('Título del registro: $value');
                            },
                          ),
                          const SizedBox(height: 8),
                          Container(
                            width: MediaQuery.of(context).size.width - 90,
                            child: InputSelect(
                              TextColor: Colors.black,
                              label: 'Categoria del registro',
                              placeholder: 'Selecciona una categoría',
                              onChanged: (value) {
                                controller.updateField('category_id', value);
                              },
                              items: const [
                                DropdownMenuItem(
                                  value: '1',
                                  child: Text('Actividad'),
                                ),
                                DropdownMenuItem(
                                  value: '2',
                                  child: Text('Informe médico'),
                                ),
                                DropdownMenuItem(
                                  value: '3',
                                  child: Text('Entrenamiento'),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          InputText(
                            initialValue: widget.isEdit
                                ? controller.activitiesOne.value!.date
                                : '',
                            label: 'Fecha del registro',
                            placeholder: '',
                            isDateField: true,
                            prefiIcon: const Icon(
                              Icons.calendar_today,
                              color: Styles.iconColorBack,
                            ),
                            suffixIcon: const Icon(
                              Icons.arrow_drop_down_sharp,
                              color: Styles.iconColorBack,
                            ),
                            onChanged: (value) {
                              controller.updateField('date', value);
                              print('Fecha del registro: $value');
                            },
                          ),
                          const SizedBox(height: 20),
                          InputText(
                            initialValue: widget.isEdit
                                ? controller.activitiesOne.value!.notas
                                : '',
                            label: 'Descripción',
                            placeholder: 'Describe el evento',
                            onChanged: (value) {
                              controller.updateField('notas', value);
                              print('Descripción del registro: $value');
                            },
                          ),
                          const SizedBox(height: 8),
                          InputText(
                            label: 'Selecciona una Imagen',
                            placeholder: 'Toca para elegir una imagen',
                            isImagePicker:
                                true, // Habilita la selección de imagen
                            onChanged: (value) {
                              setState(() {
                                widget.cambio = false;
                                _imagePath =
                                    value; // Aquí obtienes la ruta de la imagen seleccionada
                                controller.updateField('image', value);
                                __imageFile = File(value);
                              });
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          widget.isEdit == true && widget.cambio == false
                              ? Column(
                                  children: [
                                    const Text("Imagen Actual"),
                                    if (widget.ImagenEdit != null)
                                      Image.network(
                                        controller.activitiesOne.value!.image ??
                                            "", // URL de la imagen editada
                                        width: 300,
                                        height: 220,
                                        fit: BoxFit.cover,
                                        loadingBuilder:
                                            (context, child, loadingProgress) {
                                          if (loadingProgress == null) {
                                            return child; // Si la imagen se carga correctamente
                                          }
                                          return const Center(
                                            child:
                                                CircularProgressIndicator(), // Muestra un indicador de carga
                                          );
                                        },
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Container(
                                            width: 250,
                                            height: 150,
                                            decoration: BoxDecoration(
                                              color: Colors.black,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                color: Colors.grey,
                                                width: .3,
                                              ),
                                            ),
                                            child: const Icon(
                                              Icons.image,
                                              color: Colors.blue,
                                            ),
                                          );
                                        },
                                      ),
                                  ],
                                )
                              : const SizedBox(),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: 302,
                            height: 54,
                            child: Obx(() {
                              return ButtonDefaultWidget(
                                title: widget.isEdit
                                    ? controller.isLoading.value
                                        ? 'Cargando ...'
                                        : 'Editar'
                                    : controller.isLoading.value
                                        ? 'Cargando ...'
                                        : 'Finalizar',
                                callback: () {
                                  if (widget.isEdit) {
                                    print(controller.diario);

                                    controller.editPetActivity2(
                                      "${controller.activitiesOne.value!.id}",
                                      //  __imageFile,
                                    );
                                  } else {
                                    controller.updateField(
                                      'pet_id',
                                      homeController.selectedProfile.value!.id
                                          .toString(),
                                    );
                                    print(controller.diario);
                                    controller.addPetActivity(__imageFile);
                                  }
                                },
                              );
                            }),
                          ),
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
