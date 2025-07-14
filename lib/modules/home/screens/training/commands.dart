import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pawlly/modules/home/controllers/home_controller.dart';
import 'package:pawlly/modules/home/screens/pages/utilities.dart';
import 'package:pawlly/modules/home/screens/training/crear_comando.dart';
import 'package:pawlly/modules/integracion/controller/comandos/comandos_controller.dart';
import 'package:pawlly/styles/styles.dart';

class Commands extends StatefulWidget {
  Commands({super.key});

  @override
  _CommandsState createState() => _CommandsState();
}

class _CommandsState extends State<Commands> {
  final ComandoController controller = Get.put(ComandoController());
  final HomeController homeController = Get.put(HomeController());

  @override
  void initState() {
    super.initState();
    // Llamada a la API para cargar los comandos cuando se selecciona un perfil.
    homeController.selectedProfile.listen((selectedProfile) {
      if (selectedProfile != null && !controller.isLoading.value) {
        controller.fetchComandos(selectedProfile.id.toString());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Mostrar indicador de carga si los comandos están cargándose
      if (controller.isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: const Text(
                  'Comandos de Entrenamiento',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: TextStyle(
                    fontSize: 20,
                    color: Styles.primaryColor,
                    fontFamily: 'PoetsenOne',
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              const SizedBox(width: 10),
              FloatingActionButton(
                elevation: 0,
                onPressed: () {
                  Get.to(() => CrearComando());
                },
                clipBehavior: Clip.antiAlias,
                backgroundColor: Styles.primaryColor,
                shape: const CircleBorder(),
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Habilitar desplazamiento en la tabla
          Container(
            height: 166,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: const Color.fromRGBO(255, 218, 174, 1),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal, // Desplazamiento horizontal
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical, // Desplazamiento vertical
                  child: DataTable(
                    headingRowColor: MaterialStateProperty.all(
                      const Color.fromRGBO(254, 247, 229, 1),
                    ),
                    headingTextStyle: const TextStyle(
                      fontFamily: 'Lato',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(56, 56, 56, 1),
                    ),
                    dividerThickness: 1,
                    dataRowColor: MaterialStateProperty.all(
                      const Color.fromRGBO(255, 255, 255, 1),
                    ),
                    border: const TableBorder(
                      verticalInside: BorderSide(
                        color: Color.fromRGBO(255, 218, 174, 1),
                        width: 1,
                      ),
                      horizontalInside: BorderSide(
                        color: Color.fromRGBO(255, 218, 174, 1),
                        width: 1,
                      ),
                      bottom: BorderSide(
                        color: Color.fromRGBO(255, 218, 174, 1),
                        width: 1,
                      ),
                    ),
                    columns: const [
                      DataColumn(label: Text('Nombre')),
                      DataColumn(label: Text('Comando')),
                      DataColumn(label: Text('Acción')),
                      DataColumn(label: Text('Aprendido')),
                      DataColumn(label: Text('Editar')),
                    ],
                    rows: controller.comandoList.map((comando) {
                      return DataRow(
                        cells: [
                          DataCell(Text(comando.name)),
                          DataCell(
                            comando.vozComando.isEmpty
                                ? Row(
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          decoration: const InputDecoration(
                                            hintText: 'Escribe un comando',
                                            border: InputBorder.none,
                                          ),
                                          onChanged: (value) {
                                            comando.vozComando = value;
                                          },
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.edit,
                                          color: Styles.iconColorBack,
                                        ),
                                        onPressed: () {
                                          controller.updateComando(comando);
                                        },
                                      ),
                                    ],
                                  )
                                : Text(comando.vozComando),
                          ),
                          DataCell(Text(comando.description)),
                          DataCell(Text(comando.isFavorite ? 'Sí' : 'No')),
                          DataCell(
                            IconButton(
                              icon: const Icon(
                                Icons.edit,
                                color: Styles.primaryColor,
                                size: 20,
                              ),
                              onPressed: () {
                                controller.editComando(comando);
                              },
                            ),
                          ),
                        ],
                        onSelectChanged: (isSelected) {
                          if (isSelected ?? false) {
                            controller.selectComando(comando);
                          }
                        },
                        selected: controller.selectedComando.value == comando,
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ),

          // Mostrar comando seleccionado
          Obx(() {
            if (controller.selectedComando.value != null) {
              return Center(
                child: Text(
                  'Comando seleccionado: ${controller.selectedComando.value!.name}',
                  style: const TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontSize: 16,
                    fontFamily: 'Lato',
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              );
            } else {
              return const Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(
                  child: Text(
                    'No hay comando seleccionado',
                    style: TextStyle(
                      color: Color(0xFF959595),
                      fontSize: 16,
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }
          }),
          Utilities(),
          const SizedBox(height: 120),
        ],
      );
    });
  }
}
