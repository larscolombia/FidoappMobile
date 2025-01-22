import 'package:flutter/material.dart';
import 'package:pawlly/modules/components/style.dart';

class SelectedAvatar extends StatelessWidget {
  final String? nombre;
  final String? imageUrl;
  const SelectedAvatar({super.key, this.imageUrl, this.nombre});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 270,
      height: 75,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.black,
            width: 0.1,
          )),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundImage: NetworkImage(imageUrl ??
                    'https://www.thewall360.com/uploadImages/ExtImages/images1/def-638240706028967470.jpg'),
              ),
              const SizedBox(width: 2),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Text(
                    nombre ?? "",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const Text(''),
                ],
              )
            ],
          ),
          Container(
            child: Image.asset('assets/icons/flecha_derecha.png'),
          )
        ],
      ),
    );
  }
}
