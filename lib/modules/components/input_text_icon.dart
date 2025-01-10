import 'package:flutter/material.dart';

class InputTextWithIcon extends StatelessWidget {
  const InputTextWithIcon({
    super.key,
    required this.hintText,
    required this.iconPath,
    this.iconPosition = IconPosition.left,
    this.height = 50.0,
    this.controller,
    required this.onChanged,
    this.callbackButton = false,
    this.onButtonPressed,
  });

  final String hintText; // Texto de ayuda dentro del campo
  final String iconPath; // Ruta de la imagen del icono
  final IconPosition iconPosition; // Posición del icono (izquierda o derecha)
  final double height; // Altura del campo de texto
  final TextEditingController? controller; // Controlador opcional para el texto
  final void Function(String)? onChanged;
  final bool callbackButton; // Determina si el botón es habilitado o no
  final void Function()? onButtonPressed; // Callback para el botón

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      height: height,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 0.2),
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Row(
        children: [
          if (iconPosition == IconPosition.left) // Ícono a la izquierda
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Image.asset(
                iconPath,
                width: 24,
                height: 24,
              ),
            ),
          Expanded(
            child: TextField(
              onChanged: onChanged,
              controller: controller,
              style: const TextStyle(
                fontSize: 16,
                fontFamily: 'Lato',
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
              decoration: InputDecoration(
                hintText: hintText,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
              ),
            ),
          ),
          if (iconPosition == IconPosition.right) // Ícono a la derecha
            GestureDetector(
              onTap: callbackButton ? onButtonPressed : null,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Image.asset(
                  iconPath,
                  width: 24,
                  height: 24,
                  color: callbackButton
                      ? null
                      : Colors
                          .grey, // Cambia el color si el botón está deshabilitado
                ),
              ),
            ),
        ],
      ),
    );
  }
}

enum IconPosition { left, right }
