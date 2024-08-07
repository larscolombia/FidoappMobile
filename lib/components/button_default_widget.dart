import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pawlly/styles/styles.dart';

class ButtonDefaultWidget extends StatelessWidget {
  final String title;
  final VoidCallback callback;
  final Color defaultColor; // Color de fondo predeterminado
  final MaterialStateProperty<Color>?
      color; // Permitir sobreescribir el color de fondo
  final Color textColor; // Color del texto
  final BorderSide? border; // Borde del botón
  final double heigthButtom;
  final double? widthButtom;
  final double? textSize;
  final double? borderSize;
  final IconData? icon; // Icono opcional
  final bool
      iconAfterText; // Posición del icono: verdadero para después del texto, falso para antes

  const ButtonDefaultWidget({
    Key? key,
    this.widthButtom,
    this.heigthButtom = 56,
    required this.title,
    required this.callback,
    this.defaultColor = Styles.primaryColor, // Color de fondo predeterminado
    this.color,
    this.textColor = Styles.whiteColor, // Color del texto predeterminado
    this.border, // Borde del botón
    this.textSize,
    this.borderSize,
    this.icon, // Icono opcional
    this.iconAfterText = true, // Por defecto, el icono está después del texto
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final resolvedColor = color ?? MaterialStateProperty.all(defaultColor);
    final width = MediaQuery.of(context).size.width;
    return Container(
      child: SizedBox(
        width: widthButtom ?? width,
        height: heigthButtom,
        child: TextButton(
          style: ButtonStyle(
            backgroundColor: resolvedColor,
            side: border != null
                ? MaterialStateProperty.all(border)
                : MaterialStateProperty.all(
                    BorderSide.none), // Configurar el borde
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(borderSize ?? 16), // Bordes cuadrados
              ),
            ),
          ),
          onPressed: callback,
          child: icon == null
              ? Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: textSize ?? 16,
                    fontWeight: FontWeight.w500,
                    color: textColor,
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: iconAfterText
                      ? [
                          Text(
                            title,
                            style: GoogleFonts.poppins(
                              fontSize: textSize ?? 16,
                              fontWeight: FontWeight.w500,
                              color: textColor,
                            ),
                          ),
                          SizedBox(width: 8), // Espacio entre texto e icono
                          Icon(
                            icon,
                            color: textColor,
                          ),
                        ]
                      : [
                          Icon(
                            icon,
                            color: textColor,
                          ),
                          SizedBox(width: 8), // Espacio entre icono y texto
                          Text(
                            title,
                            style: GoogleFonts.poppins(
                              fontSize: textSize ?? 16,
                              fontWeight: FontWeight.w500,
                              color: textColor,
                            ),
                          ),
                        ],
                ),
        ),
      ),
    );
  }
}
