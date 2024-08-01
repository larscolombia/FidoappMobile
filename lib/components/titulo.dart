import 'package:flutter/material.dart';

class Title extends StatelessWidget {
  final String titleScreen;
  // ignore: non_constant_identifier_names
  const Title({super.key, required this.titleScreen});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        child: Text(
          titleScreen,
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
