import 'package:flutter/material.dart';
import 'package:pawlly/styles/styles.dart';

class AppBarNotifications extends StatelessWidget
    implements PreferredSizeWidget {
  @override
  final Size preferredSize;

  AppBarNotifications({Key? key})
      : preferredSize = const Size.fromHeight(120.0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.vertical(
        bottom: Radius.circular(25),
      ),
      child: AppBar(
        backgroundColor: Styles.fiveColor,
        elevation: 0,
        automaticallyImplyLeading:
            false, // Para controlar manualmente el ícono de retroceso
        flexibleSpace: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment
                .center, // Alinea verticalmente los elementos en el centro
            children: [
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () {
                      Navigator.pop(context); // Acción de retroceso
                    },
                  ),
                  SizedBox(width: 8), // Espacio entre la flecha y el texto
                  Column(
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
              Container(
                width: 65, // Tamaño del contenedor que contiene la imagen
                height: 65,
                padding:
                    EdgeInsets.all(2), // Espacio entre la imagen y el borde
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
                      'https://via.placeholder.com/150'), // URL de la imagen de perfil
                  backgroundColor: Colors
                      .transparent, // Fondo transparente si la imagen no se carga
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
