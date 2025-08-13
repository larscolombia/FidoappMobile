import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pawlly/components/safe_inkwell.dart';
import 'package:pawlly/modules/home/controllers/home_controller.dart';
import 'package:pawlly/modules/integracion/controller/notificaciones/notificaciones_controller.dart';
import 'package:pawlly/modules/notification/screens/notification_screens.dart';
import 'package:pawlly/routes/app_pages.dart';
import 'package:pawlly/services/auth_service_apis.dart';
import 'package:pawlly/styles/styles.dart';

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
          height: 140, // Aumentamos de 120 a 140 para dar más espacio
          width: width,
          padding: Styles.paddingAll,
          decoration: const BoxDecoration(
            color: Styles.fiveColor,
          ),
          child: Align(
            alignment: Alignment
                .bottomCenter, // Alinea el contenido en la parte inferior
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 20), // Aumentamos el padding vertical de 15 a 20
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment
                    .end, // Alinea los hijos al final de la Row
                children: [
                  Obx(
                    () => Column(
                      mainAxisSize: MainAxisSize
                          .min, // Reduce el tamaño de la columna al contenido
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment
                          .start, // Alinea el texto a la izquierda
                      children: [
                        SizedBox(
                          width: 161,
                          child: Text(
                            controller.titulo.value ?? "Bienvenido de vuelta",
                            style: Styles.textTitleHome,
                          ),
                        ),
                        SizedBox(
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
                      SafeInkWell(
                        onTap: () {
                          // Solo navegar a notificaciones si Firebase está disponible
                          if (notificationController != null) {
                            Get.to(() => NotificationsScreen());
                          } else {
                            // Mostrar mensaje de que las notificaciones no están disponibles
                            Get.snackbar(
                              'Notificaciones',
                              'Las notificaciones no están disponibles en este momento',
                              snackPosition: SnackPosition.BOTTOM,
                            );
                          }
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
                                      ?.countUnreadNotifications() ?? 0;
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
                      SafeInkWell(
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
                                radius: 46,
                                backgroundImage: controller.profileImagePath.isNotEmpty
                                  ? NetworkImage(AuthServiceApis.dataCurrentUser.profileImage)
                                  : const AssetImage('assets/images/avatar.png')as ImageProvider,
                                backgroundColor: Colors.transparent,
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
