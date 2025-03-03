import 'package:flutter/material.dart';
import 'package:pawlly/components/button_default_widget.dart';
import 'package:pawlly/modules/integracion/controller/cursos/cursos_controller.dart';
import 'package:pawlly/styles/recursos.dart';
import 'package:pawlly/styles/styles.dart';

class BanerEntrenamiento extends StatelessWidget {
  BanerEntrenamiento({
    super.key,
    required this.imagen,
    this.normalizedProgress = 0.0,
    required this.nombre,
    this.dificultad,
    this.ishorizontal = false,
    required this.callback,
  });

  final String imagen;
  final String nombre;
  final String? dificultad;
  final double normalizedProgress;
  final bool ishorizontal;
  final void Function()? callback;

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
    final double screenWidth = MediaQuery.of(context).size.width;
    final double imageWidth = this.ishorizontal ? screenWidth * 0.30 : screenWidth * 0.35; // Ajuste dinámico
    final double imageHeight =
        imageWidth * (122 / 131); // Mantiene la proporción

    double aspectRatio = 118 / 131;
    double minWidth = 100; // Define un mínimo
    double maxWidth = 300; // Define un máximo

    double width =
        (MediaQuery.of(context).size.width * 0.33).clamp(minWidth, maxWidth);
    double height = width / aspectRatio;

    return Container(
      margin: const EdgeInsets.only(bottom: 5),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Styles.whiteColor,
        borderRadius: BorderRadius.circular(8.42),
        border: Border.all(
          color: const Color(0xffEAEAEA),
          width: 1,
        ),
      ),
      child: Row(
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
                imagen,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              (loadingProgress.expectedTotalBytes ?? 1)
                          : null,
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
              margin: const EdgeInsets.only(left: 12),
              height: imageHeight + 9, // Ajuste dinámico
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Dificultad
                  Text(
                    dificultadValue(dificultad ?? ''),
                    style: const TextStyle(
                      fontFamily: 'Lato',
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Styles.iconColorBack,
                    ),
                  ),
                  const SizedBox(height: 1),
                  // Nombre del curso
                  Flexible(
                    child: Text(
                      nombre,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'Lato',
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF383838),
                      ),
                    ),
                  ),
                  const Text(
                    'Progreso:',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF383838),
                      fontFamily: Recursos.fuente1,
                    ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: imageWidth * 0.8, // Ajuste dinámico
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(27.0),
                          child: LinearProgressIndicator(
                            value: normalizedProgress,
                            backgroundColor: const Color(0XFFECECEC),
                            color: Styles.iconColorBack,
                            minHeight: 6,
                            borderRadius: BorderRadius.circular(27.0),
                          ),
                        ),
                      ),
                      Text(
                        '${(normalizedProgress * 100).toStringAsFixed(0)}%',
                        style: const TextStyle(
                          fontFamily: 'Lato',
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: Styles.iconColorBack,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: height * 0.10),

                  SizedBox(
                    height: 32,
                    child: ElevatedButton(
                      onPressed: callback,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Styles.primaryColor,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 35,
                          vertical: 8,
                        ),
                        elevation: 0,
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Seguir viendo',
                            style: TextStyle(
                              fontFamily: 'Lato',
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Color(0xffFFFFFF),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
