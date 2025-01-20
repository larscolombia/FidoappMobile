import 'package:flutter/material.dart';
import 'package:pawlly/modules/components/input_text.dart';

class InputBusqueda extends StatelessWidget {
  final Function(String) onChanged;
  const InputBusqueda({super.key, required this.onChanged});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return InputText(
      fondoColor: Colors.white,
      placeholderImage: Image.asset('assets/icons/busqueda.png'),
      placeholderFontFamily: 'lato',
      borderColor: Color(0xffE8E8E8),
      placeholder: 'Realiza tu búsqueda',
      onChanged: onChanged,
    );
  }
  // ignore: non_constant_identifier_names
}
