import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pawlly/components/button_default_widget.dart';
import 'package:pawlly/modules/apprenticeship/curso_show.dart';
import 'package:pawlly/styles/styles.dart';

class Cursos extends StatelessWidget {
  final double margin = 3;
  final String TitleCurso;
  final String duracion;
  final String precio;

  const Cursos({
    super.key,
    this.TitleCurso = 'Curso de HouseBreaking',
    this.duracion = '10meses',
    this.precio = "20.0",
  });

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
      child: Container(
        decoration: const BoxDecoration(
          color: Styles.secondColor,
        ),
        margin: EdgeInsets.only(left: margin),
        height: 200.0,
        width: (30 / 2) - margin,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 1),
              margin: const EdgeInsets.only(top: 50),
              width: 128,
              child: Text(
                TitleCurso,
                style: const TextStyle(
                  fontFamily: 'Lato',
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  width: 60,
                  child: Column(
                    children: [
                      const Text(
                        'tiempo',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: Color.fromRGBO(188, 190, 190, 1),
                            fontFamily: 'Lato',
                            fontSize: 12,
                            fontWeight: FontWeight.w200),
                      ),
                      Text(
                        duracion,
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                          fontFamily: 'Lato',
                          fontSize: 9.2,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  width: 60,
                  child: Column(
                    children: [
                      const Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          '20',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontFamily: 'Lato',
                            fontSize: 9.2,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const ButtonDefaultWidget(
              title: 'Ver más',
              callback: callback,
              heigthButtom: 32,
            )
          ],
        ),
      ),
    );
  }
}

void callback() {
  Get.to(() => CursoShow());
}
