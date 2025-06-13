import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pawlly/modules/components/boton_compartir.dart';
import 'package:pawlly/modules/components/input_text.dart';
import 'package:pawlly/modules/pet_owner_profile/controllers/pet_owner_profile_controller.dart';
import 'package:pawlly/modules/integracion/controller/especialidades_controller/epeciality_controller.dart';
import 'package:pawlly/styles/styles.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileActions extends StatelessWidget {
  final PetOwnerProfileController controller;
  final UserProfileController profileController;
  final SpecialityController specialityController = Get.put(SpecialityController());

  const ProfileActions({
    Key? key,
    required this.controller,
    required this.profileController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Container(
        padding: Styles.paddingAll,
        width: MediaQuery.sizeOf(context).width,
        child: Column(
          children: [
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: BotonCompartir(
                      modo: 'compartir',
                      title: 'Compartir perfil',
                      onCompartir: () async {
                        final String? publicProfileUrl =
                            profileController.user.value.publicProfile;
                        if (publicProfileUrl != null &&
                            publicProfileUrl.isNotEmpty) {
                          // Lógica para redirigir a la URL
                          if (await canLaunch(publicProfileUrl)) {
                            await launch(publicProfileUrl);
                          } else {
                            print('No se pudo lanzar la URL $publicProfileUrl');
                          }
                        } else {
                          // Manejar el caso en que no haya URL disponible
                          print('No hay URL de perfil público disponible');
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            if (profileController.user.value.userType != 'user' &&
                (profileController.user.value.profile?.specialityId != null))
              Container(
                width: MediaQuery.sizeOf(context).width,
                child: InputText(
                  placeholder: "",
                  fw: FontWeight.bold,
                  placeholderSvg: 'assets/icons/svg/genero.svg',
                  placeholderFontFamily: "Lato",
                  label: 'Área de especialización',
                  initialValue: specialityController.getNameById(
                          profileController
                              .user.value.profile?.specialityId) ??
                      '',
                  isTextArea: true,
                  onChanged: (value) {
                    controller.specializationArea.value = value;
                  },
                  readOnly: true, // Hacer que el campo sea solo de lectura
                ),
              ),
            const SizedBox(height: 20),
            if (profileController.user.value.userType != 'user' &&
                (profileController.user.value.profile?.tags ?? []).isNotEmpty)
              Container(
                width: MediaQuery.sizeOf(context).width,
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Otras especializaciones',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'lato',
                      ),
                    ),
                  ),
                ),
              ),
            if ((profileController.user.value.profile?.tags ?? []).isNotEmpty)
              Container(
                width: MediaQuery.sizeOf(context).width,
                child: Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: (profileController.user.value.profile?.tags ?? [])
                      .map((area) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 26.0),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF7E5),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        area,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFFFC9214),
                          fontWeight: FontWeight.bold,
                          fontFamily: 'lato',
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
          ],
        ),
      );
    });
  }
}
