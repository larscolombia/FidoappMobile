import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Texttitleh1 extends StatelessWidget {
  // ignore: non_constant_identifier_names
  late final double size;
  final String Texto;

  Texttitleh1({required this.Texto, this.size = 29});

  @override
  Widget build(BuildContext context) {
    return Text(
      Texto,
      style: TextStyle(
        fontFamily: 'PoetsenOne',
        fontSize: size,
        fontWeight: FontWeight.w400,
        color: Color.fromRGBO(255, 73, 49, 1),
      ),
    );
  }
}
