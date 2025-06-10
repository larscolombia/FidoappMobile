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
    videoId = YoutubePlayer.convertUrlToId(widget.videoUrl);
    
    failVideoId = videoId == null;

    if (failVideoId) {
      // Se agrega video placeholder para evitar que el controlador falle.
      // el video no se mostrará, se usa para evitar que falle el controlador.
      videoId = YoutubePlayer.convertUrlToId('https://www.youtube.com/watch?v=ScMzIvxBSi4');
    }
    
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
    );
  }
}
