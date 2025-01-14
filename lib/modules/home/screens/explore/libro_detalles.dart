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
import 'package:pawlly/modules/integracion/controller/balance/balance_controller.dart';
import 'package:pawlly/modules/integracion/controller/balance/producto_pay_controller.dart';

import 'package:pawlly/modules/integracion/controller/comentarios/ranting_controller.dart';
import 'package:pawlly/modules/integracion/controller/libros/libros_controller.dart';
import 'package:pawlly/modules/integracion/model/balance/producto_pay_model.dart';

class LibroDetalles extends StatelessWidget {
  final EBookController econtroller = Get.put(EBookController());
  final CommentController commentController = Get.put(CommentController());
  final UserBalanceController balanceController =
      Get.put(UserBalanceController());
  final ProductoPayController productController =
      Get.put(ProductoPayController());
  LibroDetalles({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    var id = econtroller.idLibro.value;

    commentController.fetchComments(id, "books");

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(slivers: [
        SliverList(
          delegate: SliverChildListDelegate([
            SizedBox(
              height: 400,
              child: Stack(children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: HeaderEbook(
                    size: size,
                    econtroller: econtroller,
                  ),
                ),
                Positioned(
                  top: 300,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 40,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(40),
                    ),
                  ),
                ),
                Positioned(
                  top: 150,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      height: 225,
                      width: 137,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Obx(() {
                          if (econtroller.isLoading.value) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return FadeInImage.assetNetwork(
                            placeholder: 'assets/images/loading.gif',
                            image: econtroller.selectedEBook.value.coverImage ??
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
                ),
              ]),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 16),
                        const SizedBox(height: 16),
                        Container(
                          width: MediaQuery.of(context).size.width - 150,
                          decoration: const BoxDecoration(),
                          child: Text(
                            textAlign: TextAlign.center,
                            econtroller.selectedEBook.value.title ??
                                "Título del Ebook",
                            style: Styles.textTituloLibros,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          econtroller.selectedEBook.value.author ??
                              "Autor del Ebook",
                          style: Styles.textSubTituloLibros,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Obx(() {
                          if (commentController.isLoading.value) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                child: RatingBar.builder(
                                  initialRating: commentController
                                      .calculateAverageRating(),
                                  minRating: 1,
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  itemCount: 5,
                                  itemPadding: const EdgeInsets.symmetric(
                                      horizontal: 4.0),
                                  itemBuilder: (context, _) => const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                                  onRatingUpdate: (value) {},
                                ),
                              ),
                              SizedBox(
                                width: 45,
                                child: Text(
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    "${commentController.calculateAverageRating()}",
                                    style: Styles.textTituloLibros),
                              ),
                            ],
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
                                SizedBox(
                                  width: 120,
                                  child: icon_titulo_subtitulo(
                                    label: 'Longitud',
                                    value: econtroller.selectedEBook.value
                                                .number_of_pages ==
                                            "null"
                                        ? 'Sin Paginas'
                                        : '${econtroller.selectedEBook.value.number_of_pages} Paginas',
                                    path: 'assets/icons/paginas.png',
                                  ),
                                ),
                                Container(
                                  height: 27,
                                  decoration: const BoxDecoration(
                                    border: Border(
                                        left: BorderSide(
                                      color: Styles.primaryColor,
                                      width: 1,
                                    )),
                                  ),
                                ),
                                SizedBox(
                                  width: 120,
                                  child: icon_titulo_subtitulo(
                                      label: 'Idioma',
                                      value: econtroller.selectedEBook.value
                                                  .lenguaje ==
                                              'null'
                                          ? 'Sin datos'
                                          : econtroller
                                              .selectedEBook.value.lenguaje,
                                      path: 'assets/icons/idioma.png'),
                                ),
                              ]),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: 305,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Sobre este Libro',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontFamily: 'Lato',
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "${econtroller.selectedEBook.value.description}",
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontFamily: 'Lato',
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: 304,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 94,
                                height: 54,
                                child: Center(
                                  child: Text(
                                    textAlign: TextAlign.center,
                                    "${econtroller.selectedEBook.value.price}\$",
                                    style: Styles.TextTituloAutor,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  child: ButtonDefaultWidget(
                                    title: 'Comprar',
                                    callback: () {
                                      /** 
                                      productController.setProduct(
                                        ProductoPayModel(
                                          precio: econtroller
                                              .selectedEBook.value.price
                                              .toString(),
                                          nombreProducto: econtroller
                                              .selectedEBook.value.title
                                              .toString(),
                                          imagen: econtroller
                                              .selectedEBook.value.coverImage
                                              .toString(),
                                          descripcion: econtroller
                                              .selectedEBook.value.description
                                              .toString(),
                                          slug: 'libro',
                                          id: int.parse(econtroller
                                                  .selectedEBook.value.id ??
                                              '0'),
                                        ),
                                      );
                                      balanceController
                                          .showPurchaseModal(context);
                                          */
                                      var url =
                                          econtroller.selectedEBook.value.url;
                                      econtroller
                                          .openStripeCheckout(url.toString());
                                    },
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Obx(() {
                          if (commentController.isComentarioPosrLoading.value) {
                            return const Text('cargando');
                          }
                          return BanerComentarios(
                            eventTextChanged: (value) {
                              commentController.updateField(
                                  'review_msg', value);
                            },
                            titulo: 'Tu experiencia',
                            onRatingUpdate: (rating) {
                              commentController.updateField('rating', rating);
                            },
                            onEvento: () {
                              commentController.updateField('e_book_id', id);
                              if (commentController.comentario.isNotEmpty) {
                                commentController.postComment('books', context);
                                commentController.fetchComments(id, "books");
                              }
                            },
                          );
                        }),
                        const SizedBox(height: 20),
                        const SizedBox(
                          width: 304,
                          child: Text(
                            'Comentarios',
                            style: Styles.TextTitulo,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Obx(() {
                          if (commentController.isLoading.value) {
                            return const Center(
                              child: Text('cargando ...'),
                            );
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
          ]),
        )
      ]),
    );
  }
}

class HeaderEbook extends StatelessWidget {
  const HeaderEbook({
    super.key,
    required this.size,
    required this.econtroller,
  });

  final Size size;
  final EBookController econtroller;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 335,
      width: size.width,
      decoration: const BoxDecoration(
        color: Styles.colorContainer,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            Center(
              child: SizedBox(
                width: 345,
                child: BarraBack(
                  titulo: 'Sobre este Libro',
                  subtitle: 'Encuentra toda la información aquí',
                  ColorSubtitle: Colors.black,
                  callback: () {
                    Get.back();
                    print('Regresar');
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BarraComentario extends StatelessWidget {
  const BarraComentario({
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
        const SizedBox(
          height: 10,
        ),
        const Text(
          '¿Quieres dejar una reseña?',
          style: Styles.textDescription,
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          width: 276,
          child: InputText(
            onChanged: eventTextChanged,
            placeholder: titulo ?? 'Describe tu experiencia',
            label: '',
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
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
  const icon_titulo_subtitulo({super.key, this.label, this.value, this.path});
  final String? label;
  final String? value;
  final String? path;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 130,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            path ?? 'assets/images/pet_care.png',
            width: 25,
            errorBuilder: (BuildContext context, Object exception,
                StackTrace? stackTrace) {
              return Image.asset(
                'assets/images/pet_care.png',
                width: 25,
              );
            },
          ),
          const SizedBox(width: 10),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$label:',
                style: const TextStyle(
                  fontSize: 14,
                  fontFamily: 'Lato',
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
              Text(
                value == 'null' ? 'Sin datos' : "${value}",
                style: const TextStyle(
                  fontSize: 12,
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
