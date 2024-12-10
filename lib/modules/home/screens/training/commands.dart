import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pawlly/modules/home/controllers/home_controller.dart';
import 'package:pawlly/modules/home/screens/training/crear_comando.dart';
import 'package:pawlly/modules/integracion/controller/comandos/comandos_controller.dart';
import 'package:pawlly/styles/styles.dart';

class Commands extends StatelessWidget {
  Commands({super.key});
  final ComandoController controller = Get.put(ComandoController());
  final HomeController homeController = Get.put(HomeController());
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller
          .fetchComandos(homeController.selectedProfile.value!.id.toString());
    });
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Comandos de Entrenamiento',
                style: TextStyle(
                  fontSize: 20,
                  color: Styles.primaryColor,
                  fontFamily: 'PoetsenOne',
                ),
                textAlign: TextAlign.left,
              ),
              FloatingActionButton(
                onPressed: () {
                  Get.to(() => CrearComando());
                },
                clipBehavior: Clip.antiAlias,
                backgroundColor: Styles.primaryColor,
                shape: CircleBorder(),
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 10),
        Container(
          height: 400,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Color.fromRGBO(255, 255, 255, 1),
            border: Border.all(
              color: Color.fromRGBO(255, 218, 174, 1),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Obx(() {
                  if (controller.comandoList.isEmpty) {
                    return const Center(
                      child: Text('No hay comandos'),
                    );
                  }

                  if (controller.isLoading.value) {
                    return const Center(
                      child: Text('Cargando...'),
                    );
                  }

                  final List<Map<String, String>> dummyData =
                      controller.comandoList.map((comando) {
                    return {
                      "Comando": comando.name,
                      "Acción": comando.description,
                      "Aprendido": comando.isFavorite ? "Sí" : "No",
                      "Comando personalizado": comando.vozComando
                    };
                  }).toList();

                  final List<String> columnHeaders = [
                    "Comando",
                    "Acción",
                    "Aprendido",
                    "Comando personalizado"
                  ];

                  return DataTable(
                    headingRowColor: MaterialStateProperty.all(
                      Color.fromRGBO(254, 247, 229, 1),
                    ),
                    headingTextStyle: TextStyle(
                      fontFamily: 'Lato',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(56, 56, 56, 1),
                    ),
                    dividerThickness: 1,
                    dataRowColor: MaterialStateProperty.all(
                      Color.fromRGBO(255, 255, 255, 1),
                    ),
                    border: TableBorder(
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
                    columns: columnHeaders.map((header) {
                      return DataColumn(
                        label: Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            header,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    }).toList(),
                    rows: dummyData.map((rowData) {
                      return DataRow(
                        cells: rowData.entries.map((entry) {
                          if (entry.key == "Comando personalizado" &&
                              entry.value.isEmpty) {
                            return DataCell(
                              Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      style: TextStyle(
                                        fontFamily: 'Lato',
                                        fontSize: 14,
                                        color: Color.fromRGBO(56, 56, 56, 1),
                                      ),
                                      decoration: InputDecoration(
                                        hintText: 'Escribe un comando',
                                        hintStyle: TextStyle(
                                          fontFamily: 'Lato',
                                          fontSize: 14,
                                          color: Color.fromRGBO(56, 56, 56, 1),
                                        ),
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.edit,
                                        color: Styles.iconColorBack),
                                    onPressed: () {
                                      print('Editando comando personalizado');
                                    },
                                  ),
                                ],
                              ),
                            );
                          } else {
                            return DataCell(
                              Container(
                                width: double.infinity,
                                color: Color.fromRGBO(255, 255, 255, 1),
                                padding: EdgeInsets.all(8),
                                child: Text(
                                  entry.value,
                                  style: TextStyle(
                                    fontFamily: 'Lato',
                                    fontSize: 14,
                                    color: Color.fromRGBO(56, 56, 56, 1),
                                  ),
                                ),
                              ),
                            );
                          }
                        }).toList(),
                        onSelectChanged: (isSelected) {
                          if (isSelected != null && isSelected) {
                            final comando = controller.comandoList.firstWhere(
                                (com) => com.name == rowData["Comando"]);
                            controller.selectComando(comando);
                          }
                        },
                        selected: controller.selectedComando.value?.name ==
                            rowData["Comando"],
                      );
                    }).toList(),
                  );
                }),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Obx(() {
          if (controller.selectedComando.value != null) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                  'Comando seleccionado: ${controller.selectedComando.value!.name}'),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text('No hay comando seleccionado'),
            );
          }
        }),
      ],
    );
  }
}
