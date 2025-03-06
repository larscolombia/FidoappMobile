import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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
  final List<DropdownMenuItem<String>> items;
  final Color? TextColor;
  final Color? color;
  final Icon? suffixIcon;
  final String? prefiIcon;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label ?? '',
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFF383838),
            fontFamily: 'Lato',
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
          ),
          child: Theme(
            data: Theme.of(context).copyWith(
              canvasColor: Colors.white,
              dropdownMenuTheme: DropdownMenuThemeData(
                menuStyle: MenuStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: const BorderSide(
                        color: Color(0xFFFCBA67),
                        width: 1,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            child: DropdownButtonFormField<String>(
              icon: const SizedBox.shrink(), // Elimina la flecha desplegable
              isExpanded: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(
                    color: Color(0xFFFCBA67), // Color del borde
                    width: 1, // Grosor del borde
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(
                    color: Color(
                        0xFFFCBA67), // Color del borde cuando no está seleccionado
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(
                    color: Color(
                        0xFFFCBA67), // Color del borde cuando está seleccionado
                    width: 1,
                  ),
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
                  child: suffixIcon ??
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 18, right: 18, top: 18, bottom: 18),
                        child: SvgPicture.asset(
                          'assets/icons/svg/flecha_select.svg',
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
                    color:
                        TextColor ?? const Color.fromARGB(255, 252, 252, 252),
                    fontFamily: 'Lato',
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
              items: items,
              onChanged: onChanged,
              dropdownColor: Colors.white,
              elevation: 4,
            ),
          ),
        ),
      ],
    );
  }
}
