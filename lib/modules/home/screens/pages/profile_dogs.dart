import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pawlly/components/button_default_widget.dart';
import 'package:pawlly/main.dart';
import 'package:pawlly/modules/add_pet/screens/add_pet_screen.dart';
import 'package:pawlly/modules/home/controllers/home_controller.dart';
import 'package:pawlly/modules/home/screens/widgets/widget_profile_dogs.dart';
import 'package:pawlly/routes/app_pages.dart';
import 'package:pawlly/styles/styles.dart';

class ProfilesDogs extends StatelessWidget {
  ProfilesDogs(
      {super.key,
      this.isSelect = false,
      this.disableTap = false,
      this.showAge = false}); // Añadir el parámetro opcional

  // Instancia del controlador para manejar el estado
  final HomeController controller = Get.put(HomeController());
  final bool isSelect; // Declarar el campo
  final bool disableTap; // Declarar el campo opcional
  final bool showAge;
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return PerfilMascotas(
      controller: controller,
      width: width,
      isSelect: isSelect,
      disableTap: disableTap,
      showAge: showAge, // Pasar el campo
    );
  }
}

class PerfilMascotas extends StatelessWidget {
  const PerfilMascotas(
      {super.key,
      required this.controller,
      required this.width,
      this.formulario = false,
      this.isSelect = false, // Campo opcional con valor predeterminado
      this.disableTap = false,
      this.showAge = false // Campo opcional con valor predeterminado
      });

  final HomeController controller;
  final double width;
  final bool formulario;
  final bool isSelect; // Campo opcional
  final bool disableTap;
  final bool showAge; // Campo opcional

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: disableTap
          ? null
          : () {
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
        height: 62,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: disableTap ? Colors.white : Styles.fiveColor,
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          border: Border.all(
            color: disableTap
                ? Colors.transparent
                : Styles.iconColorBack, // Borde con color específico
          ),
        ),
        child: Obx(() {
          if (controller.selectedProfile.value == null) {
            // Mostrar mensaje si no hay perfil seleccionado
            return const Center(
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
            final profile = controller.selectedProfile.value!;
            return Row(
              children: [
                Container(
                  width: 41,
                  height: 41,
                  padding: const EdgeInsets.all(
                      3), // Espacio entre la imagen y el borde
                  decoration: BoxDecoration(
                    color: Colors.white, // Fondo del borde
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Styles.primaryColor, // Color del borde
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
                Container(
                  width: width / 4,
                  decoration: BoxDecoration(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: width / 2.5,
                        child: Text(
                          profile.name,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
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
                          disableTap == false && showAge == false
                              ? 'Perfil de ${profile.name}'
                              : '${profile.age}',
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
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
                ),
                const Spacer(),
                Padding(
                  padding: EdgeInsets.only(right: 5.0),
                  child: SvgPicture.asset(
                    'assets/icons/svg/arrow_profile.svg',
                    height: 16,
                    width: 16,
                  ),
                ),
              ],
            );
          }
        }),
      ),
    );
  }
}
