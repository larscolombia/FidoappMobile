import 'package:flutter/material.dart';
import 'package:pawlly/modules/components/style.dart';

class BarraBack extends StatelessWidget {
  const BarraBack({
    super.key,
    required this.titulo,
    this.callback,
    this.color = Styles.primaryColor, // Color por defecto
    this.subtitle,
    this.ColorSubtitle,
  });

  final String titulo;
  final Color color;
  final String? subtitle;
  final Color? ColorSubtitle;
  final void Function()? callback;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: callback,
            child: const SizedBox(
              width: 30,
              height: 30,
              child: Center(
                child: Icon(
                  Icons.arrow_back_ios,
                  color: Styles.fiveColor, // Usar el color personalizado
                  size: 20,
                ),
              ),
            ),
          ),
          // Aquí envolvemos el contenido del texto en un Expanded
          Container(
            width: MediaQuery.of(context).size.width - 120,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  softWrap:
                      true, // Ajusta el texto automáticamente cuando sea necesario
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'PoetsenOne',
                    color: color, // Usar el color personalizado
                  ),
                ),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    softWrap:
                        true, // Ajusta el texto automáticamente cuando sea necesario
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Lato',
                      color: ColorSubtitle ??
                          Styles.fiveColor, // Usar el color personalizado
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
