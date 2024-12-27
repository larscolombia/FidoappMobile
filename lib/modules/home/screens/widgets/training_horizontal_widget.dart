import 'package:flutter/material.dart';
import 'package:pawlly/models/training_model.dart';
import 'package:pawlly/modules/integracion/model/curosos/cursos_usuarios.dart';
import 'package:pawlly/styles/styles.dart';

class TrainingHorizontal extends StatelessWidget {
  final List<CursosUsuarios> trainingList;

  // Constructor que recibe la lista de entrenamientos
  const TrainingHorizontal({super.key, required this.trainingList});

  @override
  Widget build(BuildContext context) {
    final double imageWidth = MediaQuery.of(context).size.width * 0.5;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: trainingList.map((trainingModel) {
          return GestureDetector(
            onTap: () {
              // Acción cuando se hace tap en un entrenamiento
              print(
                  'Nombre del container: ${trainingModel.name} - ID: ${trainingModel.id}');
            },
            child: Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.all(12),
              width: MediaQuery.of(context).size.width * 0.8,
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
                                trainingModel.image,
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
                  const SizedBox(width: 12),
                  // Contenido del curso
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Nivel no especificado',
                          style: TextStyle(
                            fontFamily: 'Lato',
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Styles.iconColorBack,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          trainingModel.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontFamily: 'Lato',
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Styles.greyTextColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Progreso:',
                          style: TextStyle(
                            fontFamily: 'Lato',
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Styles.iconColorBack,
                          ),
                        ),
                        const SizedBox(height: 4),
                        // Barra de progreso
                        Row(
                          children: [
                            Expanded(
                              child: LinearProgressIndicator(
                                value: double.parse(
                                        trainingModel.progress.toString()) ??
                                    0.0,
                                backgroundColor:
                                    Styles.greyTextColor.withOpacity(0.2),
                                color: Styles.iconColorBack,
                                minHeight: 6,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${((trainingModel.progress ?? 0) * 100).toInt()}%',
                              style: const TextStyle(
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
    );
  }
}
