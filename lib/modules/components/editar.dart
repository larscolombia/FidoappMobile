import 'package:flutter/material.dart';
import 'package:pawlly/modules/components/style.dart';

class Editar extends StatelessWidget {
  const Editar({super.key, this.callback, this.coloredit});
  final Color? coloredit;
  final void Function()? callback;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: callback,
      child: Container(
          width: 50,
          decoration: BoxDecoration(
            color: coloredit ?? Styles.colorContainer,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Image.asset('assets/icons/edit-2.png')),
    );
  }
}
