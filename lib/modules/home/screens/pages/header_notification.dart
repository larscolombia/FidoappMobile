import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pawlly/generated/assets.dart';
import 'package:pawlly/modules/dashboard/screens/dashboard_screen.dart';
import 'package:pawlly/modules/home/controllers/home_controller.dart';
import 'package:pawlly/modules/notification/screens/notification_screens.dart';
import 'package:pawlly/routes/app_pages.dart';
import 'package:pawlly/styles/styles.dart';

class HeaderNotification extends StatelessWidget {
  HeaderNotification({super.key});

  final HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Container(
      height: 130,
      width: width,
      padding: Styles.paddingAll,
      decoration: const BoxDecoration(
        color: Styles.fiveColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(35),
          bottomRight: Radius.circular(35),
        ),
      ),
      child: Align(
        alignment:
            Alignment.bottomCenter, // Alinea el contenido en la parte inferior
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
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
                        child: Image.asset(
                          fit: BoxFit.cover,
                          Assets.notification,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10), // Espacio entre los iconos
                  GestureDetector(
                    onTap: () {
                      // Navegar a la vista de Dashboard
                      Get.toNamed(Routes.DASHBOARD);
                    },
                    child: Container(
                        width:
                            50, // Tamaño del contenedor que contiene la imagen
                        height: 50,
                        padding: EdgeInsets.all(
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
                                ? NetworkImage(controller.profileImagePath
                                    .value) // Carga la imagen desde la red si hay una URL
                                : AssetImage('assets/images/avatar.png')
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
    );
  }
}
