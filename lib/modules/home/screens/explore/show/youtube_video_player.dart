import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'dart:io' show Platform;

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
        hideControls: false,
        controlsVisibleAtStart: true,
        enableCaption: true,
        captionLanguage: 'es',
        forceHD: false,
        startAt: 0,
        // Deshabilitamos fullscreen nativo (ocultaremos su botón)
        disableDragSeek: false,
      ),
    );

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _openCustomFullScreen() {
    // Aseguramos orientación portrait para no rotar la app completa.
    SystemChrome.setPreferredOrientations(const [DeviceOrientation.portraitUp]);
    // Oculta status bar temporalmente
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    Navigator.of(context).push(PageRouteBuilder(
      opaque: false,
      barrierColor: Colors.black,
      pageBuilder: (_, __, ___) {
        return Scaffold(
          backgroundColor: Colors.black,
          body: SafeArea(
            child: Stack(
              children: [
                Positioned.fill(
                  child: Center(
                    child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: YoutubePlayer(
                        controller: _controller,
                        showVideoProgressIndicator: true,
                        progressIndicatorColor: Colors.red,
                        progressColors: const ProgressBarColors(
                          playedColor: Colors.red,
                          handleColor: Colors.redAccent,
                        ),
                        bottomActions: [
                          const SizedBox(width: 8),
                          CurrentPosition(),
                          const SizedBox(width: 8),
                          ProgressBar(isExpanded: true),
                          const PlaybackSpeedButton(),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    )).whenComplete(() {
      // Restaurar UI system y mantener portrait
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setPreferredOrientations(const [DeviceOrientation.portraitUp]);
    });
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

    return Stack(
      alignment: Alignment.topRight,
      children: [
        YoutubePlayer(
          controller: _controller,
          showVideoProgressIndicator: true,
          progressIndicatorColor: Colors.red,
          progressColors: const ProgressBarColors(
            playedColor: Colors.red,
            handleColor: Colors.redAccent,
          ),
          // Quitamos botón fullscreen nativo reemplazando bottomActions
          bottomActions: [
            const SizedBox(width: 8),
            CurrentPosition(),
            const SizedBox(width: 8),
            ProgressBar(isExpanded: true),
            const PlaybackSpeedButton(),
          ],
          onReady: () {
            debugPrint('YouTube video ready');
          },
          onEnded: (meta) {
            debugPrint('YouTube video ended');
          },
        ),
        // Botón custom de fullscreen
        Positioned(
          top: 4,
            right: 4,
            child: IconButton(
              icon: const Icon(Icons.fullscreen, color: Colors.white),
              onPressed: _openCustomFullScreen,
              tooltip: 'Pantalla completa',
            ),
        ),
      ],
    );
  }
}
