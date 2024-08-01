import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:pawlly/styles/styles.dart';

class HeaderTitle extends StatelessWidget {
  final String label;
  final String title;
  final String precio;
  final Color color;
  HeaderTitle({
    super.key,
    this.title = 'Curso de HouseBreaking',
    this.precio = '20',
    this.label = "Sobre este curso",
    this.color = const Color.fromRGBO(27, 26, 24, 1),
  });
  @override
  Widget build(BuildContext context) {
    return Container(
        width: 300,
        margin: EdgeInsets.only(top: 30),
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Container(
                        width: 180,
                        child: Text(
                          label,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: 10,
                              fontFamily: 'Lato',
                              color: Color.fromRGBO(181, 187, 187, 1)),
                        ),
                      ),
                      Container(
                        width: 180,
                        child: Text(
                          title,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              color: color,
                              fontSize: 13,
                              fontFamily: 'Lato',
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                  Container(
                    width: 1.0,
                    height: 49.0,
                    color: const Color.fromARGB(255, 187, 199, 187),
                  ),
                  Container(
                    width: 49,
                    child: Column(
                      children: [
                        Text(
                          'Precio',
                          style: TextStyle(
                              fontSize: 10,
                              fontFamily: 'Lato',
                              color: Color.fromRGBO(181, 187, 187, 1)),
                        ),
                        Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                          child: Text(
                            precio,
                            style: TextStyle(
                              color: Styles.primaryColor,
                              fontSize: 13,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Divider(
              color: const Color.fromARGB(255, 172, 163, 163),
              thickness: .5,
            ),
          ],
        ));
  }
}
