import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pawlly/modules/components/recarga_componente.dart';
import 'package:pawlly/modules/home/screens/explore/show/cursos_detalles.dart';
import 'package:pawlly/modules/integracion/controller/cursos/cursos_controller.dart';
import 'package:pawlly/modules/integracion/model/curosos/cursos_model.dart';
import 'package:pawlly/styles/styles.dart';

class TrainingPrograms extends StatelessWidget {
  final CourseController cursosController = Get.put(CourseController());

  TrainingPrograms({super.key});

  @override
  Widget build(BuildContext context) {
    //cursosController.fetchCourses();
    final double imageWidth = MediaQuery.of(context).size.width * 0.35;
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
              children: cursosController.courses.map((course) {
                return GestureDetector(
                  onTap: () {
                    // Acción cuando se toca el curso
                    //Get.to(CourseDetailPage(course: course));
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(12),
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
                              child: course.image.isNotEmpty
                                  ? Image.network(
                                      course.image,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Image.asset(
                                          'assets/images/default_course.png',
                                          fit: BoxFit.cover,
                                        );
                                      },
                                    )
                                  : Image.asset(
                                      'assets/images/default_course.png',
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Contenido del curso
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Nivel del curso
                              Text(
                                cursosController.dificultad(course.difficulty),
                                style: TextStyle(
                                  fontFamily: 'Lato',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: Styles.iconColorBack,
                                ),
                              ),
                              const SizedBox(height: 4),
                              // Título del curso (máximo 3 líneas)
                              Text(
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
                              const SizedBox(height: 8),
                              // Botón "Ver detalles"
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      // Acción para ver detalles
                                      Get.to(CursosDetalles(
                                          cursoId: "${course.id}"));

                                      //Get.to(CourseDetailPage(course: course));
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Styles.primaryColor,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 8,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: const Row(
                                      children: [
                                        Text(
                                          'Ver detalles',
                                          style: TextStyle(
                                            fontFamily: 'Lato',
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: Styles.whiteColor,
                                          ),
                                        ),
                                        SizedBox(width: 5),
                                        Icon(
                                          Icons.arrow_forward_ios,
                                          size: 16,
                                          color: Styles.whiteColor,
                                        ),
                                      ],
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
            );
          }
        }),
        Center(
          child: RecargaComponente(
            callback: () {
              cursosController.fetchCourses();
            },
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
