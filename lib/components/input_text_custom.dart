import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

///felix@gmail.com email
///12345678
class CustomTextFormField extends StatelessWidget {
  final String pleholder;
  final String icon;
  final TextEditingController? controller;
  CustomTextFormField(
      {super.key,
      required this.pleholder,
      required this.icon,
      required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        filled: true, // Agrega un fondo al TextFormField
        border: InputBorder.none,
        fillColor: Color.fromRGBO(254, 247, 229, 1), // Color de fondo
        prefixIcon: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            icon,
            width: 20,
            height: 20,
          ),
        ),
        labelText: pleholder,
        labelStyle: TextStyle(
          color: Color.fromRGBO(136, 136, 136, 1),
        ),
      ),
    );
  }
}
