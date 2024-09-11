import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pawlly/modules/home/controllers/home_controller.dart';
import 'package:pawlly/modules/home/screens/widgets/training_horizontal_widget.dart';
import 'package:pawlly/modules/home/screens/widgets/training_vertical_widget.dart';
import 'package:pawlly/styles/styles.dart';

class Training extends StatelessWidget {
  Training({super.key});

  // Instancia del controlador para manejar el estado
  final HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // El título cambia según el índice seleccionado
        Text(
          controller.selectedIndex.value == 0
              ? 'Entrenamientos'
              : 'Cursos y Programas de Entrenamiento',
          style: TextStyle(
            fontSize: 20,
            color: Styles.primaryColor,
            fontFamily: 'PoetsenOne',
          ),
        ),
        SizedBox(height: 10),
        // Se usa un Obx para actualizar dinámicamente el contenido según el índice seleccionado
        Obx(() {
          if (controller.training.isEmpty) {
            // Mostrar mensaje cuando no hay entrenamientos disponibles
            return Center(
              child: Text(
                'No hay entrenamientos disponibles',
                style: TextStyle(fontSize: 16, color: Styles.greyTextColor),
              ),
            );
          }

          // Renderizado según el índice seleccionado
          if (controller.selectedIndex.value == 0) {
            // Mostrar entrenamientos en vista vertical
            return TrainingVertical(trainingList: controller.training);
          } else if (controller.selectedIndex.value == 2) {
            // Mostrar entrenamientos en vista horizontal
            return TrainingHorizontal(trainingList: controller.training);
          }

          // Si no es ni caso 0 ni caso 2, devolver un contenedor vacío
          return Container();
        }),
      ],
    );
  }
}
