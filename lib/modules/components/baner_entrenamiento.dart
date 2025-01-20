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
    var margin = 8.42;
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width, // Width completo
        margin: const EdgeInsets.only(top: 12),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(8.42)),
          border: Border.all(color: const Color(0xffEAEAEA), width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: imagen.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8.42),
                          child: Image.network(
                            imagen,
                            fit: BoxFit.cover,
                            height: 142,
                            width: double.infinity,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey[200],
                                child: const Center(
                                  child: Icon(Icons.error),
                                ),
                              );
                            },
                          ),
                        )
                      : Container(
                          color: Colors.grey[200],
                          child: const Center(
                            child: Icon(Icons.image, color: Colors.grey),
                          ),
                        ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.only(
                    right: 12,
                    top: 12,
                    bottom: 12,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dificultadValue('$dificultad' ?? ''),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Recursos.ColorPrimario,
                          fontFamily: Recursos.fuente1,
                        ),
                      ),
                      SizedBox(height: margin - 3),
                      // Aquí se fuerza el espacio para que el título ocupe dos líneas.
                      SizedBox(
                        height: 38,
                        child: Text(
                          nombre,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Recursos.ColorTextoTitulo,
                            fontFamily: Recursos.fuente1,
                          ),
                        ),
                      ),
                      SizedBox(height: margin),
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
                          SizedBox(width: margin),
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
                      SizedBox(height: margin),
                      SizedBox(
                        height: 36,
                        child: ButtonDefaultWidget(
                          callback: callback,
                          title: 'Seguir viendo',
                          textSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
