import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:pawlly/components/button_default_widget.dart';
import 'package:pawlly/modules/auth/model/address_models/country_list_response.dart';
import 'package:pawlly/modules/components/avatar_comentario.dart';
import 'package:pawlly/modules/components/baner_comentarios.dart';
import 'package:pawlly/modules/components/boton_compartir.dart';
import 'package:pawlly/modules/components/input_text.dart';
import 'package:pawlly/modules/components/recarga_componente.dart';

import 'package:pawlly/modules/components/regresr_components.dart';
import 'package:pawlly/modules/components/style.dart';

import 'package:pawlly/modules/integracion/controller/comentarios/ranting_controller.dart';
import 'package:pawlly/modules/integracion/controller/libros/libros_controller.dart';

class LibroDetalles extends StatelessWidget {
  final EBookController econtroller = Get.put(EBookController());
  final CommentController commentController = Get.put(CommentController());

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    var id = econtroller.idLibro.value;

    commentController.fetchComments(id, "books");

    print('libto ${econtroller.idLibro}');
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Contenedor superior
            Container(
              height: 345,
              width: size.width,
              color: Styles.colorContainer,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Center(
                      child: Container(
                        width: 345,
                        child: BarraBack(
                          titulo: 'Sobre este Ebook',
                          callback: () {
                            Get.back();
                            print('Regresar');
                          },
                        ),
                      ),
                    ),
                    Center(
                      child: Container(
                        height: 225,
                        width: 137,
                        decoration: BoxDecoration(
                          color: Colors.white,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Obx(() {
                            if (econtroller.isLoading.value) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            return FadeInImage.assetNetwork(
                              placeholder: 'assets/images/loading.gif',
                              image:
                                  econtroller.selectedEBook.value!.coverImage ??
                                      'https://via.placeholder.com/200x300',
                              fit: BoxFit.cover,
                              imageErrorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  'assets/images/404.jpg',
                                  fit: BoxFit.cover,
                                );
                              },
                            );
                          }),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Contenedor de la imagen y detalles
            Container(
              width: 320,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 16),
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(),
                    child: Text(
                      textAlign: TextAlign.center,
                      econtroller.selectedEBook.value.title ??
                          "Título del Ebook",
                      style: Styles.textTituloLibros,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    econtroller.selectedEBook.value.author ?? "Autor del Ebook",
                    style: Styles.TextTituloAutor,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Obx(() {
                    if (commentController.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return Container(
                      child: RatingBar.builder(
                        initialRating:
                            commentController.calculateAverageRating(),
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemPadding:
                            const EdgeInsets.symmetric(horizontal: 4.0),
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (value) {},
                      ),
                    );
                  }),
                  const SizedBox(
                    height: 10,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 305,
                    height: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Styles.colorContainer),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            width: 120,
                            child: icon_titulo_subtitulo(
                              label: 'Logitud',
                              value:
                                  '${econtroller.selectedEBook.value.number_of_pages} Paginas',
                              path: 'assets/icons/paginas.png',
                            ),
                          ),
                          Container(
                            height: 27,
                            decoration: BoxDecoration(
                              border: Border(
                                  left: BorderSide(
                                color: Styles.primaryColor,
                                width: 1,
                              )),
                            ),
                          ),
                          Container(
                            width: 120,
                            child: icon_titulo_subtitulo(
                                label: 'Idioma',
                                value:
                                    '${econtroller.selectedEBook.value.lenguaje}',
                                path: 'assets/icons/idima.png'),
                          ),
                        ]),
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: 305,
                    height: 100,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Sobre este Ebook',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontFamily: 'Lato',
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "${econtroller.selectedEBook.value.description}",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontFamily: 'Lato',
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: 304,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 94,
                          height: 54,
                          child: Center(
                            child: Text(
                              textAlign: TextAlign.center,
                              "${econtroller.selectedEBook.value.price} €",
                              style: Styles.TextTituloAutor,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            child: ButtonDefaultWidget(
                                title: 'Comprar', callback: () {}),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: 304,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Styles.primaryColor)),
                    child: Obx(() {
                      if (commentController.isComentarioPosrLoading.value) {
                        return Text('cargando');
                      }
                      return BanerComentarios(
                        eventTextChanged: (value) {
                          commentController.updateField('review_msg', value);
                        },
                        titulo: 'Tu experiencia',
                        onRatingUpdate: (rating) {
                          commentController.updateField('rating', rating);
                        },
                        onEvento: () {
                          commentController.updateField('e_book_id', id);
                          if (commentController.comentario.isNotEmpty) {
                            commentController.postComment('books');
                            commentController.fetchComments(id, "books");
                          }
                        },
                      );
                    }),
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: 304,
                    child: Text(
                      'Comentarios',
                      style: Styles.TextTitulo,
                    ),
                  ),
                  SizedBox(height: 20),
                  Obx(() {
                    if (commentController.isLoading.value) {
                      return const Center(
                        child: Text(''),
                      );
                    }

                    if (commentController.comments.value == null) {
                      return Text('no hay comentarios');
                    }

                    return SingleChildScrollView(
                      child: Column(
                        children: commentController.comments.map((value) {
                          return AvatarComentarios(
                            avatar: value.userAvatar ??
                                "https://www.thewall360.com/uploadImages/ExtImages/images1/def-638240706028967470.jpg",
                            name: value.userFullName,
                            date: "Fecha",
                            comment: value.reviewMsg,
                            rating: double.parse(value.rating.toString()),
                          );
                        }).toList(),
                      ),
                    );
                  }),
                  RecargaComponente(
                    callback: () {
                      commentController.fetchComments(id, "books");
                    },
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BarraComentario extends StatelessWidget {
  BarraComentario({
    super.key,
    required this.eventTextChanged,
    this.titulo,
  });
  final void Function(String) eventTextChanged;
  final String? titulo;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 10,
        ),
        Text(
          '¿Quieres dejar una reseña?',
          style: Styles.textDescription,
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          width: 276,
          child: InputText(
            onChanged: eventTextChanged,
            placeholder: titulo ?? 'Describe tu experiencia',
            label: '',
          ),
        ),
        const SizedBox(height: 10),
        Container(
          width: 276,
          height: 42,
          child: ButtonDefaultWidget(
            title: 'Enviar >',
            callback: () {},
          ),
        )
      ],
    );
  }
}

class icon_titulo_subtitulo extends StatelessWidget {
  icon_titulo_subtitulo(
      {super.key,
      required this.label,
      required this.value,
      required this.path});
  final String label;
  final String value;
  final String path;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 116,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            '${path}',
            width: 25,
          ),
          const SizedBox(width: 10),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${label}:',
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'Lato',
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
              Text(
                '${value}',
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'Lato',
                  fontWeight: FontWeight.w800,
                  color: Colors.black,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
