import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:pawlly/modules/components/style.dart';
import 'package:pawlly/modules/home/controllers/home_controller.dart';
import 'package:pawlly/modules/home/screens/widgets/widget_profile_dogs.dart';
import 'package:pawlly/services/auth_service_apis.dart';

class PerfilMascotas extends StatelessWidget {
  const PerfilMascotas({
    super.key,
    required this.controller,
    required this.width,
  });

  final HomeController controller;
  final double width;

  @override
  Widget build(BuildContext context) {
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
        margin: const EdgeInsets.only(top: 16),
        height: 90,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Styles.fiveColor,
          borderRadius: const BorderRadius.all(Radius.circular(25)),
          border: Border.all(
            color: Styles.iconColorBack, // Borde con color específico
          ),
        ),
        child: Obx(() {
          if (controller.selectedProfile.value == null) {
            // Mostrar mensaje si no hay perfil seleccionado
            return Center(
              child: Text(
                AuthServiceApis.dataCurrentUser.userType != "user"
                    ? 'Aun no tienes mascotas asignadas'
                    : "Agrega tu mascota",
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
            final profile = controller.selectedProfile.value!;
            return Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  padding: const EdgeInsets.all(
                      2), // Espacio entre la imagen y el borde
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
                    backgroundImage: profile.petImage != null &&
                            profile.petImage!.isNotEmpty
                        ? NetworkImage(profile.petImage!)
                        : const NetworkImage(
                                'https://www.thewall360.com/uploadImages/ExtImages/images1/def-638240706028967470.jpg')
                            as ImageProvider,
                    backgroundColor: Colors
                        .transparent, // Fondo transparente si la imagen no se carga
                  ),
                ),
                const SizedBox(width: 15),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: width / 2.5,
                      child: Text(
                        profile.name,
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                          color: Styles.primaryColor,
                          fontFamily: 'PoetsenOne',
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: width / 2.5,
                      child: Text(
                        'Perfil de ${profile.name}',
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                          color: Styles.blackColor,
                          fontFamily: 'Lato',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                const Icon(
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
