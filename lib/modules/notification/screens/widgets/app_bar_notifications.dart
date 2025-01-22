import 'package:flutter/material.dart';
import 'package:pawlly/modules/components/border_redondiado.dart';
import 'package:pawlly/services/auth_service_apis.dart';
import 'package:pawlly/styles/styles.dart';

class AppBarNotifications extends StatelessWidget
    implements PreferredSizeWidget {
  @override
  final Size preferredSize;

  const AppBarNotifications({super.key})
      : preferredSize = const Size.fromHeight(120.0);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: AppBar(
        backgroundColor: Styles.fiveColor,
        elevation: 0,
        automaticallyImplyLeading:
            false, // Para controlar manualmente el ícono de retroceso
        flexibleSpace: Stack(
          children: [
            BorderRedondiado(top: 130),
            Container(
              padding: const EdgeInsets.only(
                  top: 56, bottom: 40, left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment
                    .center, // Alinea verticalmente los elementos en el centro
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context); // Acción de retroceso
                    },
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/icons/back.png',
                        ),
                        const SizedBox(
                            width: 24), // Espacio entre la flecha y el texto
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment
                              .center, // Centra el texto verticalmente
                          children: [
                            Text(
                              'Notificaciones',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'PoetsenOne',
                                color: Styles.primaryColor,
                              ),
                            ),
                            Text(
                              'Buzón',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Lato',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 65, // Tamaño del contenedor que contiene la imagen
                    height: 65,
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
                    child: CircleAvatar(
                      radius: 22, // Tamaño de la imagen de perfil
                      backgroundImage: NetworkImage(
                          "${AuthServiceApis.dataCurrentUser.profileImage}"), // URL de la imagen de perfil
                      backgroundColor: Colors
                          .transparent, // Fondo transparente si la imagen no se carga
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
