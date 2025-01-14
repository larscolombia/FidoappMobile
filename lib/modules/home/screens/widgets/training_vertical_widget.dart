import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pawlly/components/button_default_widget.dart';
import 'package:pawlly/models/training_model.dart';
import 'package:pawlly/modules/home/screens/explore/show/curso_video.dart';
import 'package:pawlly/modules/home/screens/explore/show/cursos_detalles.dart';
import 'package:pawlly/modules/integracion/controller/cursos/cursos_controller.dart';
import 'package:pawlly/modules/integracion/model/curosos/cursos_usuarios.dart';
import 'package:pawlly/styles/styles.dart';

class TrainingVertical extends StatelessWidget {
  final List<CursosUsuarios> cursoslista;
  final CourseController controller = Get.put(CourseController());
  // Constructor que recibe la lista de entrenamientos
  TrainingVertical({super.key, required this.cursoslista});

  @override
  Widget build(BuildContext context) {
    final double imageWidth = MediaQuery.of(context).size.width * 0.5;

    return Column(
      children: cursoslista.map((trainingModel) {
        final double rawProgress =
            double.tryParse(trainingModel.progress.toString()) ?? 0.0;
        final double normalizedProgress =
            rawProgress > 1 ? rawProgress / 100 : rawProgress;
        return GestureDetector(
          onTap: () {
            // Acción cuando se hace tap en un entrenamiento
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(6),
            height: 142,
            decoration: BoxDecoration(
              color: Colors.white,
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
                    width: 131,
                    height: 118,
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
                  child: SizedBox(
                    height: 137,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          controller.dificultad(trainingModel.difficulty),
                          style: const TextStyle(
                            fontFamily: 'Lato',
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Styles.iconColorBack,
                          ),
                        ),
                        SizedBox(
                          height: 40,
                          child: Text(
                            trainingModel.name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontFamily: 'Lato',
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const Text(
                          'Progreso:',
                          style: TextStyle(
                            fontFamily: 'Lato',
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(
                                  12.0, // Ajusta el radio de las esquinas según lo necesites
                                ),
                                child: LinearProgressIndicator(
                                  value:
                                      normalizedProgress, // Se usa el valor normalizado
                                  backgroundColor:
                                      Styles.greyTextColor.withOpacity(0.2),
                                  color: Styles.iconColorBack,
                                  minHeight: 6,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              // Se formatea el porcentaje correctamente, mostrando 25% en lugar de 0.25%
                              '${(normalizedProgress * 100).toStringAsFixed(0)}%',
                              style: const TextStyle(
                                fontFamily: 'Lato',
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                                color: Styles.iconColorBack,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 26,
                          child: ButtonDefaultWidget(
                            callback: () {
                              Get.to(CursosDetalles(
                                  cursoId: "${trainingModel.id.toString()}"));
                              /** 
                              var video = controller.findVideoById(
                                  courseId: trainingModel.id,
                                  videoId: trainingModel.id.toString());

                              Get.to(CursoVideo(
                                videoId: video?.url ?? '',
                                cursoId: trainingModel.id.toString(),
                                name: trainingModel.name,
                                description: trainingModel.description,
                                image: trainingModel.image,
                                duration: trainingModel.duration,
                                price: trainingModel.price,
                                difficulty: trainingModel.difficulty,
                                videoUrl: video?.url ?? '',
                                tipovideo: 'video',
                              ));*/
                            },
                            title: 'Seguir viendo',
                            textSize: 9,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
