import 'package:flutter/material.dart';
import 'package:pawlly/modules/home/screens/explore/show/video_player.dart';

class CursoVideo extends StatelessWidget {
  final String videoId;
  final String cursoId;
  final String name;
  final String description;
  final String image;
  final String duration;
  final String price;
  final String difficulty;
  final String videoUrl;
  CursoVideo({
    required this.videoId,
    required this.cursoId,
    required this.name,
    required this.description,
    required this.image,
    required this.duration,
    required this.price,
    required this.difficulty,
    required this.videoUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [],
      ),
    );
  }
}
