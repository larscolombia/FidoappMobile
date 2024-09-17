import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pawlly/components/button_default_widget.dart';
import 'package:pawlly/generated/assets.dart';
import 'package:pawlly/styles/styles.dart';

class EntertainmentBlogs extends StatelessWidget {
  EntertainmentBlogs({super.key});

  // Datos dummy para la lista de videos/cursos
  final List<Map<String, dynamic>> videoList = [
    {
      "image": "https://example.com/video1.png",
      "title": "Entrenamiento Básico para Mascotas",
      "date": "2 de Agosto, 2024",
      "views": "15.1k Visualizaciones",
      "duration": "10:35",
    },
    {
      "image": "https://example.com/video2.png",
      "title": "Cómo Jugar con tu Mascota en Casa",
      "date": "15 de Julio, 2024",
      "views": "8.4k Visualizaciones",
      "duration": "12:50",
    },
    {
      "image": "https://example.com/video3.png",
      "title": "Consejos de Nutrición para Perros",
      "date": "22 de Junio, 2024",
      "views": "20.1k Visualizaciones",
      "duration": "15:30",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Título de la sección
        Text(
          'Blogs y Entrenamientos',
          style: TextStyle(
            fontSize: 20,
            color: Styles.primaryColor,
            fontFamily: 'PoetsenOne',
          ),
          textAlign: TextAlign.left,
        ),
        SizedBox(height: 10),

        // Lista de videos/cursos
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: videoList.map((video) {
              return GestureDetector(
                onTap: () {
                  // Acción al tocar un video
                  print('Video seleccionado: ${video['title']}');
                },
                child: Container(
                  margin: EdgeInsets.only(right: 16),
                  padding: EdgeInsets.all(12),
                  width: MediaQuery.of(context).size.width * 0.6,
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
                              child: video['image'] != null
                                  ? Image.network(
                                      video['image'],
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
                                size: 60,
                              ),
                            ),
                          ),
                          // Duración del video en la esquina superior derecha
                          Positioned(
                            bottom: 8,
                            right: 8,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 6),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.7),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(
                                video['duration'],
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
                      SizedBox(height: 8),
                      // Tema del video
                      Text(
                        'Videos de Entrenamiento',
                        style: TextStyle(
                          fontFamily: 'Lato',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Styles.iconColorBack,
                        ),
                      ),
                      SizedBox(height: 4),
                      // Fecha y cantidad de visualizaciones
                      Text(
                        '${video['date']}',
                        style: TextStyle(
                          fontFamily: 'Lato',
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Styles.greyTextColor,
                        ),
                      ),
                      Text(
                        '${video['views']}',
                        style: TextStyle(
                          fontFamily: 'Lato',
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Styles.greyTextColor,
                        ),
                      ),
                      SizedBox(height: 8),
                      // Título del video (máximo 2 líneas)
                      Text(
                        video['title'],
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
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
          ),
        ),
        SizedBox(height: 16),
        // Ver más sección
        GestureDetector(
          onTap: () {
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
