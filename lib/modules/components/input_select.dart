import 'package:flutter/material.dart';
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
  final Icon? suffixIcon; // Definir el ícono opcional
  final String? prefiIcon; // Definir el ícono opcional

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
            icon: const SizedBox.shrink(), // Elimina la flecha desplegable
            isExpanded: true, // Asegura que los elementos se ajusten al ancho
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: color ?? Styles.colorContainer,
              prefixIcon: prefiIcon != null
                  ? Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Image.asset(
                        prefiIcon!,
                        width: 24,
                        height: 24,
                      ),
                    )
                  : null,
              suffixIcon: SizedBox(
                width: 30,
                child: suffixIcon ?? // Usa el sufijo proporcionado
                    Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: Image.asset(
                        'assets/icons/flecha_select.png',
                        width: 24,
                        height: 24,
                      ),
                    ),
              ),
            ),
            hint: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
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
            ),
            items: items,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
