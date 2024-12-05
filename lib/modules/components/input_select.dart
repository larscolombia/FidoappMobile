import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pawlly/modules/components/style.dart';

class InputSelect extends StatelessWidget {
  const InputSelect({
    Key? key,
    this.label,
    this.placeholder,
    required this.onChanged,
    required this.items,
    this.suffixIcon,
    this.color,
    this.prefiIcon,
    this.TextColor,
  }) : super(key: key);

  final String? placeholder;
  final String? label;
  final ValueChanged<String?> onChanged;
  final List<DropdownMenuItem<String>> items; // Elementos del dropdown
  final Color? TextColor;
  final Color? color;
  final Icon? suffixIcon; // Definir el icono opcional
  final Icon? prefiIcon; // Definir el icono opcional
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 302,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label ?? '',
            style: TextStyle(
              fontSize: 14,
              color: TextColor ?? Color.fromARGB(255, 252, 252, 252),
              fontFamily: 'Lato',
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Styles.fiveColor, width: .5),
              color: Styles.fiveColor,
            ),
            child: DropdownButtonFormField<String>(
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: color ?? Styles.colorContainer,
                  suffixIcon: suffixIcon,
                  prefix: prefiIcon),
              hint: Text(
                placeholder ?? 'placeholder',
                style: TextStyle(
                  color: TextColor ?? Color.fromARGB(255, 252, 252, 252),
                  fontFamily: 'Lato',
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                ),
              ),
              items: items,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}
