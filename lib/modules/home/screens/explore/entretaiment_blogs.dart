import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pawlly/modules/home/controllers/home_controller.dart';
import 'package:pawlly/modules/home/screens/explore/show/curso_video.dart';
import 'package:pawlly/modules/integracion/controller/blogs/blogs_controller.dart';
import 'package:pawlly/styles/styles.dart';

class EntertainmentBlogs extends StatelessWidget {
  EntertainmentBlogs({super.key});
  final BlogController blogController = Get.put(BlogController());
  final HomeController homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Título de la sección
        const Text(
          'Blogs y Entrenamientos',
          style: TextStyle(
            fontSize: 20,
            color: Styles.primaryColor,
            fontFamily: 'PoetsenOne',
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.left,
        ),
        const SizedBox(height: 10),

        // Lista de videos/cursos
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Obx(() {
            if (blogController.isLoading.value) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            
            // Filtrar solo los blogs que tienen URLs de video válidas
            var blogsWithVideos = blogController.filteredBlogPosts
                .where((blog) => blog.url_video != null && blog.url_video!.isNotEmpty)
                .toList();
            
            if (blogsWithVideos.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 50),
                    Icon(
                      Icons.videocam_off_outlined,
                      size: 64,
                      color: Color(0xFF959595),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'No hay videos disponibles',
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF959595),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Los videos aparecerán aquí cuando estén disponibles',
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
            
            return Row(
              children: blogsWithVideos.map((video) {
                return GestureDetector(
                  onTap: () {
                    // Debug: Imprimir información del video antes de navegar
                    print('Navegando a video: ID=${video.id}, Name="${video.name}", URL="${video.url_video}"');
                    
                    // Validar si el video tiene una URL válida
                    if (video.url_video == null || video.url_video!.isEmpty) {
                      print('Error: Video sin URL válida');
                      // Mostrar un snackbar o alerta al usuario
                      Get.snackbar(
                        'Error',
                        'Este video no tiene una URL válida',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                      );
                      return;
                    }
                    
                    Get.to(() => CursoVideo(
                          videoId: "",
                          cursoId: video.id.toString(),
                          name: video.name,
                          description: video.description,
                          image: video.blogImage,
                          duration: "",
                          price: "",
                          difficulty: "blogs",
                          videoUrl: video.url_video!,
                          tipovideo: 'blogs',
                          dateCreated: video.createdAt.toString(),
                        ));
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 16),
                    padding: const EdgeInsets.all(18),
                    width: MediaQuery.sizeOf(context).width * 0.8,
                    decoration: BoxDecoration(
                      color: Styles.whiteColor,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Styles.greyTextColor.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize
                          .min, // Para que la columna se ajuste al contenido
                      crossAxisAlignment: CrossAxisAlignment
                          .start, // Alineación a la izquierda para el texto
                      children: [
                        // Imagen del video con el icono de reproducción
                        Stack(
                          children: [
                            Container(
                              height: 139,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: video.blogImage != null
                                    ? Image.network(
                                        video.blogImage,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
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
                                  size: 35,
                                ),
                              ),
                            ),
                            // Duración del video en la esquina superior derecha
                            Positioned(
                              bottom: 8,
                              right: 8,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 4, horizontal: 6),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.7),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Text(
                                  video.duration ?? "0",
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
                        // Tema del video
                        SizedBox(
                          height: 14,
                          child: Text(
                            _capitalizeFirstLetter(
                                video.tags ?? 'Videos de Entrenamiento'),
                            style: const TextStyle(
                              fontFamily: 'Lato',
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Styles.iconColorBack,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        // Fecha y cantidad de visualizaciones
                        Row(
                          children: [
                            Text(
                              video.createdAt.toString(),
                              style: const TextStyle(
                                fontFamily: 'Lato',
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Color(0XFF959595),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              width: 1,
                              height: 14,
                              color: Styles.greyTextColor,
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              '1',
                              style: TextStyle(
                                fontFamily: 'Lato',
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Color(0XFF959595),
                              ),
                            ),
                          ],
                        ),
                        // Título del video (máximo 2 líneas)
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 8.0), // Añade espacio arriba del título
                          child: Text(
                            video.name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontFamily: 'Lato',
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Color(0XFF383838),
                            ),
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
        const SizedBox(height: 16),
        // Ver más sección
        GestureDetector(
          onTap: () {
            print('Ver más de esta sección');
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {
                  homeController.updateIndex(6);
                },
                child: const Text(
                  'Ver más de esta sección',
                  style: TextStyle(
                    fontFamily: 'Lato',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Styles.iconColorBack,
                  ),
                ),
              ),
              const SizedBox(width: 5),
              const Icon(
                Icons.arrow_forward_ios,
                size: 12,
                color: Styles.iconColorBack,
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _capitalizeFirstLetter(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }
}
