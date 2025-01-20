import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pawlly/components/button_default_widget.dart';
import 'package:pawlly/generated/assets.dart';
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
          ),
          textAlign: TextAlign.left,
        ),
        const SizedBox(height: 10),

        // Lista de videos/cursos
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Obx(() {
            return Row(
              children: blogController.filteredBlogPosts.map((video) {
                return GestureDetector(
                  onTap: () {
                    Get.to(() => CursoVideo(
                          videoId: "",
                          cursoId: video.id.toString(),
                          name: video.name,
                          description: video.description,
                          image: video.blogImage,
                          duration: "",
                          price: "",
                          difficulty: "blogs",
                          videoUrl: video.url_video ?? "",
                          tipovideo: 'blogs',
                          dateCreated: video.createdAt.toString(),
                        ));
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 16),
                    padding: const EdgeInsets.all(18),
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: 260,
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
                                child: const Text(
                                  "Necesitamos la duración",
                                  style: TextStyle(
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
                            video.tags ?? 'Videos de Entrenamiento',
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
                                fontWeight: FontWeight.w400,
                                color: Styles.greyTextColor,
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
                                fontWeight: FontWeight.w400,
                                color: Styles.greyTextColor,
                              ),
                            ),
                          ],
                        ),
                        // Título del video (máximo 2 líneas)
                        Expanded(
                          child: Text(
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
                    fontWeight: FontWeight.w700,
                    color: Styles.iconColorBack,
                  ),
                ),
              ),
              const SizedBox(width: 5),
              const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Styles.iconColorBack,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
