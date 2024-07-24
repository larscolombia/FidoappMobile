import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:pawlly/styles/styles.dart';

// ignore: must_be_immutable
class Utilidades extends StatelessWidget {
  const Utilidades({super.key});
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Container(
      padding: Styles.paddingAll,
      height: 160,
      width: width,
      margin: EdgeInsets.only(top: 30),
      child: Column(
        children: [
          Container(
            width: width,
            child: Text(
              'Recursos',
              style: TextStyle(
                fontSize: 20,
                color: Styles.primaryColor,
                fontFamily: 'PoetsenOne',
              ),
              textAlign: TextAlign.left,
            ),
          ),
          Container(
            child: Container(
              margin: EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    alignment: Alignment.center,
                    height: 44,
                    width: width / 4,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(19),
                      border: Border.all(
                        color: Styles.greyTextColor, // Color del borde
                        width: 1, // Ancho del borde
                      ),
                    ),
                    child: Text(
                      'Ebook’s',
                      style: TextStyle(
                          fontFamily: 'lalo',
                          fontSize: 14,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    height: 44,
                    width: width / 4,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(19),
                      border: Border.all(
                        color: Styles.greyTextColor, // Color del borde
                        width: 1, // Ancho del borde
                      ),
                    ),
                    child: Text(
                      'YouTube',
                      style: TextStyle(
                          fontFamily: 'lalo',
                          fontSize: 14,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    height: 44,
                    width: width / 4,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(19),
                      border: Border.all(
                        color: Styles.greyTextColor, // Color del borde
                        width: 1, // Ancho del borde
                      ),
                    ),
                    child: Text(
                      'Accesorios',
                      style: TextStyle(
                          fontFamily: 'lalo',
                          fontSize: 14,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
