import 'package:flutter/material.dart';

import 'style.dart';

class SeleccionarMascota extends StatelessWidget {
  final String? name;
  final String? edad;
  final String? avatar;
  const SeleccionarMascota({super.key, this.name, this.edad, this.avatar});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 350,
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black,
            width: .1,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius:
                      22, // Aumentamos el radio para que el borde se vea bien
                  backgroundColor: Color(0xFFFF4931), // Color del borde
                  child: CircleAvatar(
                    radius: 20, // Radio original de la imagen
                    backgroundImage: NetworkImage('$avatar'),
                    backgroundColor: Colors.transparent,
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      '$name',
                      style: const TextStyle(
                        fontFamily: 'PoetsenOne',
                        fontWeight: FontWeight.w400,
                        fontSize: 20,
                        color: Color(0xFFFF4931),
                      ),
                    ),
                    Text(
                      '$edad',
                      style: const TextStyle(
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              weight: 20,
              color: Styles.iconColor,
            ),
          ],
        ),
      ),
    );
  }
}
