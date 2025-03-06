import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pawlly/components/button_default_widget.dart';
import 'package:pawlly/modules/home/screens/pages/profile_dogs.dart';
import 'package:pawlly/styles/styles.dart';

class CustomAlertDialog extends StatelessWidget {
  final IconData? icon; // Icono opcional
  final String? assetImage; // Imagen desde assets opcional
  final String title;
  final String description;
  final String? primaryButtonText; // Texto del primer botón (opcional)
  final VoidCallback?
      onPrimaryButtonPressed; // Acción del primer botón (opcional)
  final String? secondaryButtonText; // Texto del segundo botón (opcional)
  final VoidCallback?
      onSecondaryButtonPressed; // Acción del segundo botón (opcional)
  final bool buttonCancelar; // Propiedad para mostrar el botón de cerrar modal
  final bool? isSelect;

  const CustomAlertDialog({
    super.key,
    this.icon,
    this.assetImage,
    required this.title,
    required this.description,
    this.primaryButtonText,
    this.onPrimaryButtonPressed,
    this.secondaryButtonText,
    this.onSecondaryButtonPressed,
    this.buttonCancelar = false, // Por defecto es false
    this.isSelect = false,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white, // Fondo blanco
      contentPadding: const EdgeInsets.all(20),
      title: Column(
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 80,
              color: title == 'Éxito'
                  ? Color.fromARGB(255, 5, 158, 31)
                  : const Color(0xFFFF4931),
            ),
            const SizedBox(height: 10),
          ] else if (assetImage != null) ...[
            Image.asset(
              assetImage!,
              height: 80,
              width: 80,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 10),
          ],
          if (title != 'Éxito')
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                fontFamily: 'Lato',
                color: const Color(0xFFFF4931),
              ),
            ),
          if (title == 'Éxito')
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Lato',
                  color: Color.fromARGB(255, 5, 158, 31)),
            ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isSelect == true) ...[
            ProfilesDogs(),
            const SizedBox(height: 10),
          ],
          Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              fontFamily: 'Lato',
              color: Colors.black,
              fontWeight: FontWeight.w400,
            ),
          ),
          if (primaryButtonText != null || secondaryButtonText != null) ...[
            const SizedBox(height: 20),
            const Divider(), // Línea divisoria
            const SizedBox(height: 10),
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
                      showDecoration: true, // Mostrar decoración
                    ),
                  ),
                if (secondaryButtonText != null) ...[
                  const SizedBox(width: 10), // Espacio entre los botones
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
                if (buttonCancelar) ...[
                  const SizedBox(width: 10), // Espacio entre los botones
                  Expanded(
                    child: ButtonDefaultWidget(
                      title: 'Cancelar',
                      callback: () {
                        Navigator.of(context).pop();
                      },
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
