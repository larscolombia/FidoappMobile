import 'package:flutter/material.dart';
import 'package:pawlly/modules/helper/helper.dart';

class CustomCheckbox2 extends StatelessWidget {
  final bool value;
  final void Function(bool?) onChanged;
  final String label;
  final Color activeColor;
  final Color checkColor;
  final TextStyle? labelStyle;

  const CustomCheckbox2({
    Key? key,
    required this.value,
    required this.onChanged,
    required this.label,
    this.activeColor = Colors.blue,
    this.checkColor = Colors.white,
    this.labelStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: value,

          onChanged: onChanged,
          activeColor:
              Colors.transparent, // Mantiene el color de fondo transparente
          checkColor:
              Colors.grey.withOpacity(0.6), // Color del icono de verificación

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: VisualDensity.compact,
          side: MaterialStateBorderSide.resolveWith((states) {
            // Color del borde basado en el estado
            if (states.contains(MaterialState.selected)) {
              return BorderSide(
                  color: Colors.grey.withOpacity(0.6),
                  width: 2); // Color del borde cuando está seleccionado
            }
            return BorderSide(
                color: Colors.grey.withOpacity(0.6),
                width: 2); // Color del borde cuando no está seleccionado
          }),
          // No hay una propiedad directa para la fuente en Checkbox,
          // pero puedes envolverlo en un widget personalizado si necesitas texto
        ),
        const SizedBox(width: 8),
        Text(label,
            style: labelStyle ??
                const TextStyle(
                  fontSize: 14,
                  fontFamily: Helper.funte1,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                )),
      ],
    );
  }
}
