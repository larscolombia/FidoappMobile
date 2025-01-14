import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:pawlly/components/button_default_widget.dart';
import 'package:pawlly/generated/assets.dart';
import 'package:pawlly/modules/apprenticeship/component/cursos.dart';
import 'package:pawlly/modules/apprenticeship/component/header_title.dart';
import 'package:pawlly/modules/apprenticeship/component/show_vide_cursos.dart';

class CursoShow extends StatelessWidget {
  const CursoShow({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.zero,
                width: Get.width,
                height: 338,
                child: Image.asset(
                  fit: BoxFit.cover,
                  Assets.show_curso,
                ),
              ),
              Container(
                width: Get.width,
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Container(
                  width: 300,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        width: 300,
                        height: 64,
                        child: Container(
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 180,
                                child: const Text(
                                  'Información de este Curso',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'Lato',
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Container(
                                width: 49,
                                margin: const EdgeInsets.only(top: 5),
                                child: Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 5),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: const Color.fromARGB(
                                                255, 119, 117, 117)),
                                      ),
                                      child: Image.asset(Assets.compartir),
                                    ),
                                    const Text(
                                      'Compartir',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontFamily: 'Lato',
                                        color: Color.fromRGBO(181, 187, 187, 1),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 1),
                        height: 1,
                        width: 30,
                        child: const Divider(
                          thickness: .2,
                          color: Color.fromARGB(255, 170, 165, 157),
                        ),
                      ),
                      Container(
                        width: 30,
                        margin: const EdgeInsets.only(top: 30),
                        child: ButtonDefaultWidget(
                          title: 'Comprar Curso',
                          callback: () {},
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 30),
                        height: 1,
                        width: 30,
                        child: const Divider(
                          thickness: .2,
                          color: Color.fromARGB(255, 170, 165, 157),
                        ),
                      ),
                      HeaderTitle(),
                      Container(
                        margin: const EdgeInsets.only(top: 10),
                        width: 30,
                        child: Column(
                          children: [
                            Container(
                              child: const Text(
                                'Descubre cómo enseñar a tu perro a ir al baño en el lugar correcto con nuestro curso de House Breaking! Aprende técnicas rápidas y efectivas para mantener tu hogar limpio y tu mascota feliz.',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Lato',
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 30),
                        height: 1,
                        width: 30,
                        child: const Divider(
                          thickness: .2,
                          color: Color.fromARGB(255, 170, 165, 157),
                        ),
                      ),
                      Container(
                        width: 300,
                        margin: const EdgeInsets.only(top: 20),
                        child: Column(
                          children: [
                            SizedBox(
                              width: 30,
                              child: const Text('Programa de entrenimiento',
                                  style: TextStyle(
                                      fontFamily: 'Lato',
                                      fontSize: 12,
                                      fontWeight: FontWeight.w800,
                                      color: Color.fromRGBO(156, 156, 156, 1))),
                            ),
                            SizedBox(
                              width: 30,
                              child: const Text('Contenido del Curso',
                                  style: TextStyle(
                                      fontFamily: 'Lato',
                                      fontSize: 13,
                                      fontWeight: FontWeight.w800,
                                      color: Color.fromRGBO(22, 17, 17, 1))),
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 30),
                        height: 1,
                        width: 30,
                        child: const Divider(
                          thickness: .2,
                          color: Color.fromARGB(255, 170, 165, 157),
                        ),
                      ),
                      const HeaderTitle(
                        label: 'Sección 1',
                        title: 'Introducción al HouseBreaking',
                        precio: '20',
                        color: Color.fromRGBO(130, 56, 0, 1),
                      ),
                      const SizedBox(
                        width: 30 + 1,
                        child: Column(
                          children: [
                            ShowVideoCursos(img: Assets.play, numero: '1'),
                            ShowVideoCursos(img: Assets.candado, numero: "2"),
                            ShowVideoCursos(img: Assets.candado, numero: '3'),
                            ShowVideoCursos(img: Assets.candado, numero: '4'),
                            ShowVideoCursos(img: Assets.candado, numero: '5'),
                          ],
                        ),
                      ),
                      const HeaderTitle(
                        label: 'Sección 2',
                        title: 'HouseBreaking Avanzado',
                        precio: '20',
                        color: Color.fromRGBO(130, 56, 0, 1),
                      ),
                      SizedBox(
                        width: 30 + 1,
                        child: Column(
                          children: [
                            ShowVideoCursos(img: Assets.play, numero: '1'),
                            ShowVideoCursos(img: Assets.candado, numero: "2"),
                            ShowVideoCursos(img: Assets.candado, numero: '3'),
                            ShowVideoCursos(img: Assets.candado, numero: '4'),
                            ShowVideoCursos(img: Assets.candado, numero: '5'),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
