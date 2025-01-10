import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:soundpool/soundpool.dart';

class SounController extends GetxController {
  // Método público (sin guion bajo)
  void silbato() async {
    Soundpool pool = Soundpool(streamType: StreamType.notification);

    try {
      int soundId = await rootBundle
          .load("assets/soun/silbato.mp3")
          .then((ByteData soundData) {
        return pool.load(soundData);
      });
      await pool.play(soundId);
    } catch (e) {
      print("Error al reproducir el sonido del silbato: $e");
    }
  }

  // Otro método público
  void clickSound() async {
    Soundpool pool = Soundpool(streamType: StreamType.notification);

    try {
      int soundId = await rootBundle
          .load("assets/soun/click4.mp3")
          .then((ByteData soundData) {
        return pool.load(soundData);
      });
      await pool.play(soundId);
    } catch (e) {
      print("Error al reproducir el sonido del click: $e");
    }
  }
}
