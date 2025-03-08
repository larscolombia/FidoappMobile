import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pawlly/modules/components/style.dart';

class BarraBack extends StatelessWidget {
  const BarraBack({
    super.key,
    required this.titulo,
    this.callback,
    this.color = Styles.primaryColor,
    this.subtitle,
    this.ColorSubtitle,
    this.size = 20.00,
    this.fontFamily, // Nuevo parámetro para la fuente
  });

  final String titulo;
  final Color color;
  final String? subtitle;
  final Color? ColorSubtitle;
  final double size;
  final String? fontFamily; // Nuevo parámetro para la fuente
  final void Function()? callback;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: callback,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: 30,
            height: 30,
            child: Center(
              child: SvgPicture.asset(
                'assets/icons/svg/arrow_back.svg',
                width: 15,
                height: 15,
                colorFilter: ColorFilter.mode(
                    Styles.fiveColor, BlendMode.srcIn), // Aplica el color
              ),
            ),
          ),
          const SizedBox(width: 8), // Separación fija para evitar apilamientos
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: TextStyle(
                    fontSize: size,
                    fontWeight: FontWeight.w400,
                    fontFamily: fontFamily ??
                        'PoetsenOne', // Usa el parámetro o 'Lato' por defecto
                    color: color,
                  ),
                ),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      fontFamily: fontFamily ??
                          'Lato', // Usa el parámetro o 'Lato' por defecto
                      color: ColorSubtitle ?? Styles.fiveColor,
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
