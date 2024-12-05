import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:pawlly/modules/components/style.dart';

class AvatarComentarios extends StatelessWidget {
  AvatarComentarios({
    super.key,
    this.avatar,
    this.name,
    this.date,
    this.comment,
    this.rating,
  });
  final String? avatar;
  final String? name;
  final String? date;
  final String? comment;
  final double? rating;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 304,
      margin: EdgeInsets.only(bottom: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundImage: NetworkImage(avatar ??
                    "https://www.thewall360.com/uploadImages/ExtImages/images1/def-638240706028967470.jpg"),
                child: Image.network(
                  avatar ??
                      "https://www.thewall360.com/uploadImages/ExtImages/images1/def-638240706028967470.jpg",
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    // Cuando la imagen no se puede cargar (por ejemplo, 404 o URL inválida), mostramos una imagen de respaldo
                    return Icon(Icons.account_circle,
                        size: 44,
                        color: Colors.grey); // Icono de usuario por defecto
                  },
                ),
              ),
              const SizedBox(width: 2),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 5),
                      width: 200,
                      child: Text(
                        name ?? "",
                        style: Styles.AvatarName,
                      ),
                    ),
                    Container(
                      width: 200,
                      child: Row(
                        children: [
                          RatingBar.builder(
                            initialRating: rating ?? 0.0,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemPadding:
                                const EdgeInsets.symmetric(horizontal: 3.0),
                            itemSize: 15,
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (value) {},
                          ),
                          const SizedBox(width: 10),
                          Text(
                            '5.0',
                            style: Styles.textProfile14w700,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            width: 304,
            child: Text(
              comment ?? "",
              style: Styles.AvatarComentario,
            ),
          ),
        ],
      ),
    );
  }
}
