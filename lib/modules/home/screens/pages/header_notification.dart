import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pawlly/modules/home/controllers/home_controller.dart';
import 'package:pawlly/modules/home/screens/pages/header_wiget.dart';
import 'package:pawlly/modules/integracion/controller/notificaciones/notificaciones_controller.dart';
import 'package:pawlly/styles/styles.dart';

class HeaderNotification extends StatelessWidget {
  final String? titulo;
  final String? subtitulo;
  HeaderNotification({
    super.key,
    this.titulo = 'Bienvenido de vuelta',
    this.subtitulo = '¿Qué haremos hoy?'
  });

  final HomeController controller = Get.put(HomeController());
  final NotificationController notificationController = Get.put(NotificationController());

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    return Container(
      color: Styles.fiveColor,
      height: 140,
      child: Stack(
        children: [
          HeaderWiget(
            width: width,
            notificationController: notificationController,
            controller: controller,
            titulo: titulo,
            subtitulo: subtitulo,
          ),
          Positioned(
            top: 120,
            left: 0,
            right: 0,
            child: Container(
              height: 40,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(36),
                  topRight: Radius.circular(36),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
