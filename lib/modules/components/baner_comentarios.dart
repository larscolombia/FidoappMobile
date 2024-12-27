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
    return Column(
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
    );
  }
}
