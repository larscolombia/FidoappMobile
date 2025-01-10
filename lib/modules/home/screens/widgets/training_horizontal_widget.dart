import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pawlly/components/button_default_widget.dart';
import 'package:pawlly/models/training_model.dart';
import 'package:pawlly/modules/home/screens/explore/show/curso_video.dart';
import 'package:pawlly/modules/integracion/controller/cursos/cursos_controller.dart';
import 'package:pawlly/modules/integracion/model/curosos/cursos_usuarios.dart';
import 'package:pawlly/styles/styles.dart';

class TrainingHorizontal extends StatelessWidget {
  final List<CursosUsuarios> trainingList;

  // Constructor que recibe la lista de entrenamientos
  const TrainingHorizontal({super.key, required this.trainingList});

  @override
  Widget build(BuildContext context) {
    final double imageWidth = MediaQuery.of(context).size.width * 0.5;
    final CourseController controller = Get.put(CourseController());

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: trainingList.map((trainingModel) {
          return GestureDetector(
            onTap: () {
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
              ));
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
                      width: 134,
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
                    height: 120,
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

                        // Barra de progreso
                        Row(
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(
                                    12.0), // Ajusta el radio de las esquinas según lo necesites
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
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${((trainingModel.progress ?? 0) * 100).toInt()}%',
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
                            callback: () {},
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
      ),
    );
  }
}
