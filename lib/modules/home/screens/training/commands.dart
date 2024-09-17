import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pawlly/styles/styles.dart';

class Commands extends StatelessWidget {
  const Commands({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> dummyData = [
      {
        "Comando": "Sentarse",
        "Acción": "El perro se sienta",
        "Aprendido": "Sí",
        "Comando personalizado": ""
      },
      {
        "Comando": "Quieto",
        "Acción": "El perro se queda quieto",
        "Aprendido": "No",
        "Comando personalizado": ""
      },
      {
        "Comando": "Buscar",
        "Acción": "El perro trae el objeto",
        "Aprendido": "Sí",
        "Comando personalizado": "Busca pelota"
      },
    ];

    final List<String> columnHeaders = [
      "Comando",
      "Acción",
      "Aprendido",
      "Comando personalizado"
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Título del widget
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
        // Contenedor de la tabla con un tamaño fijo y borde redondeado
        Container(
          height: 400, // Altura fija del container
          width: double.infinity, // Ocupa todo el ancho disponible
          decoration: BoxDecoration(
            color: Color.fromRGBO(255, 255, 255, 1),
            border: Border.all(
              color: Color.fromRGBO(
                  255, 218, 174, 1), // Color del borde de la tabla
              width: 1,
            ),
            borderRadius:
                BorderRadius.circular(8), // Borde redondeado de la tabla
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(
                8), // Aplica el borde redondeado a toda la tabla
            child: SingleChildScrollView(
              scrollDirection:
                  Axis.horizontal, // Scroll horizontal para muchas columnas
              child: SingleChildScrollView(
                scrollDirection:
                    Axis.vertical, // Scroll vertical para muchas filas
                child: DataTable(
                  // Personalización del encabezado con fondo completo
                  headingRowColor: MaterialStateProperty.all(
                    Color.fromRGBO(
                        254, 247, 229, 1), // Fondo completo del encabezado
                  ),
                  headingTextStyle: TextStyle(
                    fontFamily: 'Lato',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(56, 56, 56, 1), // Color del texto
                  ),
                  dividerThickness:
                      1, // Restaurar las líneas horizontales entre filas de datos
                  dataRowColor: MaterialStateProperty.all(
                    Color.fromRGBO(
                        255, 255, 255, 1), // Fondo completo de las filas
                  ),
                  border: TableBorder(
                    verticalInside: BorderSide(
                      color: Color.fromRGBO(255, 218, 174,
                          1), // Color de las líneas divisorias verticales
                      width: 1,
                    ),
                    horizontalInside: BorderSide(
                      color: Color.fromRGBO(
                          255, 218, 174, 1), // Color de las líneas horizontales
                      width: 1,
                    ),
                    bottom: BorderSide(
                      color: Color.fromRGBO(
                          255, 218, 174, 1), // Línea inferior al último dato
                      width: 1,
                    ),
                  ),
                  columns: columnHeaders.map((header) {
                    return DataColumn(
                      label: Container(
                        alignment:
                            Alignment.center, // Alinear el texto al centro
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          header,
                          textAlign:
                              TextAlign.center, // Títulos alineados al centro
                        ),
                      ),
                    );
                  }).toList(),
                  rows: dummyData.map((rowData) {
                    return DataRow(
                      cells: rowData.entries.map((entry) {
                        // Si la columna es "Comando personalizado" y está vacía, mostrar input e ícono de editar
                        if (entry.key == "Comando personalizado" &&
                            entry.value.isEmpty) {
                          return DataCell(
                            Row(
                              children: [
                                // Campo de entrada para el comando personalizado vacío
                                Expanded(
                                  child: TextFormField(
                                    style: TextStyle(
                                      fontFamily: 'Lato',
                                      fontSize: 14,
                                      color: Color.fromRGBO(
                                          56, 56, 56, 1), // Texto del input
                                    ),
                                    decoration: InputDecoration(
                                      hintText: 'Escribe un comando',
                                      hintStyle: TextStyle(
                                        fontFamily: 'Lato',
                                        fontSize: 14,
                                        color: Color.fromRGBO(56, 56, 56,
                                            1), // Color del texto del input
                                      ),
                                      border: InputBorder
                                          .none, // Sin borde para el input
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.edit,
                                      color: Styles.iconColorBack),
                                  onPressed: () {
                                    // Acción al presionar el ícono de editar
                                    print('Editando comando personalizado');
                                  },
                                ),
                              ],
                            ),
                          );
                        } else {
                          // Mostrar el valor del campo normalmente
                          return DataCell(
                            Container(
                              width: double
                                  .infinity, // Asegura que el fondo cubra todo el ancho de la celda
                              color: Color.fromRGBO(255, 255, 255,
                                  1), // Fondo completo de la celda
                              padding: EdgeInsets.all(8), // Espaciado interno
                              child: Text(
                                entry.value,
                                style: TextStyle(
                                  fontFamily: 'Lato',
                                  fontSize: 14,
                                  color: Color.fromRGBO(
                                      56, 56, 56, 1), // Color del texto
                                ),
                              ),
                            ),
                          );
                        }
                      }).toList(),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
