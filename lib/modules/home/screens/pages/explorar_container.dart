import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:pawlly/components/button_default.dart';
import 'package:pawlly/generated/assets.dart';
import 'package:pawlly/styles/styles.dart';

class Explore extends StatelessWidget {
  const Explore({super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Styles.paddingAll,
      child: Container(
        height: 160,
        margin: EdgeInsets.only(top: 30),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Styles.tertiaryColor,
        ),
        child: Row(
          children: [
            Center(
              child: Container(
                width: 152,
                height: 120,
                margin: EdgeInsets.only(left: 20),
                child: Column(
                  children: [
                    Container(
                      child: Text(
                        'Recomendaciones para tu Mascota',
                        style: TextStyle(
                          fontFamily: 'Lato',
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Styles.whiteColor,
                        ),
                      ),
                    ),
                    Container(
                      width: 152,
                      margin: EdgeInsets.only(top: 8),
                      child: Text(
                        'Consejos y recursos útiles',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontFamily: 'Lato',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Styles.whiteColor,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 2),
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: ButtonDefault(
                          title: 'Explorar',
                          callback: () {},
                          widthButtom: 97,
                          heigthButtom: 40,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: 127,
              height: Get.height,
              decoration: BoxDecoration(),
              child: Align(
                alignment: Alignment.bottomRight,
                child: Image.asset(
                  Assets.elice,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
