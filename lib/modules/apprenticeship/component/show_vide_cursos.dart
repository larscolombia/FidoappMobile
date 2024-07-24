import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pawlly/generated/assets.dart';

class ShowVideoCursos extends StatelessWidget {
  final String imagen;
  final String numero;

  ShowVideoCursos({super.key, required this.imagen, this.numero = '1'});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      width: 30,
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 20),
            width: 300,
            child: Row(
              children: [
                Text(
                  numero,
                  style: TextStyle(
                    fontFamily: 'lato',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 15, right: 10),
                  width: 50,
                  height: 34.2,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 68, 67, 67),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                Container(
                  width: 175,
                  child: Column(
                    children: [
                      Container(
                        width: 148,
                        child: Text('Titulo del curso',
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'lato',
                              fontWeight: FontWeight.w900,
                            )),
                      ),
                      Container(
                        width: 148,
                        child: Text(
                          '4 minutos',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: 9,
                              fontFamily: 'lato',
                              fontWeight: FontWeight.w300,
                              color: const Color.fromARGB(255, 167, 165, 162)),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  width: 28,
                  height: 28,
                  child: Image.asset(
                    imagen,
                    width: 28,
                    height: 28,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
