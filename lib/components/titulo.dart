import 'package:flutter/material.dart';

class Titulo extends StatelessWidget {
  final String TituloScreen;
  // ignore: non_constant_identifier_names
  const Titulo({super.key, required this.TituloScreen});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        child: Text(
          TituloScreen,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Color.fromRGBO(255, 73, 49, 1),
            fontSize: 34,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    ]);
  }
}
