import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pawlly/modules/components/input_text_icon.dart';
import 'package:pawlly/modules/components/recarga_componente.dart';
import 'package:pawlly/modules/home/screens/explore/show/curso_video.dart';
import 'package:pawlly/modules/integracion/controller/cursos/cursos_controller.dart';
import 'package:pawlly/styles/styles.dart';

class VideoList extends StatefulWidget {
  VideoList({super.key});

  @override
  State<VideoList> createState() => _VideoListState();
}

class _VideoListState extends State<VideoList> {
  final CourseController courseController = Get.put(CourseController());
  bool _hasInitialized = false;

  @override
  void initState() {
    super.initState();
    // Solo ejecutar fetchCourses una vez al inicializar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_hasInitialized) {
        courseController.fetchCourses();
        _hasInitialized = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          SizedBox(
            width: Styles.widh_pantalla,
            child: InputTextWithIcon(
              hintText: 'Realiza tu búsqueda',
              iconPath: 'assets/icons/search.png',
              iconPosition: IconPosition.left,
              height: 60.0, // Altura personalizada
              onChanged: (value) {
                courseController.filterCoursesByName(value);
                print('search: $value');
              },
            ),
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Obx(() {
              if (courseController.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.green),
                );
              }
              
              if (courseController.filteredCourses.isEmpty) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 50),
                      Icon(
                        Icons.search_off,
                        size: 64,
                        color: Color(0xFF959595),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'No se encontraron videos',
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF959595),
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Intenta con otros términos de búsqueda',
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF959595),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }
              
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: courseController.filteredCourses.map((course) {
                  return GestureDetector(
                    onTap: () {
                      // Acción al tocar un curso
                      print('Curso seleccionado: ${course.id}');
                      Get.to(() =>CursoVideo(
                        videoId: "",
                        cursoId: course.id.toString(),
                        name: course.name,
                        description: course.description,
                        image: course.image,
                        duration: "",
                        price: "",
                        difficulty: course.difficulty,
                        videoUrl: "",
                        tipovideo: 'video',
                        dateCreated: DateTime.now().toString(),
                      ));
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(12),
                      width: Styles.widh_pantalla,
                      decoration: BoxDecoration(
                        color: Styles.whiteColor,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Styles.greyTextColor.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Imagen del curso con el icono de reproducción y la duración
                          Stack(
                            children: [
                              Container(
                                height: 200,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: course.image != null
                                      ? Image.network(
                                          course.image,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) {
                                            return Image.asset(
                                              'assets/images/default_video.png',
                                              fit: BoxFit.cover,
                                            );
                                          },
                                        )
                                      : Image.asset(
                                          'assets/images/default_video.png',
                                          fit: BoxFit.cover,
                                        ),
                                ),
                              ),
                              // Icono de reproducción en el centro
                              Positioned.fill(
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Icon(
                                    Icons.play_circle_fill,
                                    color: Colors.white.withOpacity(0.8),
                                    size: 60,
                                  ),
                                ),
                              ),
                              // Duración del curso en la esquina superior derecha
                              Positioned(
                                bottom: 8,
                                right: 8,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.7),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Text(
                                    course.duration ?? "0",
                                    style: const TextStyle(
                                      fontFamily: 'Lato',
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Styles.whiteColor,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          // Tema del curso
                          Text(
                            'Cursos de Entrenamiento',
                            style: const TextStyle(
                              fontFamily: 'Lato',
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Styles.iconColorBack,
                            ),
                          ),
                          const SizedBox(height: 4),
                          // Fecha y cantidad de visualizaciones
                          Text(
                            'Fecha de creación',
                            style: const TextStyle(
                              fontFamily: 'Lato',
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Styles.greyTextColor,
                            ),
                          ),
                          const Text(
                            'Necesitamos la cantidad de visualizaciones',
                            style: TextStyle(
                              fontFamily: 'Lato',
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Styles.greyTextColor,
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Título del curso (máximo 2 líneas)
                          Text(
                            course.name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontFamily: 'Lato',
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Styles.greyTextColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              );
            }),
          ),
          RecargaComponente(
            callback: () {
              courseController.fetchCourses();
              print('Recargar');
            },
          ),
        ],
      ),
    );
  }
}
