import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pawlly/generated/assets.dart';
import 'package:pawlly/modules/notification/screens/notification_screens.dart';
import 'package:pawlly/styles/styles.dart';

class HeaderNotification extends StatelessWidget {
  HeaderNotification({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Container(
      height: 130,
      width: width,
      padding: EdgeInsets.only(bottom: 20, left: 25, right: 25),
      decoration: const BoxDecoration(
        color: Color.fromRGBO(252, 246, 229, 1),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(35),
          bottomRight: Radius.circular(35),
        ),
      ),
      child: Align(
        alignment:
            Alignment.bottomCenter, // Alinea el contenido en la parte inferior
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment:
                CrossAxisAlignment.end, // Alinea los hijos al final de la Row
            children: [
              Column(
                mainAxisSize: MainAxisSize
                    .min, // Reduce el tamaño de la columna al contenido
                crossAxisAlignment:
                    CrossAxisAlignment.start, // Alinea el texto a la izquierda
                children: [
                  Text(
                    'Bienvenido de vuelta',
                    style: Styles.textTitleHome,
                  ),
                  Text(
                    '¿Qué haremos hoy?',
                    style: Styles.textSubTitleHome,
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  // Navegar a la vista de notificaciones
                  Get.to(() => NotificationsScreen());
                },
                child: Container(
                  width: 43,
                  height: 43,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
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
