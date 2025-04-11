import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pawlly/components/button_default_widget.dart';
import 'package:pawlly/components/custom_alert_dialog_widget.dart';
import 'package:pawlly/modules/components/boton_compartir.dart';
import 'package:pawlly/modules/components/recarga_componente.dart';
import 'package:pawlly/modules/components/regresr_components.dart';
import 'package:pawlly/modules/components/style.dart';
import 'package:pawlly/modules/home/screens/explore/show/curso_video.dart';
import 'package:pawlly/modules/home/screens/home_screen.dart';
import 'package:pawlly/modules/integracion/controller/balance/balance_controller.dart';
import 'package:pawlly/modules/integracion/controller/balance/producto_pay_controller.dart';
import 'package:pawlly/modules/integracion/controller/cursos/curso_usuario_controller.dart';
import 'package:pawlly/modules/integracion/controller/cursos/cursos_controller.dart';
import 'package:pawlly/modules/integracion/model/balance/producto_pay_model.dart';
import 'package:pawlly/modules/integracion/model/curosos/cursos_model.dart';

class CursosDetalles extends StatelessWidget {
  final String? cursoId;
  CursosDetalles({super.key, this.cursoId});
  final CourseController controller = Get.put(CourseController());
  final CursoUsuarioController miscursos = Get.put(CursoUsuarioController());
  final ProductoPayController compraController =
      Get.put(ProductoPayController());

  final UserBalanceController balanceController =
      Get.put(UserBalanceController());
  String dificultad(String dificultad) {
    switch (dificultad) {
      case '1':
        return 'Fácil';
      case '2':
        return 'Media';
      case '3':
        return 'Difícil';
      default:
        return 'Difícil';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.value || miscursos.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        var curso = controller.getCourseById(int.parse(cursoId!));
        // Todos los cursos son gratuitos, por lo que siempre serán considerados como adquiridos
        bool cursoAdquirido = true;
        print('cursoAdquirido s $cursoAdquirido');
        return Stack(
          children: [
            Positioned(
              top: 1,
              left: 0,
              right: 0,
              child: Container(
                height: 400,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.black,
                  image: DecorationImage(
                    image: NetworkImage(curso.image),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 300,
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white, // Color de fondo
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: Styles.paddingAll,
                    child: Column(
                      children: [
                        const SizedBox(height: 50),
                        SizedBox(
                          child: BarraBack(
                            titulo: curso.name.toString(),
                            size: 20,
                            subtitle: dificultad(curso.difficulty),
                            callback: () {
                              Get.off(HomeScreen());
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          curso.description,
                          textAlign: TextAlign.start,
                          style: const TextStyle(
                              fontFamily: 'Lato',
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF383838)),
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              color: Styles.colorContainer,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElementoInfo(
                                  title: "Programa",
                                  velue: "${curso.videos.length} Leciones",
                                  image: "assets/icons/svg/task.svg",
                                ),
                                Container(
                                  height: 30,
                                  width: 1,
                                  color: Color(0XFFFc9214).withOpacity(0.40),
                                ),
                                ElementoInfo(
                                  title: "Tiempo",
                                  velue: curso.duration,
                                  image: "assets/icons/svg/timer-start.svg",
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Center(
                          child: SizedBox(
                            width: 302,
                            child: Divider(
                              color: Colors.grey,
                              thickness: 0.2,
                            ),
                          ),
                        ),
                        SizedBox(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Sección #${curso.id}',
                                      style: Styles.textTituloLibros),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width / 2,
                                    child: Text(curso.name,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black,
                                          fontFamily: 'PoetsenOne',
                                        )),
                                  ),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Styles.colorContainer,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Text(
                                  'Gratis', // Cambiado de precio a "Gratis"
                                  style: Styles.textTituloLibros,
                                ),
                              ),
                            ],
                          ),
                        ),
                        ...curso.videos.map((video) {
                          return GestureDetector(
                            onTap: () {
                              // Se eliminó la comprobación de si el curso está adquirido
                              // ya que todos los cursos serán gratuitos
                              Get.to(() => CursoVideo(
                                    videoId: video.url,
                                    cursoId: curso.id.toString(),
                                    name: curso.name,
                                    description: curso.description,
                                    image: curso.image,
                                    duration: curso.duration,
                                    price:
                                        'Gratis', // Cambiado precio a "Gratis"
                                    difficulty: curso.difficulty,
                                    videoUrl: video.url,
                                    tipovideo: 'video',
                                  ));
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: MediaCard(
                                imageUrl: curso.image,
                                title: curso.name,
                                duration: curso.duration,
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}

// Se mantiene la definición pero no se utiliza
class BanerCompraPrecio extends StatelessWidget {
  const BanerCompraPrecio({
    super.key,
    this.price,
    this.callback,
  });
  final String? price;
  final VoidCallback? callback;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 310,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: SizedBox(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFf4f4f4),
                  borderRadius: BorderRadius.circular(16),
                ),
                width: 94,
                height: 54,
                child: Center(
                    child: Text(
                  '$price',
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.w800,
                  ),
                )),
              ),
              SizedBox(
                width: 190,
                height: 54,
                child: ButtonDefaultWidget(
                  title: 'Comprar Curso',
                  textSize: 16,
                  callback: callback,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ElementoInfo extends StatelessWidget {
  final String? title;
  final String? velue;
  final String? image;
  const ElementoInfo({
    super.key,
    this.title,
    this.velue,
    this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            image!, // Ruta del archivo SVG
            height: 24, // Puedes ajustar el tamaño si lo necesitas
            width: 24,
          ),
          const SizedBox(
            width: 8,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title ?? 'Programa:',
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                    fontFamily: 'Lato'),
              ),
              Text(
                velue ?? '10 Leciones',
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: Colors.black,
                    fontFamily: 'Lato'),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class MediaCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String duration;

  const MediaCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      height: 100,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 255, 255),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          // Imagen
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Texto y detalles
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Duración: $duration minutos',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Lato',
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          // Ícono de reproducción
          SvgPicture.asset('assets/icons/svg/play-cricle.svg')
        ],
      ),
    );
  }
}
