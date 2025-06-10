import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:pawlly/modules/components/style.dart';

class AvatarComentarios extends StatelessWidget {
  const AvatarComentarios({
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
      margin: const EdgeInsets.only(bottom: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width:
                    46, // Ajusta el tamaño del contenedor según el tamaño del avatar
                height: 46,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Color(0xFFEAEAEA), // Color del borde
                    width: 2, // Ancho del borde
                  ),
                ),
                child: CircleAvatar(
                  radius: 22,
                  backgroundImage: NetworkImage(avatar ??
                      "https://www.thewall360.com/uploadImages/ExtImages/images1/def-638240706028967470.jpg"),
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
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        name ?? "",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Lato',
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(
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
                                const EdgeInsets.symmetric(horizontal: 1.0),
                            itemSize: 16,
                            itemBuilder: (context, _) => const Icon(
                              Icons.star,
                              color: Color(0XFFFC9214),
                            ),
                            onRatingUpdate: (value) {},
                          ),
                          Container(
                            height: 14,
                            width: 1,
                            color: Color(0XFFEAEAEA),
                          ),
                          const SizedBox(width: 10),
                          SizedBox(
                            width: 50,
                            child: Text(
                              '${rating ?? 0.0}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0XFF383838),
                                fontFamily: 'Lato',
                                fontWeight: FontWeight.w800,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
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
          Padding(
            padding: const EdgeInsets.only(left: 5, right: 5),
            child: SizedBox(
              width: MediaQuery.sizeOf(context).width,
              child: Text(
                comment ?? "",
                style: Styles.AvatarComentario,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
