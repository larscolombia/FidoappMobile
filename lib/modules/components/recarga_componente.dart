import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Asegúrate de importar el paquete
import 'package:pawlly/modules/components/style.dart';

class RecargaComponente extends StatelessWidget {
  const RecargaComponente({
    super.key,
    this.callback,
    this.titulo = 'Cargar más',
  });
  final VoidCallback? callback;
  final String titulo;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: callback,
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        SvgPicture.asset(
          "assets/icons/svg/refresh-2.svg", // Ruta del archivo SVG
          height: 18, // Puedes ajustar el tamaño si lo necesitas
          width: 18,
        ),
        const SizedBox(
          width: 10,
        ),
        Text(
          titulo,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 16,
            fontFamily: 'Lato',
            fontWeight: FontWeight.w500,
            color: Color(0xFFFC9214),
          ),
        ),
      ]),
    );
  }
}
