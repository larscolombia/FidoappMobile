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
  @override
  _FormularioDiarioState createState() => _FormularioDiarioState();
}

class _FormularioDiarioState extends State<FormularioDiario> {
  String _imagePath = ""; // Para almacenar la ruta de la imagen seleccionada
  final PetActivityController controller = Get.put(PetActivityController());
  // Función para seleccionar la imagen
  final HomeController homeController = Get.put(HomeController());
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
                        fontFamily: 'Lato',
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Añade los datos de este diario', // Título del encabezado
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

          // Contenedor inferior con borde redondeado
          Positioned(
            top: 150, // Ajusta esta posición para la superposición
            left: 0,
            right: 0,
            bottom: 0, // Hasta el final de la pantalla
            child: SingleChildScrollView(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white, // Fondo blanco del contenedor inferior
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(
                        30), // Redondear la parte superior izquierda
                    topRight: Radius.circular(
                        30), // Redondear la parte superior derecha
                  ),
                ),
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BarraBack(
                      titulo: 'Nuevo Registro',
                      callback: () {
                        Get.back();
                        print('Regresar al Diario de Mascotas');
                      },
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: Column(
                        children: [
                          InputText(
                            label: 'Título del registro',
                            placeholder: '',
                            onChanged: (value) {
                              controller.updateField('actividad', value);
                              print('Título del registro: $value');
                            },
                          ),
                          const SizedBox(height: 8),
                          InputSelect(
                            TextColor: Colors.black,
                            label: 'Categoria del registro',
                            placeholder: 'Selecciona una categoría',
                            onChanged: (value) {
                              controller.updateField('category_id', value);
                              print('Categoría del registro: $value');
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
                          const SizedBox(height: 8),
                          InputText(
                            label: 'Fecha del registro',
                            placeholder: '',
                            isDateField: true,
                            prefiIcon: Icon(
                              Icons.calendar_today,
                              color: Styles.iconColorBack,
                            ),
                            suffixIcon: Icon(
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
                              label: 'Descripción',
                              placeholder: 'Describe el evento',
                              onChanged: (value) {
                                controller.updateField('notas', value);
                                print('Descripción del registro: $value');
                              }),
                          const SizedBox(height: 8),
                          InputText(
                            label: 'Selecciona una Imagen',
                            placeholder: 'Toca para elegir una imagen',
                            isImagePicker:
                                true, // Habilita la selección de imagen
                            onChanged: (value) {
                              setState(() {
                                _imagePath =
                                    value; // Aquí obtienes la ruta de la imagen seleccionada
                              });
                              controller.updateField('image', value);
                            },
                          ),
                          if (_imagePath.isNotEmpty)
                            Column(
                              children: [
                                Text("Imagen seleccionada:"),
                                Image.file(
                                  File(
                                      _imagePath), // Muestra la imagen seleccionada
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              ],
                            ),
                          SizedBox(height: 20),
                          Container(
                            width: 302,
                            height: 54,
                            child: Obx(() {
                              if (controller.isLoading.value) {
                                return ButtonDefaultWidget(
                                  title: 'Guardando...',
                                  callback: () {},
                                );
                              }

                              return ButtonDefaultWidget(
                                  title: 'Finalizar',
                                  callback: () {
                                    controller.updateField(
                                        'pet_id',
                                        homeController
                                            .selectedProfile.value!.id);
                                    print(controller.diario);
                                    controller.addPetActivity();
                                  });
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
