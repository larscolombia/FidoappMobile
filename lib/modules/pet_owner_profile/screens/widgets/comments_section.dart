import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:pawlly/modules/pet_owner_profile/controllers/pet_owner_profile_controller.dart';

class CommentsSection extends StatelessWidget {
  final PetOwnerProfileController controller =
      Get.put(PetOwnerProfileController());

  CommentsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: const Color(0xFFFEF7E5), // Fondo del cuadro
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: const Color(0xFFFC9214),
              width: 1.0,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Título "Resumen de Calificación"
              const Text(
                'Resumen de Calificación:',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'lato',
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 10),
              // Clasificación en estrellas
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  RatingBar.builder(
                    initialRating: controller.rating.value,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 2.0),
                    itemSize: 20.0,
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Colors.amber, // Estrellas en color amarillo
                    ),
                    onRatingUpdate: (rating) {},
                    ignoreGestures: true,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    controller.rating.value.toString(),
                    style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'lato'),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Divider(color: Color(0xFFFC9214), thickness: 1),
              const SizedBox(height: 10),
              // Comentarios
              Row(
                children: [
                  // Texto "456 comentarios" con fondo y borde
                  Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    decoration: BoxDecoration(
                      color: const Color(
                          0xFFFC9214), // Fondo del texto "Comentarios"
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      '${controller.commentCount.value} comentarios',
                      style: const TextStyle(
                          color: Colors.white, // Texto blanco en "Comentarios"
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          fontFamily: 'lato'),
                    ),
                  ),
                  const Spacer(),
                  // Imágenes de los comentaristas, solapadas
                  Expanded(
                    child: SizedBox(
                      height: 30, // Altura ajustada para las imágenes
                      child: Stack(
                        children: List.generate(
                          controller.commenterImages.length > 5
                              ? 5
                              : controller.commenterImages.length,
                          (index) => Positioned(
                            left: index *
                                20.0, // Solapar las imágenes desde la mitad
                            child: CircleAvatar(
                              backgroundImage: controller
                                          .commenterImages[index].isNotEmpty ==
                                      true
                                  ? NetworkImage(
                                      controller.commenterImages[index])
                                  : const AssetImage('assets/images/avatar.png')
                                      as ImageProvider, // Imagen predeterminada
                              radius: 15,
                              backgroundColor: Colors.transparent,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20), // Espaciado entre secciones
        // Sección para dejar una reseña
        Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: const Color(0xFFFC9214),
              width: 1.0,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                '¿Quieres dejar una reseña?',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'lato',
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              RatingBar.builder(
                initialRating: 0,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemPadding: const EdgeInsets.symmetric(horizontal: 2.0),
                itemSize: 30.0,
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  controller.rating.value = rating;
                },
              ),
              const SizedBox(height: 10),
              const TextField(
                decoration: InputDecoration(
                  hintText: 'Escribe tu comentario aquí',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 15,
                  ),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFC9214),
                  padding: const EdgeInsets.symmetric(
                      vertical: 12.0, horizontal: 24.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Enviar >',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    fontFamily: 'lato',
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20), // Espaciado entre secciones
        // Sección de comentarios lista
        const Text(
          'Comentarios',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontFamily: 'lato',
            fontSize: 16,
          ),
        ),
        const Divider(color: Colors.grey, thickness: 1),
        Obx(() => ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.comments.length,
              itemBuilder: (context, index) {
                var comment = controller.comments[index];
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 8.0), // Espaciado vertical
                  title: Row(
                    crossAxisAlignment: CrossAxisAlignment
                        .start, // Alineación para el nombre y la imagen
                    children: [
                      // Imagen circular
                      CircleAvatar(
                        backgroundImage: (comment['image'] != null &&
                                (comment['image'] as String).isNotEmpty)
                            ? NetworkImage(comment['image'] as String)
                            : const AssetImage('assets/images/avatar.png')
                                as ImageProvider,
                        radius: 30, // Tamaño de la imagen
                      ),
                      const SizedBox(
                          width: 12), // Espacio entre la imagen y el texto
                      // Nombre y estrellas al lado de la imagen
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            comment['name']?.toString() ?? 'Usuario Anónimo',
                            style: const TextStyle(
                              fontFamily: 'lato',
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(
                              height:
                                  4), // Espacio entre el nombre y las estrellas
                          RatingBar.builder(
                            initialRating: (comment['rating'] is double)
                                ? comment['rating'] as double
                                : (comment['rating'] != null
                                    ? double.tryParse(
                                            comment['rating'].toString()) ??
                                        0.0
                                    : 0.0), // Verifica si es un double o convierte el rating
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemSize: 16.0, // Tamaño de las estrellas
                            itemBuilder: (context, _) => const Icon(
                              Icons.star,
                              color:
                                  Colors.amber, // Estrellas en color amarillo
                            ),
                            onRatingUpdate: (rating) {},
                            ignoreGestures: true,
                          ),
                        ],
                      ),
                    ],
                  ),
                  // Descripción/comentario debajo de todo
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      comment['comment']?.toString() ?? 'Sin comentario',
                      style: const TextStyle(
                        fontFamily: 'lato',
                        fontSize: 14,
                      ),
                    ),
                  ),
                );
              },
            )),
      ],
    );
  }
}
