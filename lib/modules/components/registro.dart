import 'package:flutter/material.dart';
import 'package:pawlly/components/button_default_widget.dart';
import 'package:pawlly/modules/components/style.dart';
import 'package:pawlly/styles/recursos.dart';

class Registro extends StatelessWidget {
  final String titulo;
  final String subtitulo;
  final String fecha;
  final String registroId;
  final Function()? callback;

  const Registro({
    super.key,
    required this.titulo,
    required this.subtitulo,
    required this.fecha,
    required this.registroId,
    this.callback,
  });

  @override
  Widget build(BuildContext context) {
    // Usamos MediaQuery para obtener el tamaño de la pantalla
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Styles.whiteColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Recursos.ColorBorderSuave, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título de la actividad
          Expanded(
            flex: 5,
            child: Text(
              titulo ?? '',
              style: TextStyle(
                fontSize: width > 600 ? 18 : 16,
                fontFamily: 'Lato',
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 8),
          // Categoría y fecha
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  subtitulo,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: width > 600 ? 14 : 12,
                    fontFamily: 'Lato',
                    fontWeight: FontWeight.w700,
                    color: Styles.iconColorBack,
                  ),
                ),
                Text(
                  fecha,
                  style: TextStyle(
                    fontSize: width > 600 ? 14 : 12,
                    fontFamily: 'Lato',
                    fontWeight: FontWeight.w500,
                    color: const Color(0xff959595),
                  ),
                ),
                Text(
                  'Registro Nro. ${registroId}',
                  style: TextStyle(
                    fontSize: width > 600 ? 14 : 12,
                    fontFamily: 'Lato',
                    fontWeight: FontWeight.w500,
                    color: const Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          const SizedBox(height: 8),
          // Botón de acción
          SizedBox(
            height: width > 600
                ? 40
                : height *
                    0.05, // Ajusta el tamaño del botón según el ancho de la pantalla
            child: Align(
              alignment: Alignment.bottomCenter,
              child: ButtonDefaultWidget(
                title: 'Abrir >',
                callback: callback,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
