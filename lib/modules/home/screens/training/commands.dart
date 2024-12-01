import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pawlly/modules/integracion/controller/comandos/comandos_controller.dart';
import 'package:pawlly/styles/styles.dart';

class Commands extends StatelessWidget {
  Commands({super.key});
  final ComandoController controller = Get.put(ComandoController());

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Comandos de Entrenamiento',
          style: TextStyle(
            fontSize: 20,
            color: Styles.primaryColor,
            fontFamily: 'PoetsenOne',
          ),
          textAlign: TextAlign.left,
        ),
        SizedBox(height: 10),
        // Container to hold the DataTable
        Container(
          height: 400, // Fixed height for the container
          width: double.infinity, // Occupies full width available
          decoration: BoxDecoration(
            color: Color.fromRGBO(255, 255, 255, 1),
            border: Border.all(
              color: Color.fromRGBO(255, 218, 174, 1), // Border color
              width: 1,
            ),
            borderRadius: BorderRadius.circular(8), // Rounded border
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8), // Rounded border
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal, // Horizontal scroll
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical, // Vertical scroll
                child: Obx(() {
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
                      Color.fromRGBO(
                          254, 247, 229, 1), // Full background color for header
                    ),
                    headingTextStyle: TextStyle(
                      fontFamily: 'Lato',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(56, 56, 56, 1), // Text color
                    ),
                    dividerThickness:
                        1, // Horizontal line thickness between data rows
                    dataRowColor: MaterialStateProperty.all(
                      Color.fromRGBO(
                          255, 255, 255, 1), // Full background color for rows
                    ),
                    border: TableBorder(
                      verticalInside: BorderSide(
                        color: Color.fromRGBO(255, 218, 174,
                            1), // Color for vertical divider lines
                        width: 1,
                      ),
                      horizontalInside: BorderSide(
                        color: Color.fromRGBO(255, 218, 174,
                            1), // Color for horizontal divider lines
                        width: 1,
                      ),
                      bottom: BorderSide(
                        color: Color.fromRGBO(
                            255, 218, 174, 1), // Bottom line color
                        width: 1,
                      ),
                    ),
                    columns: columnHeaders.map((header) {
                      return DataColumn(
                        label: Container(
                          alignment: Alignment.center, // Center text alignment
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            header,
                            textAlign:
                                TextAlign.center, // Center aligned headers
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
                                  // Input field for empty custom command
                                  Expanded(
                                    child: TextFormField(
                                      style: TextStyle(
                                        fontFamily: 'Lato',
                                        fontSize: 14,
                                        color: Color.fromRGBO(
                                            56, 56, 56, 1), // Input text color
                                      ),
                                      decoration: InputDecoration(
                                        hintText: 'Escribe un comando',
                                        hintStyle: TextStyle(
                                          fontFamily: 'Lato',
                                          fontSize: 14,
                                          color: Color.fromRGBO(56, 56, 56,
                                              1), // Input hint text color
                                        ),
                                        border: InputBorder
                                            .none, // No border for input
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.edit,
                                        color: Styles.iconColorBack),
                                    onPressed: () {
                                      // Action on edit icon press
                                      print('Editando comando personalizado');
                                    },
                                  ),
                                ],
                              ),
                            );
                          } else {
                            // Display cell value normally
                            return DataCell(
                              Container(
                                width: double
                                    .infinity, // Ensure background covers full cell width
                                color: Color.fromRGBO(255, 255, 255,
                                    1), // Full cell background color
                                padding: EdgeInsets.all(8), // Internal padding
                                child: Text(
                                  entry.value,
                                  style: TextStyle(
                                    fontFamily: 'Lato',
                                    fontSize: 14,
                                    color: Color.fromRGBO(
                                        56, 56, 56, 1), // Text color
                                  ),
                                ),
                              ),
                            );
                          }
                        }).toList(),
                      );
                    }).toList(),
                  );
                }),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
