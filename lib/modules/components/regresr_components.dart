import 'package:flutter/material.dart';
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
  });

  final String titulo;
  final Color color;
  final String? subtitle;
  final Color? ColorSubtitle;
  final double size;
  final void Function()? callback;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: callback,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(
            width: 30,
            height: 30,
            child: Center(
              child: Icon(
                Icons.arrow_back_ios,
                color: Styles.fiveColor,
                size: 20,
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
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: size,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'PoetsenOne',
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
                      fontFamily: 'Lato',
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
