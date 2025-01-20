import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pawlly/components/input_busqueda.dart';
import 'package:pawlly/modules/components/input_text.dart';
import 'package:pawlly/modules/components/recarga_componente.dart';
import 'package:pawlly/modules/components/regresr_components.dart';
import 'package:pawlly/modules/components/style.dart';
import 'package:pawlly/modules/home/screens/explore/explore_input.dart';
import 'package:pawlly/modules/home/screens/explore/training_programs.dart';
import 'package:pawlly/modules/home/screens/pages/header_notification.dart';
import 'package:pawlly/modules/home/screens/widgets/training_vertical_widget.dart';
import 'package:pawlly/modules/integracion/controller/cursos/curso_usuario_controller.dart';
import 'package:pawlly/modules/integracion/controller/cursos/cursos_controller.dart';

import '../home/screens/widgets/training_horizontal_widget.dart';

class CursosEntrenamiento extends StatelessWidget {
  CursosEntrenamiento({super.key});
  final CursoUsuarioController miscursos = Get.put(CursoUsuarioController());
  final CourseController cursosController = Get.put(CourseController());

  @override
  Widget build(BuildContext context) {
    final ancho = MediaQuery.of(context).size.width - 50;
    final margen = 16.00;
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
                        titulo: 'Seguir Viendo',
                        callback: () {
                          Get.back();
                        },
                      ),
                    ),
                    SizedBox(
                      width: ancho,
                      child:
                          TrainingHorizontal(trainingList: miscursos.courses),
                    ),
                    SizedBox(height: margen),
                    SizedBox(
                        width: ancho,
                        child: InputBusqueda(
                          onChanged: (velue) =>
                              cursosController.filterCoursesByName(velue),
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
  }
}
