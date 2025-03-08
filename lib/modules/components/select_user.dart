import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pawlly/modules/components/style.dart';

class SelectedAvatar extends StatelessWidget {
  final String? nombre;
  final String? imageUrl;
  final String? profesion;
  final double? width;

  const SelectedAvatar(
      {super.key, this.imageUrl, this.nombre, this.profesion, this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? MediaQuery.of(context).size.width,
      height: 85,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Color(0xFFEFEFEF),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Contenedor para el avatar con el borde
              Container(
                width: 44, // Tamaño total del avatar + borde
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color:
                        Color(0xFFFC9214).withOpacity(0.6), // Borde del avatar
                    width: 2, // Grosor del borde
                  ),
                ),
                child: CircleAvatar(
                  radius: 22, // Radio de la imagen dentro del contenedor
                  backgroundImage: NetworkImage(imageUrl ??
                      'https://www.thewall360.com/uploadImages/ExtImages/images1/def-638240706028967470.jpg'),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  SizedBox(
                    width: 164.0,
                    child: Text(
                      nombre ?? "",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Text(
                    profesion ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Styles.primaryColor,
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: Container(
              child: SvgPicture.asset('assets/icons/svg/flecha_derecha.svg'),
            ),
          ),
        ],
      ),
    );
  }
}
