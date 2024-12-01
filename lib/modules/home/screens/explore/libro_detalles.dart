import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pawlly/components/button_default_widget.dart';
import 'package:pawlly/modules/home/screens/explore/libros_comentarios.dart';
import 'package:pawlly/modules/integracion/controller/libros/libros_controller.dart';
import 'package:pawlly/modules/pet_owner_profile/controllers/pet_owner_profile_controller.dart';
import 'package:pawlly/modules/pet_owner_profile/screens/widgets/comments_section.dart';
import 'package:pawlly/styles/styles.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

// perfil del usuario
class LibroDetalles extends StatelessWidget {
  final PetOwnerProfileController controller =
      Get.put(PetOwnerProfileController());
  final EBookController econtroller = Get.put(EBookController());

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final headerHeight = size.height / 8;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      var id = econtroller.idLibro.value;
      econtroller.fetchEBookById(id);
    });

    return Scaffold(
      body: Container(
        height: double.infinity,
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Encabezado
              Stack(
                children: [
                  Container(
                    height: 225,
                    width: double.infinity,
                    color: Styles.fiveColor,
                  ),
                  // Imagen circular centrada
                  Center(
                    child: Container(
                      margin: EdgeInsets.only(top: headerHeight - 50),
                      child: Obx(
                        () => Container(
                          width: 137,
                          height: 225,
                          child: Image.network(
                            econtroller.selectedEBook.value.coverImage ??
                                'https://via.placeholder.com/150',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                'assets/images/404.jpg',
                                fit: BoxFit.cover,
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              // Espacio entre la imagen y el contenido
              SizedBox(height: 20),
              Container(
                width: 330,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 280,
                      height: 90,
                      child: Column(
                        children: [
                          Obx(() {
                            if (econtroller.isLoading.value) {
                              return Text('Cargando...');
                            }
                            var ebook = econtroller.selectedEBook.value;
                            return RichText(
                              text: TextSpan(
                                text: ebook.title ?? '',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                  fontFamily: 'lato',
                                ),
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            );
                          }),
                          Obx(() {
                            if (econtroller.isLoading.value) {
                              return Text('Cargando...');
                            }
                            var ebook = econtroller.selectedEBook.value;
                            return RichText(
                              text: TextSpan(
                                text: ebook.author ?? '',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                  fontFamily: 'lato',
                                ),
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            );
                          }),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Obx(() {
                                var averageRating = econtroller
                                    .selectedEBook.value.averageRating;

                                return RatingBar.builder(
                                  initialRating: averageRating,
                                  minRating: 0,
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  itemCount: 6,
                                  itemPadding:
                                      EdgeInsets.symmetric(horizontal: 2.0),
                                  itemSize: 20.0,
                                  itemBuilder: (context, _) => Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                                  onRatingUpdate: (rating) {},
                                  ignoreGestures: true,
                                );
                              }),
                              SizedBox(width: 8),
                              Text(
                                controller.rating.value.toString(),
                                style: Styles.secondTextTitle,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Sección sobre el Ebook
              const SizedBox(height: 20),
              Container(
                width: 302,
                height: 54,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Styles.fiveColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          'assets/icons/calendar.png',
                          width: 24,
                          height: 24,
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Logitud:",
                              style: const TextStyle(
                                fontFamily: 'Lato',
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                            ),
                            Obx(
                              () => Text(
                                "${econtroller.selectedEBook.value.number_of_pages ?? "0"} páginas",
                                style: const TextStyle(
                                  fontFamily: 'Lato',
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.translate,
                          color: Styles.primaryColor,
                          size: 24.0,
                          semanticLabel:
                              'Text to announce in accessibility modes',
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Idioma",
                              style: const TextStyle(
                                fontFamily: 'Lato',
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                            ),
                            Obx(
                              () => Text(
                                econtroller.selectedEBook.value.lenguaje ??
                                    "N/h",
                                style: const TextStyle(
                                  fontFamily: 'Lato',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black,
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: Styles.paddingAll,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Sobre este Ebook',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'lato',
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: Styles.paddingAll,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Obx(
                      () => Text(
                        econtroller.selectedEBook.value.description ?? '',
                        style: Styles.secondTextTitle,
                        textAlign: TextAlign.justify,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                width: 302,
                height: 90,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Obx(() {
                      if (econtroller.isLoading.value) {
                        return Text('Cargando...');
                      }
                      var ebook = econtroller.selectedEBook.value;
                      return Text('${ebook.number_of_pages ?? 'precio'}',
                          style: Styles.secondTextTitle);
                    }),
                    Container(
                      width: 208,
                      child: ButtonDefaultWidget(
                        title: 'Comprar',
                        callback: () {},
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Container(
                padding: Styles.paddingAll,
                child: ComentariosLibros(controller: econtroller),
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class EbookInfo extends StatelessWidget {
  const EbookInfo({
    super.key,
    required this.label,
    required this.value,
    required this.icono,
  });

  final IconData icono;
  final String label;
  final RxString value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icono,
          color: Styles.primaryColor,
          size: 24.0,
          semanticLabel: 'Text to announce in accessibility modes',
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'Lato',
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
            ),
            Obx(
              () => Text(
                value.value,
                style: const TextStyle(
                  fontFamily: 'Lato',
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
            )
          ],
        ),
      ],
    );
  }
}
