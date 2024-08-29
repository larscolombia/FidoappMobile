import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pawlly/styles/styles.dart';

class Resources extends StatelessWidget {
  const Resources({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    // Lista de recursos (ahora fija, no dinámica)
    final List<Map<String, String>> resources = [
      {'icon': 'book', 'label': 'Ebook’s'},
      {'icon': 'video_library', 'label': 'YouTube'},
      {'icon': 'extension', 'label': 'Accesorios'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recursos',
          style: TextStyle(
            fontSize: 20,
            color: Styles.primaryColor,
            fontFamily: 'PoetsenOne',
          ),
          textAlign: TextAlign.left,
        ),
        SizedBox(height: 10),
        // Carrusel deslizable de recursos
        Container(
          height: 44,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: resources.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => print(
                    resources[index]['label']), // Acción al tocar el cuadro
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(
                      horizontal:
                          12), // Padding para ajustar al ancho del texto
                  margin: EdgeInsets.only(
                      right:
                          10), // Espacio entre elementos y margen hacia abajo
                  decoration: BoxDecoration(
                    color: Colors.transparent,
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
                      Icon(
                        getIconData(resources[index]['icon']!),
                        size: 18,
                        color: Styles.primaryColor,
                      ),
                      SizedBox(width: 5), // Espacio entre el ícono y el texto
                      Text(
                        resources[index]['label']!,
                        style: TextStyle(
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
