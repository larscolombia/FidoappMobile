import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pawlly/modules/home/controllers/home_controller.dart';
import 'package:pawlly/modules/home/screens/widgets/training_horizontal_widget.dart';
import 'package:pawlly/modules/home/screens/widgets/training_vertical_widget.dart';
import 'package:pawlly/modules/integracion/controller/cursos/curso_usuario_controller.dart';
import 'package:pawlly/styles/styles.dart';

class Training extends StatelessWidget {
  Training({super.key});

  // Instancia del controlador para manejar el estado
  final HomeController controller = Get.put(HomeController());
  final CursoUsuarioController miscursos = Get.put(CursoUsuarioController());

  @override
  Widget build(BuildContext context) {
    if (miscursos.courses.isEmpty) {
      miscursos.fetchCourses();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // El título cambia según el índice seleccionado
        Text(
          controller.selectedIndex.value == 0
              ? 'Entrenamientos'
              : controller.selectedIndex.value == 3
                  ? 'Seguir Viendo'
                  : 'Cursos y Programas de Entrenamiento',
          style: const TextStyle(
            fontSize: 20,
            color: Styles.primaryColor,
            fontFamily: Styles.fuente2,
          ),
        ),
        const SizedBox(height: 10),
        // Se usa un Obx para actualizar dinámicamente el contenido según el índice seleccionado
        Obx(() {
          if (miscursos.courses.isEmpty) {
            // Mostrar mensaje cuando no hay entrenamientos disponibles
            return const Center(
              child: Text(
                'No hay entrenamientos disponibles',
                style: TextStyle(fontSize: 16, color: Styles.greyTextColor),
              ),
            );
          }

          // Renderizado según el índice seleccionado
          if (controller.selectedIndex.value == 0) {
            // Mostrar entrenamientos en vista vertical
            return TrainingVertical(cursoslista: miscursos.courses);
          } else if (controller.selectedIndex.value == 2 ||
              controller.selectedIndex.value == 3) {
            // Mostrar entrenamientos en vista horizontal para ambos casos (2 y 3)
            return TrainingHorizontal(trainingList: miscursos.courses);
          }

          // Si no es ni caso 0, 2 o 3, devolver un contenedor vacío
          return Container();
        }),
      ],
    );
  }
}
