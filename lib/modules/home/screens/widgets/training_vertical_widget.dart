import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pawlly/modules/components/baner_entrenamiento.dart';
import 'package:pawlly/modules/home/screens/explore/show/curso_video.dart';
import 'package:pawlly/modules/home/screens/explore/show/cursos_detalles.dart';
import 'package:pawlly/modules/integracion/controller/cursos/cursos_controller.dart';
import 'package:pawlly/modules/integracion/model/curosos/cursos_usuarios.dart';

class TrainingVertical extends StatelessWidget {
  final List<CursosUsuarios> cursoslista;
  final CourseController controller = Get.put(CourseController());
  // Constructor que recibe la lista de entrenamientos
  TrainingVertical({super.key, required this.cursoslista});

  @override
  Widget build(BuildContext context) {
    final double imageWidth = MediaQuery.sizeOf(context).width * 0.5;

    return Column(
      children: cursoslista.map((trainingModel) {
        final double rawProgress =
            double.tryParse(trainingModel.progress.toString()) ?? 0.0;
        final double normalizedProgress =
            rawProgress > 1 ? rawProgress / 100 : rawProgress;
        return BanerEntrenamiento(
          imagen: trainingModel.image ?? '',
          nombre: trainingModel.name,
          dificultad: trainingModel.difficulty,
          normalizedProgress: normalizedProgress,
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
        );
      }).toList(),
    );
  }
}
