import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:pawlly/modules/components/boton_compartir.dart';
import 'package:pawlly/modules/components/input_text.dart';
import 'package:pawlly/modules/pet_owner_profile/controllers/pet_owner_profile_controller.dart';
import 'package:pawlly/styles/styles.dart';

class ProfileActions extends StatelessWidget {
  final PetOwnerProfileController controller;
  final UserProfileController profileController;

  const ProfileActions({
    Key? key,
    required this.controller,
    required this.profileController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (profileController.isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
      return Container(
        padding: Styles.paddingAll,
        width: MediaQuery.of(context).size.width,
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
                      onCompartir: () {
                        // Lógica para compartir perfil
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            if (profileController.user.value.userType != 'user')
              Container(
                padding: Styles.paddingAll,
                width: MediaQuery.of(context).size.width,
                child: InputText(
                  placeholder: "",
                  fw: FontWeight.bold,
                  placeholderImage: Image.asset('assets/icons/genero.png'),
                  placeholderFontFamily: "Lato",
                  label: 'Área de especialización',
                  initialValue:
                      profileController.user.value.profile?.expert ?? "",
                  onChanged: (value) {
                    controller.specializationArea.value = value;
                  },
                ),
              ),
            const SizedBox(height: 20),
            if (profileController.user.value.userType != 'user')
              Container(
                padding: Styles.paddingAll,
                width: MediaQuery.of(context).size.width,
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
            Container(
              padding: Styles.paddingAll,
              width: MediaQuery.of(context).size.width,
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
