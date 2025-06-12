import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pawlly/modules/cursos/cursos_entrenamiento.dart';
import 'package:pawlly/modules/home/screens/explore/show/cursos_detalles.dart';
import 'package:pawlly/modules/integracion/controller/cursos/cursos_controller.dart';
import 'package:pawlly/modules/integracion/model/curosos/cursos_model.dart';
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
    var margin = 4.00;

    final double screenWidth = MediaQuery.sizeOf(context).width;
    // Ajuste dinámico del ancho de la imagen basado en el ancho de la pantalla
    final double imageWidth =
        screenWidth * 0.30; // Reduje el porcentaje para más espacio de texto
    final double imageHeight = imageWidth * (118 / 131);

    double aspectRatio = 118 / 131;
    double minWidth = 150; // Aumenté el mínimo para pantallas pequeñas
    double maxWidth = 350; // Aumenté el máximo para pantallas grandes

    double width = (screenWidth * 0.40).clamp(
        minWidth, maxWidth); // Aumenté el porcentaje para ocupar más espacio
    double height = width / aspectRatio;

    // Ajuste de tamaño de fuente basado en el ancho de la pantalla
    double titleFontSize = screenWidth < 360
        ? 18
        : 20; // Reduce el tamaño de fuente en pantallas muy pequeñas
    double dificultadFontSize = screenWidth < 360
        ? 10
        : 12; // Reduce el tamaño de fuente en pantallas muy pequeñas
    double nombreFontSize = screenWidth < 360
        ? 12
        : 14; // Reduce el tamaño de fuente en pantallas muy pequeñas
    double verMasFontSize = screenWidth < 360
        ? 12
        : 14; // Reduce el tamaño de fuente en pantallas muy pequeñas

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 12, // Reduje el espacio superior
        ),
        // Título de la sección
        if (showTitle)
          Text(
            'Cursos y Programas de Entrenamiento',
            style: TextStyle(
              fontSize: titleFontSize,
              color: Styles.primaryColor,
              fontFamily: Styles.fuente2,
            ),
          ),
        if (showTitle)
          SizedBox(
            height: 10, // Reduje el espacio después del título
          ),

        // Lista de cursos
        Obx(() {
          if (cursosController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          } else if (cursosController.courses.isEmpty) {
            return const Center(
              child: Text(
                'No hay cursos disponibles',
                style: TextStyle(
                  color: Color(0xFF959595),
                  fontSize:
                      14, // Reduje el tamaño de fuente para "No hay cursos"
                  fontFamily: 'Lato',
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            );
          } else {
            return Column(
              children: cursosController.filteredCourses.map((course) {
                return Container(
                  margin: const EdgeInsets.only(
                      bottom: 10), // Reduje el margen inferior entre cursos
                  padding: const EdgeInsets.all(
                      12), // Reduje el padding interno del contenedor del curso
                  decoration: BoxDecoration(
                    color: Styles.whiteColor,
                    borderRadius: BorderRadius.circular(
                        10), // Aumenté ligeramente el radio del borde
                    border: Border.all(
                      color: const Color(0xffEAEAEA),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment
                        .start, // Alinea los elementos al inicio
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
                                  color: Styles.iconColorBack,
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
                          margin: const EdgeInsets.only(
                              left: 10), // Reduje el margen izquierdo
                          height: imageHeight + 9,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Dificultad
                              Text(
                                dificultadValue(course.difficulty ?? ''),
                                style: TextStyle(
                                  fontFamily: 'Lato',
                                  fontSize: dificultadFontSize,
                                  fontWeight: FontWeight.w400,
                                  color: Styles.iconColorBack,
                                ),
                              ),
                              const SizedBox(height: 2),
                              // Nombre del curso
                              Flexible(
                                child: Text(
                                  course.name,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontFamily: 'Lato',
                                    fontSize: nombreFontSize,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF383838),
                                  ),
                                ),
                              ),
                              SizedBox(
                                  height: height *
                                      0.05), // Reduje el espacio vertical

                              // Botón "Ver detalles"
                              SizedBox(
                                height: 30, // Reduje la altura del botón
                                child: ElevatedButton(
                                  onPressed: () {
                                    Get.to(() =>
                                        CursosDetalles(cursoId: course.id.toString()));
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Styles.primaryColor,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal:
                                          20, // Reduje el padding horizontal del botón
                                      vertical:
                                          5, // Reduje el padding vertical del botón
                                    ),
                                    elevation: 0,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Ver detalles',
                                        style: TextStyle(
                                          fontFamily: 'Lato',
                                          fontSize:
                                              verMasFontSize, // Reduje el tamaño de fuente del botón
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xffFFFFFF),
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                      const Icon(
                                        Icons.arrow_forward_ios,
                                        size: 10,
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
        if (vermas == true)
          SizedBox(height: height * 0.10), // Reduje el espacio "Ver más"
        if (vermas == true && cursosController.courses.isNotEmpty)
          Container(
            width: double.infinity,
            child: GestureDetector(
              onTap: () {
                Get.to(() => CursosEntrenamiento());
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment
                    .center, // Alinea verticalmente el texto y el icono
                children: [
                  Text(
                    'Ver más de esta sección ',
                    style: TextStyle(
                      fontFamily: 'Lato',
                      fontSize: verMasFontSize,
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
