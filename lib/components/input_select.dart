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
    final List<DropdownMenuItem<String>> formattedItems =
        items.asMap().entries.map((entry) {
      final int index = entry.key;
      final DropdownMenuItem<String> item = entry.value;
      final bool isFirst = index == 0;
      final bool isLast = index == items.length - 1;

      return DropdownMenuItem<String>(
          value: item.value,
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white, // Fondo del primer ítem
                  borderRadius: BorderRadius.vertical(
                    top: isFirst ? const Radius.circular(16) : Radius.zero,
                    bottom: isLast ? const Radius.circular(16) : Radius.zero,
                  ),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                ),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        item.child is Text
                            ? (item.child as Text).data ?? ''
                            : '',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Lato',
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (!isLast)
                Divider(
                  color: Colors.black.withOpacity(0.2),
                  thickness: 1,
                  height: 0,
                ),
            ],
          ));
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label ?? '',
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF383838),
            fontFamily: 'Lato',
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.sizeOf(context).width * 0.90,
          ),
          child: ButtonTheme(
            alignedDropdown: true,
            minWidth: 200, // Ajusta el ancho del menú desplegable
            child: DropdownButtonFormField<String>(
              icon: const SizedBox.shrink(),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(
                    color: Color(0xFFFCBA67),
                    width: 1,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(
                    color: Color(0xFFFCBA67),
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(
                    color: Color(0xFFFCBA67),
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
                        padding: const EdgeInsets.all(18),
                        child: SvgPicture.asset(
                          'assets/icons/svg/flecha_select.svg',
                          width: 24,
                          height: 24,
                        ),
                      ),
                ),
              ),
              items: formattedItems,
              onChanged: onChanged,
              dropdownColor: Colors.white,
              elevation: 4,
              selectedItemBuilder: (BuildContext context) {
                return items.map((DropdownMenuItem<String> item) {
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      item.child is Text ? (item.child as Text).data ?? '' : '',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Lato',
                        color: Colors.black,
                      ),
                    ),
                  );
                }).toList();
              },
            ),
          ),
        ),
      ],
    );
  }
}
