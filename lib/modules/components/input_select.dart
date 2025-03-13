import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
    this.prefiIconSVG,
    this.TextColor,
    this.value,
    this.isReadOnly = false,
    this.borderColor,
  });

  final String? placeholder;
  final String? label;
  final String? value;
  final ValueChanged<String?> onChanged;
  final List<DropdownMenuItem<String>> items;
  final Color? TextColor;
  final Color? color;
  final Icon? suffixIcon;
  final String? prefiIcon;
  final String? prefiIconSVG;
  final bool isReadOnly;
  final Color? borderColor;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (label != null)
          Text(
            label!,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF383838),
              fontFamily: 'Lato',
              fontWeight: FontWeight.w500,
            ),
          ),
        const SizedBox(height: 8),
        Theme(
          // Wrap with Theme to style the modal
          data: Theme.of(context).copyWith(
            popupMenuTheme: PopupMenuThemeData(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.1),
                side: const BorderSide(
                  color: Styles.iconColorBack, // Modal border color
                  width: 1.5,
                ),
              ),
            ),
          ),
          child: IgnorePointer(
            ignoring: isReadOnly,
            child: DropdownButtonFormField<String>(
              value: items.any((item) => item.value == value) ? value : null,
              isExpanded: true,
              icon: const Icon(Icons.arrow_drop_down,
                  color: Styles.colorContainer),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: borderColor ?? Styles.iconColorBack,
                    width: 0.1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  // Focused border style
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(
                    color: Styles.iconColorBack, // Focused border color
                    width: 1.5,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  // Enabled border style
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(
                    color: Styles.colorContainer, // Enabled border color
                    width: 0.5,
                  ),
                ),
                filled: true,
                fillColor: color ?? Styles.colorContainer,
                prefixIcon: prefiIconSVG != null
                    ? Padding(
                        padding: const EdgeInsets.only(left: 20, right: 5),
                        child: SizedBox(
                          width: 24,
                          height: 24,
                          child: SvgPicture.asset(prefiIconSVG!),
                        ),
                      )
                    : prefiIcon != null
                        ? Padding(
                            padding: const EdgeInsets.only(left: 20, right: 5),
                            child: Image.asset(
                              prefiIcon!,
                              width: 24,
                              height: 24,
                            ),
                          )
                        : null,
                suffixIcon: suffixIcon ??
                    Padding(
                      padding: const EdgeInsets.all(18),
                      child: SvgPicture.asset(
                        'assets/icons/svg/flecha_select.svg',
                        width: 1,
                        height: 5,
                      ),
                    ),
              ),
              hint: Text(
                placeholder ?? 'Seleccione una opción',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: TextColor ?? Colors.grey,
                  fontFamily: 'Lato',
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              items: items.map((DropdownMenuItem<String> item) {
                return DropdownMenuItem<String>(
                  value: item.value,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: item.child,
                  ),
                );
              }).toList(),
              onChanged: isReadOnly ? null : onChanged,
              dropdownColor: Colors.white,
              elevation: 4,
            ),
          ),
        ),
      ],
    );
  }
}
