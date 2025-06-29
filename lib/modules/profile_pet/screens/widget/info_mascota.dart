import 'package:flutter/material.dart';

class InfoMascota extends StatelessWidget {
  const InfoMascota({
    super.key,
    this.titulo,
    this.value,
  });

  final String? titulo;
  final String? value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: const BoxDecoration(
          border: Border(
        bottom: BorderSide(
          color: Color(0xffEFEFEF),
          width: .5,
        ),
      )),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titulo ?? "",
            style: const TextStyle(
              color: Colors.black,
              fontFamily: 'Lato',
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
          Text(
            value ?? "",
            style: const TextStyle(
              color: Colors.black,
              fontFamily: 'Lato',
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
