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
              CircleAvatar(
                radius: 30, // Aumenta el tamaño de la imagen
                backgroundImage:
                    NetworkImage('https://via.placeholder.com/150'),
                backgroundColor:
                    Colors.transparent, // Asegura que el fondo sea transparente
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Styles.iconColorBack, // Color del borde
                      width: 1.0, // Grosor del borde
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
