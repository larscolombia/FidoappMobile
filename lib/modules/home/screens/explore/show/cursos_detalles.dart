import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pawlly/components/button_default_widget.dart';
import 'package:pawlly/modules/home/screens/explore/show/curso_video.dart';
import 'package:pawlly/modules/integracion/controller/cursos/curso_usuario_controller.dart';
import 'package:pawlly/modules/integracion/controller/cursos/cursos_controller.dart';
import 'package:pawlly/styles/styles.dart';

class CursosDetalles extends StatelessWidget {
  final String? cursoId;
  CursosDetalles({super.key, this.cursoId});
  final CourseController controller = Get.put(CourseController());
  final CursoUsuarioController miscursos = Get.put(CursoUsuarioController());

  @override
  Widget build(BuildContext context) {
    miscursos.fetchCourses();

    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.value || miscursos.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        var curso = controller.getCourseById(int.parse(cursoId!));
        bool cursoAdquirido = miscursos.hasCourse(cursoId!);

        return Stack(
          children: [
            Positioned(
              top: 300,
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 50),
                        NavbarBack(
                          title: curso.name,
                        ),
                        const SizedBox(height: 20),
                        Abaut(description: curso.description),
                        const SizedBox(height: 10),
                        const SizedBox(height: 20),
                        Center(
                          child: Container(
                            width: 305,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Styles.fiveColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElementoInfo(
                                  title: "Programa",
                                  velue: "${curso.videos.length} Leciones",
                                  image: "assets/icons/calendar.png",
                                ),
                                ElementoInfo(
                                  title: "Tiempo",
                                  velue: "${curso.duration}",
                                  image: "assets/icons/timer-start.png",
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: Container(
                            width: 320,
                            height: 54,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                BtnCompartir(
                                  compra: cursoAdquirido,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        if (!cursoAdquirido)
                          BanerCompraPrecio(
                            price: curso.price,
                            callback: () {
                              print('comprando');
                              miscursos.subscribeToCourse(curso.id);
                            },
                          ),
                        const SizedBox(height: 20),
                        Center(
                          child: Container(
                            width: 302,
                            child: Divider(
                              color: Colors.grey,
                              thickness: 0.2,
                            ),
                          ),
                        ),
                        ...curso.videos.map((video) {
                          return GestureDetector(
                            onTap: () {
                              // Acción al tocar un video
                              Get.to(CursoVideo(
                                videoId: video.url,
                                cursoId: curso.id.toString(),
                                name: curso.name,
                                description: curso.description,
                                image: curso.image,
                                duration: curso.duration,
                                price: curso.price,
                                difficulty: curso.difficulty,
                                videoUrl: video.url,
                              ));
                              print('Video ID: ${video.url}');
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: MediaCard(
                                imageUrl: curso.image,
                                title: video.video,
                                duration: '4.5',
                              ),
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 350,
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
          ],
        );
      }),
    );
  }
}

class BtnCompartir extends StatelessWidget {
  const BtnCompartir({super.key, this.compra});
  final bool? compra;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (compra!)
          Container(
            child: Container(
              width: 127,
              height: 32,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.green[100],
                border: Border.all(
                  color: Color.fromARGB(255, 11, 139, 7),
                  width: 1,
                ),
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(
                      Icons.check,
                      color: Colors.green,
                      size: 16,
                    ),
                    Text(
                      'Adquirido',
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.green,
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
          ),
        Container(
          child: GestureDetector(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: 160,
                height: 32,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Color.fromARGB(255, 245, 245, 245),
                  border: Border.all(
                    color: Color.fromARGB(255, 172, 172, 172),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'Compartir curso',
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.w600),
                    ),
                    Image.asset(
                      'assets/icons/send-2.png',
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

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
        child: Container(
          width: 132,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 255, 254, 253),
                  borderRadius: BorderRadius.circular(20),
                ),
                width: 94,
                height: 54,
                child: Center(child: Text('${price}\$')),
              ),
              Container(
                width: 190,
                height: 54,
                child: ButtonDefaultWidget(
                  title: 'Comprar Curso',
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
          Image.asset(
            image ?? "assets/icons/calendar.png",
            width: 24,
            height: 24,
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
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
              Text(
                velue ?? '10 Leciones',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
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

class Abaut extends StatelessWidget {
  final String? description;
  const Abaut({
    super.key,
    this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 302,
        child: Center(
          child: Text(description ?? "",
              style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Lato',
                  color: Colors.black)),
        ),
      ),
    );
  }
}

// para regresar atras
class NavbarBack extends StatelessWidget {
  final String? title;
  final String? dificulta;
  const NavbarBack({
    super.key,
    this.title,
    this.dificulta,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 302,
        decoration:
            BoxDecoration(color: const Color.fromARGB(255, 255, 255, 255)),
        height: 45,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: 30,
              child: GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Image.asset('assets/icons/back.png'),
              ),
            ),
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Text(
                      title ?? 'g',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Styles.primaryColor,
                      ),
                    ),
                  ),
                  Container(
                    child: Text(
                      dificulta ?? 'Principiantes',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Styles.iconColorBack,
                      ),
                    ),
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

class MediaCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String duration;

  const MediaCard({
    Key? key,
    required this.imageUrl,
    required this.title,
    required this.duration,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8.0),
      padding: EdgeInsets.all(12.0),
      height: 72,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 255, 255, 255),
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
          SizedBox(width: 12),
          // Texto y detalles
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Lato',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Duración: $duration minutos',
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
          Icon(
            Icons.play_circle_fill,
            color: Colors.orange,
            size: 32,
          ),
        ],
      ),
    );
  }
}
