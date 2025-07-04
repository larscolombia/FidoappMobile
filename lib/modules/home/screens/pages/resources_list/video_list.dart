import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pawlly/modules/components/input_text_icon.dart';
import 'package:pawlly/modules/components/recarga_componente.dart';
import 'package:pawlly/modules/home/screens/explore/show/curso_video.dart';
import 'package:pawlly/modules/integracion/controller/blogs/blogs_controller.dart';
import 'package:pawlly/styles/styles.dart';

class VideoList extends StatelessWidget {
  final BlogController blogController = Get.put(BlogController());
  VideoList({super.key});
  @override
  Widget build(BuildContext context) {
    // Ejecutar fetchCourses al abrir esta vista
    WidgetsBinding.instance.addPostFrameCallback((_) {
      blogController.fetchBlogPosts(); // Siempre se ejecuta al entrar a la vista
    });
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
                blogController.getBlogPostsByName(value);
                print('search: $value');
              },
            ),
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Obx(() {
              if (blogController.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.green),
                );
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: blogController.filteredBlogPosts.map((video) {
                  return GestureDetector(
                    onTap: () {
                      // Acción al tocar un video
                      print('Video seleccionado: ${video.id}');
                      Get.to(() =>CursoVideo(
                        videoId: "",
                        cursoId: video.id.toString(),
                        name: video.name,
                        description: video.description,
                        image: video.blogImage,
                        duration: "",
                        price: "",
                        difficulty: "blogs",
                        videoUrl: "",
                        tipovideo: 'blogs',
                        dateCreated: video.createdAt.toString(),
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
                          // Imagen del video con el icono de reproducción y la duración
                          Stack(
                            children: [
                              Container(
                                height: 200,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: video.blogImage != null
                                      ? Image.network(
                                          video.blogImage,
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
                              // Duración del video en la esquina superior derecha
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
                          Text(
                            video.tags ?? 'Videos de Entrenamiento',
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
                            video.createdAt,
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
                          // Título del video (máximo 2 líneas)
                          Text(
                            video.name,
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
              blogController.fetchBlogPosts();
              print('Recargar');
            },
          ),
        ],
      ),
    );
  }
}
