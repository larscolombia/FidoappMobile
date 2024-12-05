import 'package:flutter/material.dart';
import 'package:pawlly/modules/components/style.dart';

class RecargaComponente extends StatelessWidget {
  const RecargaComponente({
    super.key,
    this.callback,
  });
  final VoidCallback? callback;
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
          'Cargar más',
          style: TextStyle(
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
