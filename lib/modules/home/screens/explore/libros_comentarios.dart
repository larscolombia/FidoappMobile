import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:pawlly/modules/integracion/controller/libros/libros_controller.dart';

class ComentariosLibros extends StatelessWidget {
  final EBookController controller;

  const ComentariosLibros({Key? key, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Resumen de calificación
        Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Color(0xFFFEF7E5),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Color(0xFFFC9214),
              width: 1.0,
            ),
          ),
          child: Obx(() {
            final ebook = controller.selectedEBook.value;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Resumen de Calificación:',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'lato',
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    RatingBar.builder(
                      initialRating: ebook.averageRating,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemSize: 20.0,
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {},
                      ignoreGestures: true,
                    ),
                    SizedBox(width: 8),
                    Text(
                      ebook.averageRating.toStringAsFixed(1),
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
        SizedBox(height: 20),
        // Comentarios
        Obx(() {
          final bookRatings = controller.selectedEBook.value.bookRatings;
          if (bookRatings == null || bookRatings.isEmpty) {
            return Text(
              'No hay comentarios.',
              style: TextStyle(color: Colors.grey),
            );
          }
          return ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
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
