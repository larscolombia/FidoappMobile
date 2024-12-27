import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:get/get.dart';
import 'dart:io'; // Para manejar archivos locales

class AudioPlayerController extends GetxController {
  final AudioPlayer player = AudioPlayer();
  var isPlaying = false.obs;
  var currentPosition = Duration.zero.obs; // Para mostrar el progreso del audio
  var totalDuration = Duration.zero.obs; // Duración total del audio

  @override
  void onInit() {
    super.onInit();

    // Escuchar los cambios en la posición y la duración del audio
    player.positionStream.listen((pos) {
      currentPosition.value = pos;
    });

    player.durationStream.listen((dur) {
      totalDuration.value = dur ?? Duration.zero;
    });
  }

  // Método para reproducir audio (URL o archivo local)
  Future<void> playAudio(String path) async {
    try {
      if (path.startsWith('http') || path.startsWith('https')) {
        await player.setUrl(path); // Establecer la URL del audio
      } else {
        await player.setFilePath(path); // Establecer archivo local
      }
      player.play(); // Reproducir el audio
      isPlaying.value = true;
    } catch (e) {
      print("Error al reproducir el audio: $e");
    }
  }

  // Método para pausar el audio
  void pauseAudio() {
    player.pause();
    isPlaying.value = false;
  }

  // Método para detener el audio
  void stopAudio() {
    player.stop();
    isPlaying.value = false;
    currentPosition.value = Duration.zero; // Reinicia la posición
  }

  // Método para avanzar y retroceder el audio
  void seekAudio(Duration position) {
    player.seek(position);
  }

  @override
  void onClose() {
    player.dispose(); // Libera los recursos del reproductor
    super.onClose();
  }
}

class AudioPlayerWidget extends StatelessWidget {
  final String audioPath; // Puede ser URL o archivo local

  const AudioPlayerWidget({super.key, required this.audioPath});

  @override
  Widget build(BuildContext context) {
    final AudioPlayerController controller = Get.put(AudioPlayerController());

    // Iniciar la reproducción automática cuando se carga el widget
    controller.playAudio(audioPath);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Reproductor de Audio',
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 20),

          // Controles de reproducción
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.replay_10),
                onPressed: () {
                  final newPosition = controller.currentPosition.value -
                      const Duration(seconds: 10);
                  controller.seekAudio(newPosition >= Duration.zero
                      ? newPosition
                      : Duration.zero);
                },
              ),
              Obx(() {
                return IconButton(
                  icon: Icon(controller.isPlaying.value
                      ? Icons.pause
                      : Icons.play_arrow),
                  iconSize: 50,
                  onPressed: () {
                    if (controller.isPlaying.value) {
                      controller.pauseAudio();
                    } else {
                      controller.playAudio(audioPath); // Reproduce el audio
                    }
                  },
                );
              }),
              IconButton(
                icon: const Icon(Icons.forward_10),
                onPressed: () {
                  final newPosition = controller.currentPosition.value +
                      const Duration(seconds: 10);
                  controller.seekAudio(
                      newPosition <= controller.totalDuration.value
                          ? newPosition
                          : controller.totalDuration.value);
                },
              ),
            ],
          ),

          // Barra de progreso
          Obx(() {
            return Column(
              children: [
                Slider(
                  value: controller.currentPosition.value.inSeconds.toDouble(),
                  max: controller.totalDuration.value.inSeconds.toDouble(),
                  onChanged: (value) {
                    controller.seekAudio(Duration(seconds: value.toInt()));
                  },
                ),
                Text(
                  '${formatDuration(controller.currentPosition.value)} / ${formatDuration(controller.totalDuration.value)}',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            );
          }),

          // Botón de detener
          /*
          IconButton(
            icon: Icon(Icons.stop, size: 40),
            onPressed: controller.stopAudio,
          ),
          */
        ],
      ),
    );
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
}
