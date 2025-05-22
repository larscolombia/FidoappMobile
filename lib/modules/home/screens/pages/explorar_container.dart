import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pawlly/components/button_default_widget.dart';
import 'package:pawlly/generated/assets.dart';
import 'package:pawlly/styles/styles.dart';

class Explore extends StatelessWidget {
  const Explore({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = Get.width;
    final screenHeight = Get.height;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Styles.tertiaryColor,
      ),
      child: Stack(
        children: [
          // Imágenes en el fondo
          Positioned(
            top: 0,
            bottom: 0,
            right: 0,
            child: SizedBox(
              width: screenWidth * 0.3,
              height: screenHeight,
              child: Align(
                alignment: Alignment.bottomRight,
                child: Image.asset(
                  Assets.elice,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            bottom: 0,
            right: 0,
            child: SizedBox(
              width: screenWidth * 0.5,
              height: screenHeight,
              child: Align(
                alignment: Alignment.bottomRight,
                child: Image.asset(
                  'assets/images/pet_care.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          // Contenedor de texto y botón al frente
          Padding(
            padding: const EdgeInsets.only(left: 22, top: 15, bottom: 15),
            child: Row(
              children: [
                // Texto y botón occupying a percentage of the width
                SizedBox(
                  width: screenWidth * 0.5, // Increased width to accommodate potentially longer text
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min, // Adjust height dynamically
                    children: [
                      // Texto principal
                      const Text(
                        'Recomendaciones para tu Mascota',
                        style: TextStyle(
                          fontFamily: 'Lato',
                          fontSize: 16,
                          height: 1.2,
                          fontWeight: FontWeight.bold,
                          color: Styles.whiteColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      // Subtítulo
                      const Text(
                        'Consejos y recursos útiles',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontFamily: 'Lato',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Styles.whiteColor,
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Botón para explorar
                      SizedBox(
                        width: screenWidth * 0.32,
                        height: 34,
                        child: ButtonDefaultWidget(
                          textSize: 13,
                          title: 'Explorar >',
                          callback: () {},
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
