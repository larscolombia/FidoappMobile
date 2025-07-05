import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pawlly/modules/components/style.dart';

class SelectedAvatar extends StatelessWidget {
  final String? nombre;
  final String? imageUrl;
  final String? profesion;
  final double? width;
  final bool showArrow;

  const SelectedAvatar({
    super.key, 
    this.imageUrl, 
    this.nombre, 
    this.profesion, 
    this.width,
    this.showArrow = true,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      // Usamos LayoutBuilder para responsividad
      builder: (context, constraints) {
        return Container(
          width: width ??
              constraints.maxWidth, // Ancho adaptable al padre o al ancho dado
          height: 85,
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFFEFEFEF),
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
                    width:
                        44, // Tamaño fijo del avatar, no necesita ser responsive en este caso
                    height: 44,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFFFC9214)
                            .withOpacity(0.6), // Borde del avatar
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
                        width: constraints.maxWidth *
                            0.4, // Ancho del texto responsive, ajusta el factor según necesites (0.4 = 40% del ancho disponible)
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
              if (showArrow)
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: SizedBox(
                    // Usamos SizedBox para controlar el tamaño del icono de flecha si es necesario
                    width: 24, // Ancho fijo para el icono, puedes ajustarlo
                    height: 24, // Alto fijo para el icono, puedes ajustarlo
                    child:
                        SvgPicture.asset('assets/icons/svg/flecha_derecha.svg'),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
