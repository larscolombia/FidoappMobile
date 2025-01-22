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
    required this.callback,
  });

  final String imagen;
  final String nombre;
  final String? dificultad;
  final double normalizedProgress;
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
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
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
          // Imagen
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            width: 104,
            height: 127,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
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
                    'assets/images/404.jpg', // Imagen de error
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
              height: 127,
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
                      fontWeight: FontWeight.w500,
                      color: Styles.iconColorBack,
                    ),
                  ),
                  const SizedBox(height: 1),
                  // Nombre del curso
                  SizedBox(
                    height: 35,
                    child: Text(
                      nombre,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'Lato',
                        height: 1.2,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Styles.greyTextColor,
                      ),
                    ),
                  ),
                  const Text(
                    'Progreso:',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Recursos.ColorTextoTitulo,
                      fontFamily: Recursos.fuente1,
                    ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 101,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12.0),
                          child: LinearProgressIndicator(
                            value: normalizedProgress,
                            backgroundColor:
                                Styles.greyTextColor.withOpacity(0.2),
                            color: Styles.iconColorBack,
                            minHeight: 6,
                          ),
                        ),
                      ),
                      Text(
                        '${(normalizedProgress * 100).toStringAsFixed(0)}%',
                        style: const TextStyle(
                          fontFamily: 'Lato',
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                          color: Styles.iconColorBack,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
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
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Ver detalles',
                            style: TextStyle(
                              fontFamily: 'Lato',
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Color(0xffFFFFFF),
                            ),
                          ),
                          SizedBox(width: 4),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 8,
                            color: Styles.whiteColor,
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
