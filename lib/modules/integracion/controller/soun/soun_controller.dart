import 'package:get/get.dart';
import 'package:pawlly/configs.dart';
import 'package:just_audio/just_audio.dart';
import 'package:http/http.dart' as http;
import 'dart:typed_data';

class SounController extends GetxController {
  final AudioPlayer _player = AudioPlayer();
  var progress = 0.0.obs;
  var isPlaying = false.obs;

  Future<void> urlSound(String url) async {
    try {
      final fullUrl = "${DOMAIN_URL}/$url";
      print('sound url: $fullUrl');

      // Cancelar reproducción previa
      await _player.stop();
      progress.value = 0.0;
      isPlaying.value = true;

      // Cargar y reproducir streaming directo (no necesitamos descargar manualmente)
      await _player.setUrl(fullUrl);
      _player.play();

      // Escuchar progreso simple (se limita para evitar demasiadas notificaciones)
      final duration = await _player.durationFuture;
      if (duration != null) {
        _player.positionStream.listen((pos) {
          final totalMs = duration.inMilliseconds;
          if (totalMs > 0) {
            progress.value = (pos.inMilliseconds / totalMs).clamp(0, 1);
          }
        });
      }

      // Esperar a que termine
      _player.playerStateStream.firstWhere((s) => s.processingState == ProcessingState.completed).then((_) {
        isPlaying.value = false;
        progress.value = 1.0;
      });
    } catch (e) {
      isPlaying.value = false;
      print("Error al reproducir el sonido: $e");
    }
  }

  // Conservamos el método de descarga por si se necesita en el futuro (no usado actualmente)
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
    _player.dispose();
    super.onClose();
  }
}
