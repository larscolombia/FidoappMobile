import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:pawlly/modules/integracion/controller/libros/libros_controller.dart';

class ComentariosLibros extends StatelessWidget {
  final EBookController controller;

  const ComentariosLibros({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Resumen de calificación
        Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: const Color(0xFFFEF7E5),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: const Color(0xFFFC9214),
              width: 0.4,
            ),
          ),
          child: Obx(() {
            final ebook = controller.selectedEBook.value;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Resumen de Calificación:',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'lato',
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    RatingBar.builder(
                      initialRating: 2,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemSize: 20.0,
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {},
                      ignoreGestures: true,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'aqui hay un error fix',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'lato',
                      ),
                    ),
                  ],
                ),
              ],
            );
          }),
        ),
        const SizedBox(height: 20),
        // Comentarios
        Obx(() {
          final bookRatings = controller.selectedEBook.value.bookRatings;
          if (bookRatings == null || bookRatings.isEmpty) {
            return const Text(
              'No hay comentarios.',
              style: TextStyle(color: Colors.grey),
            );
          }
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: bookRatings.length,
            itemBuilder: (context, index) {
              final rating = bookRatings[index];
              return ListTile(
                title: Text('Usuario ${rating.userId ?? 'Anónimo'}'),
                subtitle: Text(rating.reviewMsg ?? 'Sin comentario'),
              );
            },
          );
        }),
      ],
    );
  }
}
