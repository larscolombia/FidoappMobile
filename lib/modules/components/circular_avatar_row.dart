import 'package:flutter/material.dart';

class CircularAvatarsRow extends StatelessWidget {
  final List<String> imageUrls;

  CircularAvatarsRow({required this.imageUrls});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal, // Habilita desplazamiento horizontal
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (var i = 0; i < imageUrls.length; i++)
            Align(
              widthFactor: 0.5,
              child: Container(
                padding: EdgeInsets.all(1), // Agrega padding para el borde
                decoration: BoxDecoration(
                  shape: BoxShape.circle, // Hace que el contenedor sea circular
                  border: Border.all(
                    color: Colors.white, // Color del borde
                    width: 1, // Ancho del borde
                  ),
                ),
                child: CircleAvatar(
                  radius: 20, // Tamaño del avatar
                  backgroundImage: NetworkImage(imageUrls[i]),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
