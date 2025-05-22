import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pawlly/modules/components/baner_entrenamiento.dart';
import 'package:pawlly/modules/home/screens/explore/show/curso_video.dart';
import 'package:pawlly/modules/home/screens/explore/show/cursos_detalles.dart';
import 'package:pawlly/modules/integracion/controller/cursos/cursos_controller.dart';
import 'package:pawlly/modules/integracion/model/curosos/cursos_usuarios.dart';

class TrainingHorizontal extends StatelessWidget {
  final List<CursosUsuarios> trainingList;

  // Constructor que recibe la lista de entrenamientos
  const TrainingHorizontal({super.key, required this.trainingList});

  @override
  Widget build(BuildContext context) {
    final double imageWidth = MediaQuery.sizeOf(context).width * 0.5;
    final double cardSliderWidth = MediaQuery.sizeOf(context).width * 0.80;

    final CourseController controller = Get.put(CourseController());

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: trainingList.map((trainingModel) {
          final double rawProgress =
              double.tryParse(trainingModel.progress.toString()) ?? 0.0;
          final double normalizedProgress =
              rawProgress > 1 ? rawProgress / 100 : rawProgress;
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            width: cardSliderWidth,
            child: BanerEntrenamiento(
              imagen: trainingModel.image ?? '',
              nombre: trainingModel.name,
              dificultad: trainingModel.difficulty,
              normalizedProgress: normalizedProgress,
              ishorizontal: true,
              callback: () {
                Get.to(() =>
                    CursosDetalles(cursoId: "${trainingModel.id.toString()}"));

                var video = controller.findVideoById(
                    courseId: trainingModel.id,
                    videoId: trainingModel.id.toString());

                Get.to(() => CursoVideo(
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
            ),
          );
        }).toList(),
      ),
    );
  }
}
