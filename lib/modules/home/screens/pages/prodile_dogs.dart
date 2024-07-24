import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pawlly/modules/dashboard/screens/dashboard_screen.dart';
import 'package:pawlly/styles/styles.dart';

class ProfilesDogs extends StatelessWidget {
  ProfilesDogs({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () {
        Get.to(() => DashboardScreen()); // Navega a DashboardScreen
      },
      child: Container(
        margin: EdgeInsets.only(top: 16),
        padding: Styles.paddingAll,
        child: Container(
          padding: EdgeInsets.only(left: 20),
          height: 90,
          width: width,
          decoration: const BoxDecoration(
            color: Color.fromRGBO(252, 246, 229, 1),
            borderRadius: BorderRadius.all(Radius.circular(25)),
          ),
          child: Container(
            width: width,
            height: 43,
            child: Row(
              children: [
                Center(
                  child: Container(
                    width:
                        60, // Tamaño total del contenedor (incluyendo el borde y espacio)
                    height: 60,
                    padding: EdgeInsets.all(
                        2), // Espacio entre el borde y el CircleAvatar
                    decoration: BoxDecoration(
                      color: Colors.blue, // Color del borde
                      shape: BoxShape.circle,
                    ),
                    child: CircleAvatar(
                      radius:
                          50, // Radio del CircleAvatar (menor que el contenedor)
                      backgroundImage:
                          NetworkImage('https://via.placeholder.com/150'),
                      backgroundColor: Colors
                          .white, // Color de fondo del CircleAvatar para el "espacio"
                    ),
                  ),
                ),
                SizedBox(width: 15),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment
                      .start, // Alinea el texto a la izquierda
                  children: [
                    Container(
                      width: width / 2,
                      child: Text(
                        'Oasis',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Styles.primaryColor,
                          fontFamily: 'PoetsenOne',
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    Container(
                      width: width / 2,
                      child: Text(
                        'Perfil de Oassis',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Styles.blackColor,
                          fontFamily: 'Lato',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
