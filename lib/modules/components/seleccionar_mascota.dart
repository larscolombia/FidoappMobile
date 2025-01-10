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
                  radius: 20,
                  backgroundImage: NetworkImage('$avatar'),
                  backgroundColor: Colors.transparent,
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 20,
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
                      style: Styles.AvatarPetName,
                    ),
                    Text(
                      '$edad',
                      style: Styles.textNameAvatar,
                    ),
                  ],
                ),
              ],
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              weight: 24,
              color: Styles.iconColor,
            ),
          ],
        ),
      ),
    );
  }
}
