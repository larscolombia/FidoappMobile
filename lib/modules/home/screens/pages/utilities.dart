import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:pawlly/modules/integracion/controller/soun/soun_controller.dart';

import 'package:pawlly/modules/home/screens/widgets/audio_player.dart';
import 'package:pawlly/styles/styles.dart';

class Utilities extends StatelessWidget {
  Utilities({super.key});
  SounController sounController = Get.put(SounController());
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Utilidades',
          style: TextStyle(
            fontSize: 20,
            color: Styles.primaryColor,
            fontFamily: 'PoetsenOne',
          ),
          textAlign: TextAlign.left,
        ),
        const SizedBox(height: 10),
        // Cuadros con íconos y textos
        Row(
          children: [
            // Cuadro 1
            Expanded(
              child: GestureDetector(
                onTap: () async {
                  print("click");
                  sounController.silbato();
                },
                child: Container(
                  height: 93,
                  width: 94,
                  decoration: BoxDecoration(
                    color: Styles.fiveColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/icons/silbar.png',
                      ),
                      SizedBox(height: 8),
                      const Text(
                        'Silbar',
                        style: TextStyle(
                          fontFamily: 'Lato',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Styles.greyTextColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12), // Espacio entre los cuadros
            // Cuadro 2
            Expanded(
              child: GestureDetector(
                onTap: () {
                  // Abre el modal para reproducir audio
                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      // Aquí colocas el widget de reproducción de audio con la ruta proporcionada
                      return AudioPlayerWidget(
                          audioPath:
                              'soun/silbato.mp3'); // Ejemplo de ruta local
                    },
                  );
                }, // Acción al tocar el cuadro
                child: Container(
                  height: 90,
                  decoration: BoxDecoration(
                    color: Styles.fiveColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/icons/Correa.png'),
                      SizedBox(height: 8),
                      const Text(
                        'Correa',
                        style: TextStyle(
                          fontFamily: 'Lato',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Styles.greyTextColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12), // Espacio entre los cuadros
            // Cuadro 3
            Expanded(
              child: GestureDetector(
                onTap: () {
                  // Abre el modal para reproducir audio
                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      // Aquí colocas el widget de reproducción de audio con la ruta proporcionada
                      return AudioPlayerWidget(
                          audioPath:
                              'soun/silbato.mp3'); // Ejemplo de ruta local
                    },
                  );
                }, // Acción al tocar el cuadro
                child: Container(
                  height: 90,
                  decoration: BoxDecoration(
                    color: Styles.fiveColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/icons/tecontador.png'),
                      SizedBox(height: 8),
                      Text(
                        'Taconeador',
                        style: Styles.homeBoxTextSubTitle,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
