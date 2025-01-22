import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:pawlly/components/button_default_widget.dart';
import 'package:pawlly/modules/components/circular_avatar_row.dart';
import 'package:pawlly/modules/components/input_text.dart';
import 'package:pawlly/modules/components/style.dart';

class BanerComentarios extends StatelessWidget {
  const BanerComentarios(
      {super.key,
      required this.eventTextChanged,
      this.titulo,
      required this.onRatingUpdate,
      required this.onEvento});

  final void Function(String) eventTextChanged;
  final String? titulo;
  final void Function(double) onRatingUpdate;
  final void Function() onEvento;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 305,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            width: 0.5,
            color: Styles.iconColorBack,
          )),
      child: Padding(
        padding: const EdgeInsets.only(
          left: 13.0,
          right: 13.0,
          top: 16.0,
          bottom: 16.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              '¿Quieres dejar una reseña?',
              style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontFamily: 'Lato',
                  fontWeight: FontWeight.w800),
            ),
            RatingBar.builder(
              initialRating: 0,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: Color(0xffFC9214),
              ),
              onRatingUpdate: onRatingUpdate,
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 66,
              width: 276,
              child: InputText(
                onChanged: eventTextChanged,
                placeholder: 'Describe tu experiencia',
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 276,
              height: 42,
              child: ButtonDefaultWidget(
                title: 'Enviar >',
                callback: onEvento,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Estadisticas extends StatelessWidget {
  final String comentarios;
  final String calificacion;
  final List<String>? avatars;
  const Estadisticas({
    super.key,
    required this.comentarios,
    required this.calificacion,
    this.avatars,
  });
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      width: 305,
      height: 155,
      decoration: BoxDecoration(
        color: Styles.colorContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Styles.fiveColor, width: .5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(26),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text('Resumen de Calificación:',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontFamily: 'Lato',
                  fontWeight: FontWeight.bold,
                )),
            Row(
              children: [
                RatingBar.builder(
                  initialRating: double.parse(calificacion ?? '0'),
                  minRating: 1,
                  itemSize: 18,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (val) {},
                ),
                const SizedBox(width: 10),
                Text(
                  '${double.parse(calificacion).toStringAsFixed(1)} Calificación',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black,
                    fontFamily: 'Lato',
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            Container(
              height: 10,
            ),
            Container(
              width: MediaQuery.of(context).size.width - 120,
              decoration: BoxDecoration(
                border: Border.all(color: Styles.fiveColor, width: .4),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Styles.fiveColor,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('$comentarios comentarios',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                            fontFamily: 'Lato',
                            fontWeight: FontWeight.w800,
                          )),
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Container(
                    child: CircularAvatarsRow(
                      imageUrls: avatars ?? [],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
