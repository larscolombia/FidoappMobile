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
  });

  final String titulo;
  final Color color;
  final String? subtitle;
  final Color? ColorSubtitle;
  final void Function()? callback;

  @override
  Widget build(BuildContext context) {
    return Row(
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
                color: Styles.fiveColor,
                size: 20,
              ),
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
                  fontSize: 18,
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
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Lato',
                    color: ColorSubtitle ?? Styles.fiveColor,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
