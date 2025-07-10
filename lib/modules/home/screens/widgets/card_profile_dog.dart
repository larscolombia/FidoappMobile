import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pawlly/components/button_default_widget.dart';
import 'package:pawlly/models/pet_list_res_model.dart';
import 'package:pawlly/modules/components/custom_checkbox.dart';
import 'package:pawlly/modules/home/controllers/home_controller.dart';
import 'package:pawlly/modules/integracion/controller/historial_clinico/historial_clinico_controller.dart';
import 'package:pawlly/modules/profile_pet/controllers/profile_pet_controller.dart';
import 'package:pawlly/routes/app_pages.dart';
import 'package:pawlly/styles/styles.dart';

class CardProfileDog extends StatelessWidget {
  const CardProfileDog({
    super.key,
    required this.isSelected,
    required this.width,
    required this.height,
    required this.profile,
    required this.controller,
    required this.medicalHistoryController,
  });

  final bool isSelected;
  final double width;
  final double height;
  final PetData profile;
  final HomeController controller;
  final HistorialClinicoController medicalHistoryController;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isSelected
            ? Styles.fiveColor
            : Styles.whiteColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Styles.iconColorBack.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Imagen del perfil
          Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: profile.petImage != null
                  ? Image.network(
                      profile.petImage!,
                      fit: BoxFit.cover,
                      errorBuilder:
                          (context, error, stackTrace) {
                        return Image.asset(
                          'assets/images/404.jpg',
                          fit: BoxFit.cover,
                        );
                      },
                    )
                  : Image.asset(
                      'assets/images/404.jpg',
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          
          const SizedBox(width: 12),
          
          // Contenido del perfil
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Name and checkbox
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        profile.name,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: const TextStyle(
                          fontFamily: 'Lato',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Styles.blackColor,
                        ),
                      ),
                    ),
                    CustomCheckbox(
                      onChanged: (value) {
                        controller.updateProfile(profile);
                        Navigator.of(context)
                            .pop(); // Cierra el modal
                      },
                      isChecked: isSelected,
                    ),
                  ],
                ),
                
                const SizedBox(height: 4),
                
                // Age
                Text(
                  profile.age,
                  style: const TextStyle(
                    fontFamily: 'Lato',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Styles.blackColor,
                  ),
                ),

                // Breed
                Text(
                  profile.gender == "female"
                      ? 'Femenino'
                      : 'Masculino',
                  style: const TextStyle(
                    fontFamily: 'Lato',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Styles.iconColorBack,
                  ),
                ),
                
                SizedBox(height: height * 0.19),
                
                SizedBox(
                  width: double
                      .infinity, // Ocupa todo el ancho disponible
                  height: 34,
                  child: ButtonDefaultWidget(
                    heigthButtom: 40,
                    borderSize: 30,
                    title: 'Ver perfil >',
                    textSize: 12,
                    callback: () async {
                      // Cierra el modal si está abierto
                      Navigator.of(context).pop();

                      // Elimina el controlador anterior si existe
                      if (Get.isRegistered<ProfilePetController>()) {
                        await Get.delete<ProfilePetController>(force: true);
                      }
    
                      controller.updateProfile(profile);
                      medicalHistoryController.updateField("pet_id", profile.id.toString());
    
                      // Navega al perfil
                      await Get.toNamed(
                        Routes.PROFILEPET,
                        arguments: profile,
                      );

                      // Al volver, refresca el estado si es necesario
                      controller.fetchProfiles();
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
