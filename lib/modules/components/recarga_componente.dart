import 'package:flutter/material.dart';
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
        Image.asset(
          "assets/icons/refresh.png",
        ),
        const SizedBox(
          width: 10,
        ),
        Text(
          titulo,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 14,
            fontFamily: 'Lato',
            fontWeight: FontWeight.w600,
            color: Styles.iconColorBack,
          ),
        ),
      ]),
    );
  }
}
