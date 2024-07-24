import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:pawlly/generated/assets.dart';
import 'package:pawlly/styles/styles.dart';

class HeaderNotification extends StatelessWidget {
  const HeaderNotification({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
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
          height: 43,
          width: 302,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 200,
                child: Column(
                  children: [
                    Container(
                      width: 200,
                      child: Text(
                        'Bienvenido de vuelta',
                        style: Styles.textTitleHome,
                      ),
                    ),
                    Container(
                      width: 200,
                      child: Text(
                        '¿Qué haremos hoy?',
                        style: Styles.textSubTitleHome,
                      ),
                    ),
                  ],
                ),
              ),
              Center(
                child: Container(
                  width: 43,
                  height: 43,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Styles.fiveColor,
                  ),
                  child: Center(
                    child: Image.asset(
                      fit: BoxFit.cover,
                      Assets.notification,
                    ),
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
