import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:pawlly/components/button_default_widget.dart';
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
      height: 209,
      width: MediaQuery.of(context).size.width - 50,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(13),
          border: Border.all(
            width: 1.0,
            color: Styles.primaryColor,
          )),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
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
                color: Colors.amber,
              ),
              onRatingUpdate: onRatingUpdate,
            ),
            SizedBox(
              height: 66,
              width: 276,
              child: InputText(
                onChanged: eventTextChanged,
                placeholder: titulo ?? 'Describe tu experiencia',
              ),
            ),
            const SizedBox(height: 10),
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
  const Estadisticas({
    super.key,
    required this.comentarios,
    required this.calificacion,
  });
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      width: MediaQuery.of(context).size.width - 100,
      height: 150,
      decoration: BoxDecoration(
        color: Styles.colorContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Styles.fiveColor, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text('Resumen de Calificación:',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontFamily: 'Lato',
                  fontWeight: FontWeight.w800,
                )),
            const SizedBox(
              height: 10,
            ),
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
                  '${calificacion} Calificación',
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
                Container(
                  width: MediaQuery.of(context).size.width / 2,
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
              ],
            ),
          ],
        ),
      ),
    );
  }
}
