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
    this.TextColor,
    this.value,
    this.isReadOnly = false,
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
  final bool isReadOnly;

  @override
  Widget build(BuildContext context) {
    final List<DropdownMenuItem<String>> formattedItems = items.map((item) {
      return DropdownMenuItem<String>(
        value: item.value,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Color(0xFFF0F0F0)),
            ),
          ),
          child: item.child,
        ),
      );
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (label != null)
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
        Theme(
          data: Theme.of(context).copyWith(
            popupMenuTheme: PopupMenuThemeData(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: Colors.red, width: 1),
              ),
            ),
          ),
          child: IgnorePointer(
            // Wrap DropdownButtonFormField with IgnorePointer
            ignoring: isReadOnly, // Disable interaction when isReadOnly is true
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.90,
              ),
              child: DropdownButtonFormField<String>(
                value: value,
                icon: const SizedBox.shrink(),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                      color:
                          value != null ? Colors.blue : const Color(0xFFFCBA67),
                      width: 1,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                      color:
                          value != null ? Colors.blue : const Color(0xFFFCBA67),
                      width: 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                      color:
                          value != null ? Colors.blue : const Color(0xFFFCBA67),
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
                hint: Padding(
                  padding: const EdgeInsets.only(left: 8),
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
                items: formattedItems,
                onChanged: isReadOnly ? null : onChanged,
                dropdownColor: Colors.white,
                elevation: 4,
                selectedItemBuilder: (BuildContext context) {
                  return formattedItems.map((DropdownMenuItem<String> item) {
                    return Align(
                      alignment: Alignment.centerLeft,
                      child: item.child,
                    );
                  }).toList();
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
