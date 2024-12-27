import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pawlly/modules/home/screens/widgets/audio_player.dart';
import 'package:pawlly/styles/styles.dart';

class Utilities extends StatelessWidget {
  const Utilities({super.key});

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
                },
                child: Container(
                  height: 90,
                  decoration: BoxDecoration(
                    color: Styles.fiveColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.volume_up, // Ícono correspondiente a 'Whistle'
                        size: 34,
                        color: Styles.iconColorBack,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Whistle',
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
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.pets, // Ícono correspondiente a 'Leash'
                        size: 34,
                        color: Styles.iconColorBack,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Leash',
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
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.music_note, // Ícono correspondiente a 'Clicker'
                        size: 34,
                        color: Styles.iconColorBack,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Clicker',
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
          ],
        ),
      ],
    );
  }
}
