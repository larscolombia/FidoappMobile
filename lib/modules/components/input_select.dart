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
    return Column(
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
        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth:
                MediaQuery.of(context).size.width, // Ajusta al ancho disponible
          ),
          child: DropdownButtonFormField<String>(
            isExpanded: true, // Asegura que los elementos se ajusten al ancho
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: color ?? Styles.colorContainer,
              suffixIcon: suffixIcon,
              prefixIcon: prefiIcon != null ? Image.asset("$prefiIcon") : null,
            ),
            hint: Text(
              placeholder ?? 'placeholder',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: TextColor ?? const Color.fromARGB(255, 252, 252, 252),
                fontFamily: 'Lato-Regular',
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
            items: items,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
