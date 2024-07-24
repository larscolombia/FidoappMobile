import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pawlly/styles/styles.dart';

class ButtonDefault extends StatelessWidget {
  final String title;
  final VoidCallback callback;
  final Color defaultColor; // Color de fondo predeterminado
  final MaterialStateProperty<Color>?
      color; // Permitir sobreescribir el color de fondo
  final Color textColor; // Color del texto
  final BorderSide? border; // Borde del botón
  final double heigthButtom;
  final double? widthButtom;
  const ButtonDefault({
    Key? key,
    this.widthButtom,
    this.heigthButtom = 56,
    required this.title,
    required this.callback,
    this.defaultColor = Styles.primaryColor, // Color de fondo predeterminado
    this.color,
    this.textColor = Styles.whiteColor, // Color del texto predeterminado
    this.border, // Borde del botón
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
                : null, // Configurar el borde
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16), // Bordes cuadrados
              ),
            ),
          ),
          onPressed: callback,
          child: Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}
