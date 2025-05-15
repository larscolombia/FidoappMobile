import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pawlly/components/input_busqueda.dart';
import 'package:pawlly/modules/components/recarga_componente.dart';
import 'package:pawlly/modules/components/regresr_components.dart';
import 'package:pawlly/modules/components/style.dart';
import 'package:pawlly/modules/home/screens/explore/training_programs.dart';
import 'package:pawlly/modules/home/screens/pages/header_notification.dart';
import 'package:pawlly/modules/home/screens/profecionales/profecionales.dart';
import 'package:pawlly/modules/integracion/controller/cursos/curso_usuario_controller.dart';
import 'package:pawlly/modules/integracion/controller/cursos/cursos_controller.dart';

import '../home/screens/widgets/training_horizontal_widget.dart';

class CursosEntrenamiento extends StatelessWidget {
  CursosEntrenamiento({super.key});
  final CursoUsuarioController miscursos = Get.put(CursoUsuarioController());
  final CourseController cursosController = Get.find();

  @override
  Widget build(BuildContext context) {
    // Ejecutar fetchCourses al abrir esta vista
    WidgetsBinding.instance.addPostFrameCallback((_) {
      cursosController.fetchCourses(); // Siempre se ejecuta al entrar a la vista
    });
    final ancho = MediaQuery.of(context).size.width - 50;
    final margen = 16.00;

    return Obx(() {
      if (cursosController.isLoading.value) {
        return const Scaffold(
          backgroundColor: Styles.colorContainer,
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      }
      return Scaffold(
        backgroundColor: Styles.colorContainer,
        body: Column(
          children: [
            Container(
              width: double.infinity,
              height: 148,
              decoration: const BoxDecoration(
                color: Styles.colorContainer,
              ),
              child: HeaderNotification(),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 25,
                      ),
                      SizedBox(
                        width: ancho,
                        child: BarraBack(
                          titulo: miscursos.courses.length == 0 ? '' : 'Seguir Viendo',
                          callback: () {
                            Get.back();
                          },
                        ),
                      ),
                      SizedBox(height: margen),
                      SizedBox(
                        width: ancho,
                        child: TrainingHorizontal(trainingList: miscursos.courses),
                      ),
                      SizedBox(height: margen),
                      Container(
                        width: ancho,
                        child: const Text(
                          'Cursos y Programas de Entrenamiento',
                          style: TextStyle(
                            fontSize: 20,
                            color: Styles.primaryColor,
                            fontWeight: FontWeight.w400,
                            height: 1.1, // Ajusta la altura de la línea
                            fontFamily: 'PoetsenOne',
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        width: ancho,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: cursosController.selectButton.entries.map((entry) {
                            // entry.key es la clave (1, 2, 3), entry.value es el valor (Principiante, Intermedio, Avanzado)
                            return Expanded(
                              child: Obx(() => Selecboton(
                                    titulo: entry.value, // Usamos entry.value para mostrar el nombre de la dificultad
                                    callback: () {
                                      print('dificultad ${entry.key}');
                                      // Cuando se selecciona un botón, se establece la clave correspondiente
                                      cursosController.selectedButton.value = entry.key;
                                      cursosController.filterCoursesByDificultad();
                                    },
                                    selected: cursosController.selectedButton.value == entry.key, // Comparamos con entry.key
                                  )),
                            );
                          }).toList(),
                        ),
                      ),
                      SizedBox(height: margen),
                      SizedBox(
                          width: ancho,
                          child: InputBusqueda(
                            onChanged: (velue) => cursosController.filterCoursesByName(velue),
                          )),
                      SizedBox(height: margen),
                      SizedBox(
                        width: ancho,
                        child: TrainingPrograms(
                          cursosController: cursosController,
                          vermas: false,
                        ),
                      ),
                      SizedBox(height: margen),
                      RecargaComponente(
                        callback: () {
                          cursosController.fetchCourses();
                        },
                      ),
                      SizedBox(height: margen),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
