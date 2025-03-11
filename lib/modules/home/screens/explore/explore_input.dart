import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pawlly/components/input_busqueda.dart';
import 'package:pawlly/modules/home/controllers/home_controller.dart';
import 'package:pawlly/modules/home/screens/explore/libro_detalles.dart';
import 'package:pawlly/modules/integracion/controller/blogs/blogs_controller.dart';
import 'package:pawlly/modules/integracion/controller/cursos/cursos_controller.dart';
import 'package:pawlly/modules/integracion/controller/libros/libros_controller.dart';
import 'package:pawlly/styles/recursos.dart';
import 'package:pawlly/styles/styles.dart';

class ExploreInput extends StatelessWidget {
  final EBookController controller = Get.put(EBookController());
  final HomeController homeController = Get.put(HomeController());
  final BlogController blogController = Get.put(BlogController());
  final CourseController courseController = Get.put(CourseController());

  ExploreInput({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Input de búsqueda con lupa
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: InputBusqueda(
            onChanged: (value) {
              controller.filterEBooks(value);
              blogController.getBlogPostsByName(value);
              courseController.filterCoursesByName(value);
            },
          ),
        ),
        const SizedBox(height: 16),

        // Lista de libros o mensaje de "No hay libros disponibles"
        Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.filteredEBooks.isEmpty) {
            return Container();
          }

          return Column(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: controller.filteredEBooks.map((libro) {
                    return GestureDetector(
                      onTap: () {
                        controller.selectEBookById("${libro.id}");
                        Get.to(() => LibroDetalles());
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 16),
                        padding: const EdgeInsets.all(12),
                        width: 125,
                        height: 229,
                        decoration: BoxDecoration(
                          color: Styles.whiteColor,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Recursos.ColorBorderSuave,
                            width: 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Imagen del libro
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              height: 124,
                              child: ClipRRect(
                                child: libro.coverImage != null
                                    ? Image.network(
                                        libro.coverImage!,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Image.asset(
                                            'assets/images/default_book.png',
                                            fit: BoxFit.cover,
                                          );
                                        },
                                      )
                                    : Image.asset(
                                        'assets/images/default_book.png',
                                        fit: BoxFit.cover,
                                      ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            // Nombre del libro
                            Flexible(
                              child: Text(
                                libro.title!,
                                maxLines: 4,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  height: 1.2,
                                  fontFamily: 'Lato',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0XFF383838),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 16),

              // "Ver más de esta sección" solo si hay libros
              GestureDetector(
                onTap: () {
                  homeController.selectedIndex.value = 5;
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Ver más de esta sección',
                      style: TextStyle(
                        fontFamily: 'Lato',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Styles.iconColorBack,
                      ),
                    ),
                    SizedBox(width: 5),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 12,
                      color: Styles.iconColorBack,
                    ),
                  ],
                ),
              ),
            ],
          );
        }),
      ],
    );
  }
}
