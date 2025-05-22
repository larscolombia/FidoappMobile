import 'package:flutter/material.dart';
import 'package:pawlly/components/button_default_widget.dart';
import 'package:pawlly/modules/components/style.dart';

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
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;

    // Estilos constantes para los textos
    const TextStyle tituloStyle = TextStyle(
      fontSize: 18,
      fontFamily: 'Lato',
      fontWeight: FontWeight.w700,
      color: Color(0xFF383838),
    );

    const TextStyle subtituloStyle = TextStyle(
      fontSize: 12,
      fontFamily: 'Lato',
      fontWeight: FontWeight.w700,
      color: Color(0xFFFC9214),
    );

    const TextStyle fechaStyle = TextStyle(
      fontSize: 12,
      fontFamily: 'Lato',
      fontWeight: FontWeight.w500,
      color: Color(0xff959595),
    );

    const TextStyle registroIdStyle = TextStyle(
      fontSize: 12,
      fontFamily: 'Lato',
      fontWeight: FontWeight.w400,
      color: Color.fromARGB(255, 0, 0, 0),
    );

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16), // Reducido el padding
      decoration: BoxDecoration(
        color: Styles.whiteColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE8E8E8), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título de la actividad
          Text(
            titulo,
            style: tituloStyle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          // Categoría y fecha
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                subtitulo,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: subtituloStyle,
              ),
              Text(
                fecha,
                style: fechaStyle,
              ),
              Text(
                'Registro Nro. $registroId',
                style: registroIdStyle,
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Botón de acción
          SizedBox(
            height: width > 600 ? 40 : height * 0.04, // Ajusta el tamaño del botón según el ancho de la pantalla
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
