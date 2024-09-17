import 'package:flutter/material.dart';
import 'package:pawlly/models/training_model.dart';
import 'package:pawlly/styles/styles.dart';

class TrainingPrograms extends StatelessWidget {
  List<TrainingModel> dataDummyTraining = [
    TrainingModel(
      id: 1,
      name: 'Entrenamiento Básico para Cachorros',
      image: 'https://example.com/course1.png', // URL de ejemplo para la imagen
      level: 'Principiante',
      progress: 0.3, // 30% de progreso
    ),
    TrainingModel(
      id: 2,
      name: 'Entrenamiento Intermedio de Comportamiento',
      image: 'https://example.com/course2.png', // URL de ejemplo para la imagen
      level: 'Intermedio',
      progress: 0.7, // 70% de progreso
    ),
    TrainingModel(
      id: 3,
      name: 'Entrenamiento Avanzado de Agilidad para Mascotas',
      image: 'https://example.com/course3.png', // URL de ejemplo para la imagen
      level: 'Avanzado',
      progress: 0.5, // 50% de progreso
    ),
    TrainingModel(
      id: 4,
      name: 'Entrenamiento en Casa: Cómo Educar a tu Mascota',
      image: null, // Sin imagen, usará la imagen predeterminada
      level: 'Principiante',
      progress: 0.8, // 80% de progreso
    ),
    TrainingModel(
      id: 5,
      name: 'Técnicas de Socialización para Perros y Gatos',
      image: 'https://example.com/course5.png', // URL de ejemplo para la imagen
      level: 'Intermedio',
      progress: 0.9, // 90% de progreso
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final double imageWidth = MediaQuery.of(context).size.width * 0.35;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Título de la sección
        Text(
          'Cursos y Programas de Entrenamiento',
          style: TextStyle(
            fontSize: 20,
            color: Styles.primaryColor,
            fontFamily: 'PoetsenOne',
          ),
        ),
        SizedBox(height: 16),

        // Lista de cursos
        Column(
          children: dataDummyTraining.map((trainingModel) {
            return GestureDetector(
              onTap: () {
                // Acción cuando se toca el curso
                print('Nombre del curso: ${trainingModel.name}');
              },
              child: Container(
                margin: EdgeInsets.only(bottom: 16),
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Styles.whiteColor,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Styles.greyTextColor.withOpacity(0.2),
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
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: trainingModel.image != null
                              ? Image.network(
                                  trainingModel.image!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.asset(
                                      'assets/images/default_course.png',
                                      fit: BoxFit.cover,
                                    );
                                  },
                                )
                              : Image.asset(
                                  'assets/images/default_course.png',
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    // Contenido del curso
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Nivel del curso
                          Text(
                            trainingModel.level ?? 'Nivel no especificado',
                            style: TextStyle(
                              fontFamily: 'Lato',
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Styles.iconColorBack,
                            ),
                          ),
                          SizedBox(height: 4),
                          // Título del curso (máximo 3 líneas)
                          Text(
                            trainingModel.name,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: 'Lato',
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Styles.greyTextColor,
                            ),
                          ),
                          SizedBox(height: 8),
                          // Botón "Ver detalles"
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  // Acción para ver detalles
                                  print(
                                      'Ver detalles de: ${trainingModel.name}');
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Styles.primaryColor,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      'Ver detalles',
                                      style: TextStyle(
                                        fontFamily: 'Lato',
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Styles.whiteColor,
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      size: 16,
                                      color: Styles.whiteColor,
                                    ),
                                  ],
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
