import 'package:flutter/material.dart';

class ShowVideoCursos extends StatelessWidget {
  final String img;
  final String numero;

  const ShowVideoCursos({super.key, required this.img, this.numero = '1'});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 30,
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 20),
            width: 300,
            child: Row(
              children: [
                Text(
                  numero,
                  style: const TextStyle(
                    fontFamily: 'Lato',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 15, right: 10),
                  width: 50,
                  height: 34.2,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 68, 67, 67),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(
                  width: 175,
                  child: Column(
                    children: [
                      SizedBox(
                        width: 148,
                        child: Text('Title del curso',
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'Lato',
                              fontWeight: FontWeight.w900,
                            )),
                      ),
                      SizedBox(
                        width: 148,
                        child: Text(
                          '4 minutos',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: 9,
                              fontFamily: 'Lato',
                              fontWeight: FontWeight.w300,
                              color: Color.fromARGB(255, 167, 165, 162)),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  width: 28,
                  height: 28,
                  child: Image.asset(
                    img,
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
