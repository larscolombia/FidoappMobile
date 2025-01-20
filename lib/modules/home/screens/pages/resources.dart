import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pawlly/modules/home/controllers/home_controller.dart';
import 'package:pawlly/modules/integracion/controller/herramientas/herramientas_controller.dart';
import 'package:pawlly/modules/integracion/controller/recursos_select.dart';
import 'package:pawlly/styles/styles.dart';

import '../../../components/regresr_components.dart';

class Resources extends StatelessWidget {
  Resources({super.key});
  final HomeController controller = Get.put(HomeController());
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final RecursosSelect selectRecursos = Get.put(RecursosSelect());

    // Lista de recursos (ahora fija, no dinámica)
    final List<Map<String, dynamic>> resources = [
      {'id': 5, 'icon': 'assets/icons/ebook_icon.png', 'label': 'Libros'},
      {'id': 6, 'icon': 'assets/icons/youtue_icon.png', 'label': 'YouTube'},
      {
        'id': 7,
        'icon': 'assets/icons/accesorios_icon.png',
        'label': 'Accesorios'
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() {
          if (controller.selectedIndex.value == 5) {
            return BarraBack(
              titulo: 'Recursos',
              callback: () {
                controller.updateIndex(0);
              },
            );
          }
          if (controller.selectedIndex.value == 6) {
            return BarraBack(
              titulo: 'Blogs y Vídeos',
              callback: () {
                controller.updateIndex(0);
              },
            );
          }
          return Center(
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Text(
                'Recursos',
                style: Styles.titulorecursos,
                textAlign: TextAlign.left,
              ),
            ),
          );
        }),

        const SizedBox(height: 10),
        // Carrusel deslizable de recursos
        SizedBox(
          height: 44,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: resources.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  if (resources[index]['id'] == 7) {
                    controller.updateIndex(7);
                  } else {
                    controller.updateIndex(resources[index]['id']!);
                  }
                }, // Acción al tocar el cuadro
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(
                      horizontal:
                          12), // Padding para ajustar al ancho del texto
                  margin: const EdgeInsets.only(
                      right:
                          10), // Espacio entre elementos y margen hacia abajo

                  decoration: BoxDecoration(
                    color: controller.selectedIndex == resources[index]['id']!
                        ? Styles.fiveColor
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(19),
                    border: Border.all(
                      color: Styles.greyTextColor.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize:
                        MainAxisSize.min, // Ajusta al tamaño mínimo necesario
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Ícono antes del texto
                      Image.asset(resources[index]['icon']!),
                      const SizedBox(
                          width: 5), // Espacio entre el ícono y el texto
                      Text(
                        resources[index]['label']!,
                        style: const TextStyle(
                          fontFamily: 'Lato',
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // Función para convertir el string en IconData
  IconData getIconData(String iconName) {
    switch (iconName) {
      case 'book':
        return Icons.book;
      case 'video_library':
        return Icons.video_library;
      case 'extension':
        return Icons.extension;
      default:
        return Icons.help; // Ícono por defecto si no se encuentra
    }
  }
}
