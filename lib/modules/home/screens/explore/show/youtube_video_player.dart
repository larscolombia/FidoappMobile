import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YouTubeVideoPlayer extends StatefulWidget {
  final String videoUrl;

  const YouTubeVideoPlayer({super.key, required this.videoUrl});

  @override
  State<YouTubeVideoPlayer> createState() => _YouTubeVideoPlayerState();
}

class _YouTubeVideoPlayerState extends State<YouTubeVideoPlayer> {
  late YoutubePlayerController _controller;
  late bool failVideoId = false;
  late String? videoId;

  @override
  void initState() {
    // Debug: Imprimir información detallada de la URL recibida
    print('=== YOUTUBE VIDEO PLAYER DEBUG ===');
    print('URL recibida: "${widget.videoUrl}"');
    print('Longitud de la URL: ${widget.videoUrl.length}');
    print('¿URL está vacía?: ${widget.videoUrl.isEmpty}');
    print('¿URL es solo espacios?: ${widget.videoUrl.trim().isEmpty}');
    
    // Verificar si la URL está vacía o es nula
    if (widget.videoUrl.isEmpty || widget.videoUrl.trim().isEmpty) {
      print('YouTubeVideoPlayer - URL vacía detectada');
      failVideoId = true;
      videoId = null;
    } else {
      videoId = YoutubePlayer.convertUrlToId(widget.videoUrl);
      print('YouTubeVideoPlayer - Video ID extraído: $videoId');
      failVideoId = videoId == null;
    }

    if (failVideoId) {
      print('YouTubeVideoPlayer - Fallback a video placeholder');
      // Se agrega video placeholder para evitar que el controlador falle.
      // el video no se mostrará, se usa para evitar que falle el controlador.
      videoId = YoutubePlayer.convertUrlToId('https://www.youtube.com/watch?v=ScMzIvxBSi4');
    }
    
    print('YouTubeVideoPlayer - Video ID final: $videoId');
    print('YouTubeVideoPlayer - ¿Falló la carga?: $failVideoId');
    
    _controller = YoutubePlayerController(
      initialVideoId: videoId!,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
        loop: true,
      ),
    );

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (failVideoId) {
      return Container(
        color: Colors.grey[200],
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.videocam_off_outlined, color: Colors.redAccent, size: 50),
              Text('No se pudo cargar el video.'),
              SizedBox(height: 8),
              Text(
                'URL del video no disponible',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

    return YoutubePlayer(
      controller: _controller,
      showVideoProgressIndicator: true,
      progressIndicatorColor: Colors.red,
      progressColors: const ProgressBarColors(
        playedColor: Colors.red,
        handleColor: Colors.redAccent,
      ),
      // Configuraciones adicionales para mejor comportamiento durante scroll
      bufferIndicator: const CircularProgressIndicator(),
      onReady: () {
        // El video está listo para reproducirse
        print('YouTube video ready to play');
      },
      onEnded: (YoutubeMetaData metaData) {
        // El video ha terminado
        print('YouTube video ended');
      },
    );
  }
}
