import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pawlly/modules/components/style.dart';

class InputSelect extends StatelessWidget {
  const InputSelect({
    super.key,
    this.label,
    this.placeholder,
    required this.onChanged,
    required this.items,
    this.suffixIcon,
    this.color,
    this.prefiIcon,
    this.TextColor,
  });

  final String? placeholder;
  final String? label;
  final ValueChanged<String?> onChanged;
  final List<DropdownMenuItem<String>> items; // Elementos del dropdown
  final Color? TextColor;
  final Color? color;
  final Icon? suffixIcon; // Definir el icono opcional
  final String? prefiIcon; // Definir el icono opcional
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label ?? '',
            style: TextStyle(
              fontSize: 14,
              color: TextColor ?? const Color.fromARGB(255, 252, 252, 252),
              fontFamily: 'Lato',
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Styles.fiveColor, width: 1),
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
                prefix: prefiIcon != null ? Image.asset("$prefiIcon") : null,
              ),
              hint: Text(
                placeholder ?? 'placeholder',
                style: TextStyle(
                  color: TextColor ?? const Color.fromARGB(255, 252, 252, 252),
                  fontFamily: 'Lato-Regular',
                  fontWeight: FontWeight.w600,
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
