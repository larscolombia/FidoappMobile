import 'package:get/get.dart';
import 'package:pawlly/configs.dart';
import 'package:soundpool/soundpool.dart';
import 'package:http/http.dart' as http;
import 'dart:typed_data';

class SounController extends GetxController {
  final Soundpool pool = Soundpool(streamType: StreamType.notification);
  var progress = 0.0.obs;

  Future<void> urlSound(String url) async {
    try {
      print('sound url: ${DOMAIN_URL}/$url');
      // Descargar el sonido
      final soundData = await _downloadSound("${DOMAIN_URL}/$url");

      // Cargar y reproducir el sonido
      int soundId = await pool.loadUint8List(soundData);
      await pool.play(soundId);

      // Simula progreso
      for (var i = 1; i <= 10; i++) {
        await Future.delayed(const Duration(milliseconds: 200));
        progress.value = i / 10;
      }
    } catch (e) {
      print("Error al reproducir el sonido: $e");
    }
  }

  Future<Uint8List> _downloadSound(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception("Error al descargar el sonido");
    }
  }

  @override
  void onClose() {
    pool.release();
    super.onClose();
  }
}
