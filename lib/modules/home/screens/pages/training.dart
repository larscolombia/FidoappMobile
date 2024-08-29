import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pawlly/styles/styles.dart';

class Training extends StatelessWidget {
  const Training({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final double imageWidth = width * 0.5;

    // Datos de ejemplo para los cursos con ID
    final List<Map<String, dynamic>> courses = [
      {
        'id': 1,
        'image': 'https://via.placeholder.com/150',
        'level': 'Principiante',
        'title': 'Curso de Adiestramiento Básico para Perros',
        'progress': 0.6, // 60% completado
      },
      {
        'id': 2,
        'image': null, // Imagen faltante, se usará la predeterminada
        'level': 'Intermedio',
        'title': 'Entrenamiento Avanzado de Obediencia',
        'progress': 0.8, // 80% completado
      },
      {
        'id': 3,
        'image': 'https://via.placeholder.com/150',
        'level': 'Experto',
        'title': 'Entrenamiento de Agilidad Canina',
        'progress': 0.3, // 30% completado
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Entrenamientos',
          style: TextStyle(
            fontSize: 20,
            color: Styles.primaryColor,
            fontFamily: 'PoetsenOne',
          ),
          textAlign: TextAlign.left,
        ),
        SizedBox(height: 10),
        // Lista de cursos
        Column(
          children: courses.map((course) {
            return GestureDetector(
              onTap: () {
                // Imprime el nombre y el ID del contenedor cuando se toca
                print(
                    'Nombre del container: ${course['title']} - ID: ${course['id']}');
              },
              child: Container(
                margin: EdgeInsets.only(bottom: 16),
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Styles.whiteColor,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Styles.greyTextColor
                        .withOpacity(0.5), // Borde con opacidad
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    // Imagen del curso
                    Flexible(
                      flex: 1,
                      child: Container(
                        width: imageWidth,
                        height: 100, // Alto predeterminado
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: course['image'] != null
                              ? Image.network(
                                  course['image'],
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.asset(
                                      'assets/images/petcare_1.png',
                                      fit: BoxFit.cover,
                                    );
                                  },
                                )
                              : Image.asset(
                                  'assets/images/petcare_1.png',
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12), // Espacio entre imagen y contenido
                    // Contenido del curso
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            course['level'],
                            style: TextStyle(
                              fontFamily: 'Lato',
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Styles.iconColorBack,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            course['title'],
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: 'Lato',
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Styles.greyTextColor,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Progreso:',
                            style: TextStyle(
                              fontFamily: 'Lato',
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Styles.iconColorBack,
                            ),
                          ),
                          SizedBox(height: 4),
                          // Barra de progreso y porcentaje
                          Row(
                            children: [
                              Expanded(
                                child: LinearProgressIndicator(
                                  value: course['progress'],
                                  backgroundColor:
                                      Styles.greyTextColor.withOpacity(0.2),
                                  color: Styles.iconColorBack,
                                  minHeight: 6,
                                ),
                              ),
                              SizedBox(width: 8),
                              Text(
                                '${(course['progress'] * 100).toInt()}%',
                                style: TextStyle(
                                  fontFamily: 'Lato',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: Styles.iconColorBack,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
