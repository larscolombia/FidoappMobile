import 'package:flutter/material.dart';

class CircularAvatarsRow extends StatelessWidget {
  final List<String> imageUrls;

  CircularAvatarsRow({required this.imageUrls});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal, // Habilita desplazamiento horizontal
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        for (var i = 0; i < imageUrls.length; i++)
          Align(
            widthFactor: 0.5,
            child: CircleAvatar(
                radius: 20, backgroundImage: NetworkImage(imageUrls[i])),
          )
      ]),
    );
  }
}
