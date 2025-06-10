import 'package:flutter/material.dart';
import 'package:pawlly/modules/components/input_text.dart';

class InputBusqueda extends StatelessWidget {
  final Function(String) onChanged;

  const InputBusqueda({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return InputText(
      fondoColor: Colors.white,
      placeholderSvg: 'assets/icons/svg/search-status.svg',
      placeholderFontFamily: 'lato',
      borderColor: const Color(0xffE8E8E8),
      placeholder: 'Realiza tu búsqueda',
      placeHolderColor: true,
      onChanged: onChanged,
    );
  }
}
