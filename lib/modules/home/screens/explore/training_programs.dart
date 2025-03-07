import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pawlly/modules/components/recarga_componente.dart';
import 'package:pawlly/modules/cursos/cursos_entrenamiento.dart';
import 'package:pawlly/modules/home/screens/explore/show/curso_video.dart';
import 'package:pawlly/modules/home/screens/explore/show/cursos_detalles.dart';
import 'package:pawlly/modules/integracion/controller/cursos/cursos_controller.dart';
import 'package:pawlly/modules/integracion/model/curosos/cursos_model.dart';
import 'package:pawlly/styles/recursos.dart';
import 'package:pawlly/styles/styles.dart';

class TrainingPrograms extends StatelessWidget {
  final CourseController cursosController;

  TrainingPrograms(
      {super.key,
      this.vermas = true,
      this.showTitle = false,
      required this.cursosController});
  final bool? vermas;
  final bool showTitle;

  String dificultadValue(String dificultad) {
    switch (dificultad) {
      case '1':
        return 'Fácil';
      case '2':
        return 'Media';
      case '3':
        return 'Difícil';
      default:
        return 'Difícil';
    }
  }

  @override
  Widget build(BuildContext context) {
    //cursosController.fetchCourses();
    var margin = 4.00;

    final double screenWidth = MediaQuery.of(context).size.width;
    final double imageWidth = screenWidth * 0.35; // Ajuste dinámico
    final double imageHeight =
        imageWidth * (118 / 131); // Mantiene la proporción

    double aspectRatio = 118 / 131;
    double minWidth = 100; // Define un mínimo
    double maxWidth = 300; // Define un máximo

    double width =
        (MediaQuery.of(context).size.width * 0.33).clamp(minWidth, maxWidth);
    double height = width / aspectRatio;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Título de la sección
        if (this.showTitle)
          Text(
            'Cursos y Programas de Entrenamiento',
            style: const TextStyle(
              fontSize: 20,
              color: Styles.primaryColor,
              fontFamily: Styles.fuente2,
            ),
          ),

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
                  margin: const EdgeInsets.only(bottom: 5),
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Styles.whiteColor,
                    borderRadius: BorderRadius.circular(8.42),
                    border: Border.all(
                      color: const Color(0xffEAEAEA),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      // Imagen con proporción dinámica
                      Container(
                        width: imageWidth,
                        height: imageHeight,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(7.72),
                          child: Image.network(
                            course.image,
                            fit: BoxFit.cover,
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
                                'assets/images/404.jpg',
                                fit: BoxFit.cover,
                              );
                            },
                          ),
                        ),
                      ),
                      // Información del curso
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(left: 12),
                          height: imageHeight + 9, // Ajuste dinámico
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Dificultad
                              Text(
                                dificultadValue(course.difficulty ?? ''),
                                style: const TextStyle(
                                  fontFamily: 'Lato',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: Styles.iconColorBack,
                                ),
                              ),
                              const SizedBox(height: 1),
                              // Nombre del curso
                              Flexible(
                                child: Text(
                                  course.name,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontFamily: 'Lato',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF383838),
                                  ),
                                ),
                              ),
                              SizedBox(height: height * 0.30),

                              SizedBox(
                                height: 32,
                                child: ElevatedButton(
                                  onPressed: () {
                                    // Navegar a detalles del curso
                                    Get.to(() => CursosDetalles(
                                          cursoId: "${course.id.toString()}",
                                        ));
                                    // Navegar a video del curso
                                    var video = cursosController.findVideoById(
                                      courseId: course.id,
                                      videoId: course.id.toString(),
                                    );

                                    Get.to(() => CursosDetalles(
                                          cursoId: course.id.toString(),
                                        ));
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Styles.primaryColor,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 35,
                                      vertical: 8,
                                    ),
                                    elevation: 0,
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
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            );
          }
        }),
        if (vermas == true) SizedBox(height: height * 0.15),
        if (vermas == true)
          Container(
            width: double.infinity,
            child: GestureDetector(
              onTap: () {
                Get.to(() => CursosEntrenamiento());
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Ver más de esta sección ',
                    style: TextStyle(
                      fontFamily: 'Lato',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0XFFFC9214),
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 12,
                    color: Color(0XFFFC9214),
                  ),
                ],
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
