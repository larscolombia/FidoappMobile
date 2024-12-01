import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWithControls extends StatefulWidget {
  final String videoUrl;

  VideoPlayerWithControls({required this.videoUrl});

  @override
  _VideoPlayerWithControlsState createState() =>
      _VideoPlayerWithControlsState();
}

class _VideoPlayerWithControlsState extends State<VideoPlayerWithControls> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    // Inicializamos el controlador con la URL del video
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {}); // Actualizamos la UI cuando el video esté inicializado
      }).catchError((error) {
        // Manejar errores de inicialización
        print('Error inicializando video: $error');
      });
  }

  @override
  void dispose() {
    // Liberamos el controlador cuando el widget se deseche
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Mostramos el video si está inicializado, de lo contrario, mostramos un indicador de carga
        _controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            : Center(child: CircularProgressIndicator()),
        SizedBox(height: 10),
        // Controles de reproducción del video
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(
                  _controller.value.isPlaying ? Icons.pause : Icons.play_arrow),
              onPressed: () {
                setState(() {
                  _controller.value.isPlaying
                      ? _controller.pause()
                      : _controller.play();
                });
              },
            ),
          ],
        ),
      ],
    );
  }
}
