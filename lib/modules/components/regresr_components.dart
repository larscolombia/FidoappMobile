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
    this.size = 18.00,
    this.fontFamily,
  });

  final String titulo;
  final Color color;
  final String? subtitle;
  final Color? ColorSubtitle;
  final double size;
  final String? fontFamily;
  final void Function()? callback;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: callback,
      behavior: HitTestBehavior.opaque, // Asegura que toda el área es táctil
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10), // Aumenta el área táctil
            child: SvgPicture.asset(
              'assets/icons/svg/arrow_back.svg',
              width: 18,
              height: 18,
              colorFilter: ColorFilter.mode(
                  Styles.fiveColor, BlendMode.srcIn), // Aplica el color
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  softWrap: true,
                  overflow: TextOverflow.visible,
                  style: TextStyle(
                    fontSize: size,
                    fontWeight: FontWeight.w400,
                    fontFamily: fontFamily ?? 'PoetsenOne',
                    color: color,
                  ),
                ),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    softWrap: true,
                    overflow: TextOverflow.visible,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      fontFamily: fontFamily ?? 'Lato',
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
