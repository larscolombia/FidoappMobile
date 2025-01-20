import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pawlly/modules/components/recarga_componente.dart';
import 'package:pawlly/modules/cursos/cursos_entrenamiento.dart';
import 'package:pawlly/modules/home/screens/explore/show/cursos_detalles.dart';
import 'package:pawlly/modules/integracion/controller/cursos/cursos_controller.dart';
import 'package:pawlly/modules/integracion/model/curosos/cursos_model.dart';
import 'package:pawlly/styles/recursos.dart';
import 'package:pawlly/styles/styles.dart';

class TrainingPrograms extends StatelessWidget {
  final CourseController cursosController = Get.put(CourseController());

  TrainingPrograms({super.key, this.vermas = true});
  final bool? vermas;
  @override
  Widget build(BuildContext context) {
    //cursosController.fetchCourses();
    final double imageWidth = MediaQuery.of(context).size.width * 0.35;
    var margin = 4.00;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Título de la sección
        const Text(
          'Cursos y Programas de Entrenamiento',
          style: TextStyle(
            fontSize: 20,
            color: Styles.primaryColor,
            fontFamily: 'PoetsenOne',
          ),
        ),
        const SizedBox(height: 16),

        // Lista de cursos
        Obx(() {
          if (cursosController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          } else if (cursosController.courses.isEmpty) {
            return const Center(child: Text('No hay cursos disponibles'));
          } else {
            return Column(
              children: cursosController.filteredCourses.map((course) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Styles.whiteColor,
                    borderRadius: BorderRadius.circular(8.42),
                    border: Border.all(
                      color: Color(0xffEAEAEA),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        width: 104,
                        height: 116,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                              10), // Aquí le damos el borderRadius
                          child: Image.network(
                            course.image,
                            fit: BoxFit
                                .cover, // Para que la imagen ocupe todo el contenedor
                            width: 104,
                            height: 116,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          (loadingProgress.expectedTotalBytes ??
                                              1)
                                      : null,
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                'assets/images/404.jpg', // Imagen de error
                                fit: BoxFit.cover,
                              );
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(left: 12),
                          height: 116,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Text(
                                  cursosController
                                      .dificultad(course.difficulty),
                                  style: const TextStyle(
                                    fontFamily: 'Lato',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Styles.iconColorBack,
                                  ),
                                ),
                              ),
                              SizedBox(height: margin),
                              Expanded(
                                flex: 4,
                                child: Text(
                                  course.name,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontFamily: 'Lato',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: Styles.greyTextColor,
                                  ),
                                ),
                              ),
                              SizedBox(height: margin),
                              Expanded(
                                flex: 2,
                                child: ElevatedButton(
                                  onPressed: () {
                                    // Acción para ver detalles
                                    Get.to(() => CursosDetalles(
                                        cursoId: "${course.id}"));
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Styles.primaryColor,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 35,
                                      vertical: 2,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Ver detalles',
                                        style: TextStyle(
                                          fontFamily: 'Lato',
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xffFFFFFF),
                                        ),
                                      ),
                                      SizedBox(width: 4),
                                      Icon(
                                        Icons.arrow_forward_ios,
                                        size: 8,
                                        color: Styles.whiteColor,
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                );
                ;
              }).toList(),
            );
          }
        }),
        if (vermas == true)
          Container(
            width: double.infinity,
            child: GestureDetector(
              onTap: () {
                Get.to(() => CursosEntrenamiento());
              },
              child: Container(
                width: double.infinity,
                child: const Text(
                  'Ver más de esta sección >',
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    fontSize: 14,
                    color: Recursos.ColorPrimario,
                    fontFamily: Recursos.fuente1,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class CourseDetailPage extends StatelessWidget {
  final Course course;

  const CourseDetailPage({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(course.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(course.image),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(course.description,
                  style: const TextStyle(fontSize: 16)),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Duración: ${course.duration} horas',
                  style: const TextStyle(fontSize: 16)),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Precio: \$${course.price}',
                  style: const TextStyle(fontSize: 16)),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Dificultad: ${course.difficulty}',
                  style: const TextStyle(fontSize: 16)),
            ),
            if (course.videos.isNotEmpty)
              ...course.videos.map((video) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Video: ${video.url}',
                        style: const TextStyle(fontSize: 16)),
                  )),
          ],
        ),
      ),
    );
  }
}
