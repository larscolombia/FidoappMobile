import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pawlly/generated/assets.dart';
import 'package:pawlly/modules/components/reportar_mascota.dart';
import 'package:pawlly/modules/dashboard/screens/dashboard_screen.dart';
import 'package:pawlly/modules/home/controllers/home_controller.dart';
import 'package:pawlly/modules/integracion/controller/notificaciones/notificaciones_controller.dart';
import 'package:pawlly/modules/notification/screens/notification_screens.dart';
import 'package:pawlly/routes/app_pages.dart';
import 'package:pawlly/services/auth_service_apis.dart';
import 'package:pawlly/styles/styles.dart';

class HeaderNotification extends StatelessWidget {
  final String? titulo;
  final String? subtitulo;
  HeaderNotification(
      {super.key,
      this.titulo = 'Bienvenido de vuelta',
      this.subtitulo = '¿Qué haremos hoy?'});

  final HomeController controller = Get.put(HomeController());

  final NotificationController notificationController =
      Get.put(NotificationController());
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

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

class HeaderWiget extends StatelessWidget {
  const HeaderWiget({
    super.key,
    required this.width,
    required this.notificationController,
    required this.controller,
    this.titulo = 'Bienvenido de vuelta',
    this.subtitulo = '¿Qué haremos hoy?',
  });
  final String? titulo;
  final String? subtitulo;
  final double width;
  final NotificationController notificationController;
  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 120,
          width: width,
          padding: Styles.paddingAll,
          decoration: BoxDecoration(
            color: Styles.fiveColor,
          ),
          child: Align(
            alignment: Alignment
                .bottomCenter, // Alinea el contenido en la parte inferior
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment
                    .end, // Alinea los hijos al final de la Row
                children: [
                  LongPressButton(),
                  Obx(
                    () => Column(
                      mainAxisSize: MainAxisSize
                          .min, // Reduce el tamaño de la columna al contenido
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment
                          .start, // Alinea el texto a la izquierda
                      children: [
                        Container(
                          width: 161,
                          child: Text(
                            controller.titulo.value ?? "Bienvenido de vuelta",
                            style: Styles.textTitleHome,
                          ),
                        ),
                        Container(
                          width: 161,
                          child: Text(
                            controller.subtitle.value ?? "¿Qué haremos hoy?",
                            style: Styles.textSubTitleHome,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
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
                            child: Obx(() {
                              int unreadCount = notificationController
                                  .countUnreadNotifications();
                              return Stack(
                                children: [
                                  SvgPicture.asset(
                                    'assets/icons/svg/notification.svg',
                                    width: 24,
                                    height: 24,
                                  ),
                                  if (unreadCount > 0)
                                    Positioned(
                                      right: 0,
                                      child: Container(
                                        padding: const EdgeInsets.all(1),
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                        constraints: const BoxConstraints(
                                          minWidth: 12,
                                          minHeight: 12,
                                        ),
                                        child: Text(
                                          unreadCount.toString(),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 8,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                ],
                              );
                            }),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10), // Espacio entre los iconos
                      GestureDetector(
                        onTap: () {
                          // Navegar a la vista de Dashboard
                          Get.toNamed(Routes.DASHBOARD);
                        },
                        child: Container(
                            width:
                                50, // Tamaño del contenedor que contiene la imagen
                            height: 50,
                            padding: const EdgeInsets.all(
                                2), // Espacio entre la imagen y el borde
                            decoration: BoxDecoration(
                              color: Styles.fiveColor,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Styles.iconColorBack, // Color del borde
                                width: 2.0, // Grosor del borde
                              ),
                            ),
                            child: Obx(
                              () => CircleAvatar(
                                radius:
                                    46, // Ajustar el radio para que la imagen se adapte mejor al contenedor
                                backgroundImage: controller
                                        .profileImagePath.isNotEmpty
                                    ? NetworkImage(AuthServiceApis
                                        .dataCurrentUser
                                        .profileImage) // Carga la imagen desde la red si hay una URL
                                    : const AssetImage(
                                            'assets/images/avatar.png')
                                        as ImageProvider, // Imagen predeterminada si la URL está vacía
                                backgroundColor:
                                    Colors.transparent, // Fondo transparente
                              ),
                            )),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
