import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pawlly/components/button_default_widget.dart';
import 'package:pawlly/generated/assets.dart';
import 'package:pawlly/styles/styles.dart';

class Explore extends StatelessWidget {
  const Explore({super.key});

  @override
  Widget build(BuildContext context) {
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
            child: Container(
              width: 127,
              height: Get.height,
              decoration: BoxDecoration(),
              child: Align(
                alignment: Alignment.bottomRight,
                child: Image.asset(
                  Assets.elice,
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            bottom: 0,
            right: 0,
            child: Image.asset(
              'assets/images/pet_care.png',
              fit: BoxFit.cover,
            ),
          ),
          // Contenedor de texto y botón al frente
          Padding(
            padding: const EdgeInsets.only(left: 22, top: 15, bottom: 15),
            child: Row(
              children: [
                // Texto y botón ocupando el 60% del ancho
                Container(
                  width: Get.width * 0.6, // 60% del ancho total
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min, // Ajuste dinámico en altura
                    children: [
                      // Texto principal
                      Text(
                        'Recomendaciones para tu Mascota',
                        style: TextStyle(
                          fontFamily: 'Lato',
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Styles.whiteColor,
                        ),
                      ),
                      SizedBox(height: 8),
                      // Subtítulo
                      Text(
                        'Consejos y recursos útiles',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontFamily: 'Lato',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Styles.whiteColor,
                        ),
                      ),
                      SizedBox(height: 10),
                      // Botón para explorar
                      ButtonDefaultWidget(
                        title: 'Explorar',
                        callback: () {},
                        widthButtom: 97,
                        heigthButtom: 40,
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
