import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pawlly/components/button_default_widget.dart';
import 'package:pawlly/styles/styles.dart';

class CustomAlertDialog extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final String? primaryButtonText; // Texto del primer botón (opcional)
  final VoidCallback?
      onPrimaryButtonPressed; // Acción del primer botón (opcional)
  final String? secondaryButtonText; // Texto del segundo botón (opcional)
  final VoidCallback?
      onSecondaryButtonPressed; // Acción del segundo botón (opcional)

  CustomAlertDialog({
    required this.icon,
    required this.title,
    required this.description,
    this.primaryButtonText,
    this.onPrimaryButtonPressed,
    this.secondaryButtonText,
    this.onSecondaryButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white, // Fondo blanco
      contentPadding: EdgeInsets.all(20),
      title: Column(
        children: [
          Icon(
            icon,
            size: 50,
            color: Colors.blue, // Cambia el color si lo deseas
          ),
          SizedBox(height: 10),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(description),
          if (primaryButtonText != null || secondaryButtonText != null) ...[
            SizedBox(height: 20),
            Divider(), // Línea divisoria
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (primaryButtonText != null)
                  Expanded(
                    child: ButtonDefaultWidget(
                      title: primaryButtonText!,
                      callback: onPrimaryButtonPressed ?? () {},
                      defaultColor:
                          Styles.primaryColor, // Color de fondo del botón
                      textColor: Styles.whiteColor, // Color del texto del botón
                      heigthButtom: 48, // Altura del botón
                      borderSize: 12, // Tamaño del borde
                    ),
                  ),
                if (secondaryButtonText != null) ...[
                  SizedBox(width: 10), // Espacio entre los botones
                  Expanded(
                    child: ButtonDefaultWidget(
                      title: secondaryButtonText!,
                      callback: onSecondaryButtonPressed ?? () {},
                      defaultColor:
                          Styles.primaryColor, // Color de fondo del botón
                      textColor: Styles.whiteColor, // Color del texto del botón
                      heigthButtom: 48, // Altura del botón
                      borderSize: 12, // Tamaño del borde
                    ),
                  ),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }
}
