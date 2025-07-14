import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:pawlly/components/button_default_widget.dart';
import 'package:pawlly/modules/components/circular_avatar_row.dart';
import 'package:pawlly/modules/components/input_text.dart';
import 'package:pawlly/modules/components/style.dart';

class BanerComentarios extends StatefulWidget {
  const BanerComentarios({
    super.key,
    required this.eventTextChanged,
    this.titulo = "Enviar >",
    required this.onRatingUpdate,
    required this.onEvento,
  });

  final void Function(String) eventTextChanged;
  final String? titulo;
  final void Function(double) onRatingUpdate;
  final void Function() onEvento;

  @override
  State<BanerComentarios> createState() => _BanerComentariosState();
}

class _BanerComentariosState extends State<BanerComentarios> {
  final TextEditingController _commentController = TextEditingController();
  double _currentRating = 0.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width,
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
                fontWeight: FontWeight.w700,
              ),
            ),
            RatingBar.builder(
              initialRating: _currentRating,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
              itemSize: 30,
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: Color(0xffFC9214),
              ),
              onRatingUpdate: (rating) {
                setState(() {
                  _currentRating = rating;
                });
                widget.onRatingUpdate(rating);
              },
            ),
            const SizedBox(height: 20),
            SingleChildScrollView(
              child: SizedBox(
                width: MediaQuery.sizeOf(context).width,
                child: InputText(
                  controller: _commentController,
                  onChanged: (value) {
                    widget.eventTextChanged(value);
                  },
                  placeholder: 'Describe tu experiencia',
                  labelColor: Color(0XFF383838),
                  height: 36,
                  fondoColor: Color(0XFFFeF7E5),
                  borderColor: Color(0XFFFC9214),
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: MediaQuery.sizeOf(context).width,
              height: 42,
              child: ButtonDefaultWidget(
                title: widget.titulo ?? "Enviar >",
                callback: () {
                  widget.onEvento();
                  // Limpiar campos después de enviar
                  _clearFields();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _clearFields() {
    setState(() {
      _commentController.clear();
      _currentRating = 0.0;
    });
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }
}

class Estadisticas extends StatelessWidget {
  final String comentarios;
  final String calificacion;
  final List<String>? avatars;
  final VoidCallback? onComentariosPressed;

  const Estadisticas({
    super.key,
    required this.comentarios,
    required this.calificacion,
    this.avatars,
    this.onComentariosPressed,
  });
  @override
  Widget build(BuildContext context) {
    print(avatars);
    // TODO: implement build
    return Container(
      width: MediaQuery.sizeOf(context).width,
      height: 160,
      decoration: BoxDecoration(
        color: Color(0XFFFeF7e5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Color(0XFFFC9214), width: .4),
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
                  fontWeight: FontWeight.w700,
                )),
            Row(
              children: [
                RatingBar.builder(
                  initialRating: double.parse(calificacion ?? '0'),
                  minRating: 1,
                  itemSize: 20,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Color(0XFFFc9214),
                  ),
                  onRatingUpdate: (val) {},
                ),
                const SizedBox(width: 10),
                Row(
                  children: [
                    Text(
                      '${double.parse(calificacion).toStringAsFixed(1)}',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0XFF383838),
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.w800, // Puntaje con fontWeight 800
                      ),
                    ),
                    const SizedBox(width: 4), // Espacio entre el puntaje y la palabra "Calificación"
                    const Text(
                      'Calificación',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0XFF383838),
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.w400, // Texto "Calificación" con fontWeight 400
                      ),
                    ),
                  ],
                )
              ],
            ),
            Container(
              height: 10,
            ),
            Container(
              width: MediaQuery.sizeOf(context).width,
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
                    child: GestureDetector(
                  onTap: onComentariosPressed,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Color(0xFFFC9214),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        '$comentarios comentarios',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                )),
                const SizedBox(width: 15),
                Flexible(
                  // Usamos Flexible en lugar de Expanded
                  child: Container(
                    child: CircularAvatarsRow(
                      imageUrls: avatars ?? [],
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
