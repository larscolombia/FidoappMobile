import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pawlly/components/button_default_widget.dart';
import 'package:pawlly/main.dart';
import 'package:pawlly/modules/add_pet/screens/add_pet_screen.dart';
import 'package:pawlly/modules/home/controllers/home_controller.dart';
import 'package:pawlly/modules/home/screens/widgets/widget_profile_dogs.dart';
import 'package:pawlly/routes/app_pages.dart';
import 'package:pawlly/styles/styles.dart';

class ProfilesDogs extends StatelessWidget {
  ProfilesDogs({super.key});

  // Instancia del controlador para manejar el estado
  final HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (BuildContext context) {
            return ProfileModal();
          },
        );
      },
      child: Container(
        margin: EdgeInsets.only(top: 16),
        height: 90,
        padding: EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Styles.fiveColor,
          borderRadius: BorderRadius.all(Radius.circular(25)),
          border: Border.all(
            color: Styles.iconColorBack, // Borde con color específico
          ),
        ),
        child: Obx(() {
          if (controller.selectedProfile.value.isEmpty) {
            // Mostrar mensaje si no hay perfil seleccionado
            return Center(
              child: Text(
                'Agrega tu mascota',
                style: TextStyle(
                  color: Styles.primaryColor,
                  fontFamily: 'PoetsenOne',
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
              ),
            );
          } else {
            // Mostrar imagen y datos del perfil seleccionado
            return Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  padding:
                      EdgeInsets.all(2), // Espacio entre la imagen y el borde
                  decoration: BoxDecoration(
                    color: Styles.fiveColor, // Fondo del borde
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Styles.iconColorBack, // Color del borde
                      width: 2.0, // Grosor del borde
                    ),
                  ),
                  child: CircleAvatar(
                    radius:
                        26, // Ajustar el radio para que la imagen se adapte mejor al contenedor
                    backgroundImage:
                        NetworkImage('https://via.placeholder.com/150'),
                    backgroundColor: Colors
                        .transparent, // Fondo transparente si la imagen no se carga
                  ),
                ),
                SizedBox(width: 15),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: width / 2.5,
                      child: Text(
                        controller.selectedProfile.value,
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
                      width: width / 2.5,
                      child: Text(
                        'Perfil de ${controller.selectedProfile.value}',
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
                Spacer(),
                Icon(
                  Icons.arrow_drop_down,
                  color: Styles.iconColorBack, // Color del icono
                ),
              ],
            );
          }
        }),
      ),
    );
  }
}
