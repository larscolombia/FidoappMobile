import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pawlly/models/training_model.dart';
import 'package:pawlly/modules/home/controllers/home_controller.dart';
import 'package:pawlly/styles/styles.dart';

class Training extends StatelessWidget {
  Training({super.key});

  // Instancia del controlador para manejar el estado
  final HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final double imageWidth = width * 0.5;

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
        // Lista de entrenamientos
        Obx(() {
          if (controller.training.isEmpty) {
            return Center(
              child: Text(
                'No hay entrenamientos disponibles',
                style: TextStyle(fontSize: 16, color: Styles.greyTextColor),
              ),
            );
          }
          return Column(
            children: controller.training.map((trainingModel) {
              // Asegúrate de que `trainingModel` sea del tipo `TrainingModel`
              return GestureDetector(
                onTap: () {
                  // Imprime el nombre y el ID del entrenamiento cuando se toca
                  print(
                      'Nombre del container: ${trainingModel.name} - ID: ${trainingModel.id}');
                },
                child: Container(
                  margin: EdgeInsets.only(bottom: 16),
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Styles.whiteColor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Styles.greyTextColor
                          .withOpacity(0.2), // Borde con opacidad
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
                            child: trainingModel.image != null
                                ? Image.network(
                                    trainingModel.image!,
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
                              trainingModel.level ?? 'Nivel no especificado',
                              style: TextStyle(
                                fontFamily: 'Lato',
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Styles.iconColorBack,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              trainingModel.name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontFamily: 'Lato',
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Styles.greyTextColor,
                              ),
                            ),
                            SizedBox(height: 4),
                            // Mostrar el nivel si está disponible
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
                                    value: trainingModel.progress ?? 0.0,
                                    backgroundColor:
                                        Styles.greyTextColor.withOpacity(0.2),
                                    color: Styles.iconColorBack,
                                    minHeight: 6,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Text(
                                  '${((trainingModel.progress ?? 0) * 100).toInt()}%',
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
          );
        })
      ],
    );
  }
}
