import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:pawlly/generated/assets.dart';

class HeaderBanerUser extends StatelessWidget {
  final double altura;
  final String titulo;
  final String avatar;
  final String leyenda;

  HeaderBanerUser({
    this.altura = 274.00,
    this.avatar = Assets.avatar,
    this.titulo = 'Bienvenido, Usuario',
    this.leyenda = "La app de entrenamiento para tu mascota",
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            height: altura,
            width: Get.width,
            decoration: const BoxDecoration(
              color: Color.fromRGBO(252, 246, 229, 1),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(35),
                bottomRight: Radius.circular(35),
              ),
            ),
            child: Center(
                child: Container(
              height: 140,
              width: 300,
              decoration: BoxDecoration(),
              child: Row(
                children: [
                  Container(
                    width: 180,
                    child: Column(
                      children: [
                        Text(
                          titulo,
                          style: const TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Montserrat',
                          ),
                        ),
                        Text(
                          leyenda,
                          style: const TextStyle(
                              fontSize: 14.0,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 93,
                    height: 50,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 110, 45, 45),
                      borderRadius: BorderRadius.circular(35),
                    ),
                    child: Row(
                      children: [
                        Image.asset(
                          avatar,
                        ),
                        Center(
                          child: Icon(
                            color: Colors.white,
                            Icons.notifications,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            )),
          )
        ],
      ),
    );
  }
}
