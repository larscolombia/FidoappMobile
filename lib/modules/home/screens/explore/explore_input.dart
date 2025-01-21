import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pawlly/components/input_busqueda.dart';
import 'package:pawlly/modules/components/input_text.dart';
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

        // Lista de productos para mascotas
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Obx(() {
            if (controller.ebooks.isEmpty) {
              return const Center(
                child: Text('No hay libros disponibles'),
              );
            }

            if (controller.isLoading.value) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return Row(
              children: controller.filteredEBooks.map((libro) {
                return GestureDetector(
                  onTap: () {
                    // Acción al tocar un producto o libro
                    print('libro id ${libro.id}');
                    controller.selectEBookById("${libro.id}");

                    Get.to(() => LibroDetalles());
                    print('object');
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 16),
                    padding: const EdgeInsets.all(12),
                    width: 125,
                    height: 249,
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
                        // Imagen del producto
                        Container(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          height: 124,
                          child: ClipRRect(
                            child: libro.coverImage != null
                                ? Image.network(
                                    libro.coverImage!,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
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
                        // Nombre del producto (máximo 3 líneas)
                        Flexible(
                          child: Text(
                            libro.title!,
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              height: 1.2,
                              fontFamily: 'Lato',
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Styles.greyTextColor,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Precio y tipo de producto (libro o artículo)
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
            homeController.selectedIndex.value = 5;
            print('Ver más de esta sección');
          },
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'Ver más de esta sección',
                style: TextStyle(
                  fontFamily: 'Lato',
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Styles.iconColorBack,
                ),
              ),
              SizedBox(width: 5),
              Icon(
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
