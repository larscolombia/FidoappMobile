import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pawlly/components/button_default_widget.dart';
import 'package:pawlly/modules/components/custom_checkbox.dart';
import 'package:pawlly/modules/components/recarga_componente.dart';
import 'package:pawlly/modules/home/controllers/home_controller.dart';
import 'package:pawlly/modules/integracion/controller/diario/activida_mascota_controller.dart';
import 'package:pawlly/modules/integracion/controller/historial_clinico/historial_clinico_controller.dart';
import 'package:pawlly/routes/app_pages.dart';
import 'package:pawlly/services/auth_service_apis.dart';
import 'package:pawlly/styles/styles.dart';

class ProfileModal extends StatelessWidget {
  final HomeController controller = Get.put(HomeController());
  final HistorialClinicoController medicalHistoryController =
      Get.put(HistorialClinicoController());
  final PetActivityController activityController =
      Get.put(PetActivityController());

  ProfileModal({super.key});
  @override
  Widget build(BuildContext context) {
    //controller.fetchProfiles();
    return FractionallySizedBox(
      heightFactor: 0.7, // Ocupa el 60% de la pantalla
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Styles.whiteColor, // Fondo del modal
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Mascota',
                        style: TextStyle(
                          fontSize: 20,
                          color: Styles.primaryColor,
                          fontFamily: 'PoetsenOne',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Image.asset('assets/icons/x.png'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Selecciona",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  controller.SelectType == 1
                      ? const Text(
                          'Seleccionar el perfil de la mascota la cual quieres ver la información',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontFamily: 'Lato',
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      : const SizedBox(),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      CustomCheckbox(
                        onChanged: (value) {},
                        isChecked: false,
                      ),
                      const SizedBox(width: 16),
                      const Text(
                        "Ver información de todos los perros",
                        style: TextStyle(
                          fontSize: 14,
                          color: Styles.primaryColor,
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  RecargaComponente(
                    callback: () {
                      controller.fetchProfiles();
                      Get.snackbar(
                        'Refrescando data',
                        'Espere mientras se actualiza la información.',
                        snackPosition: SnackPosition.BOTTOM,
                        duration: Duration(seconds: 2),
                      );
                    },
                  )
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Obx(() {
                if (controller.profiles.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Aún no has agregado ninguna mascota, te invitamos a agregarla.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                          fontFamily: 'Lato',
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                } else {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ListView.builder(
                      itemCount: controller.profiles.length,
                      itemBuilder: (context, index) {
                        var profile = controller.profiles[index];
                        var isSelected =
                            controller.selectedProfile.value == profile;

                        return GestureDetector(
                          onTap: () {
                            // Actualiza el perfil seleccionado
                            activityController
                                .fetchPetActivities(profile.id.toString());
                            controller.updateProfile(profile);
                            Navigator.of(context).pop(); // Cierra el modal
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            padding: const EdgeInsets.all(12),
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
                              children: [
                                // Imagen del perfil
                                Container(
                                  width: MediaQuery.of(context).size.width *
                                      0.3, // 30% del ancho de pantalla
                                  height: MediaQuery.of(context).size.width *
                                      0.25, // Relación de aspecto
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
                                                fontSize: 16,
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
                                      Text(
                                        profile.age,
                                        style: const TextStyle(
                                          fontFamily: 'Lato',
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          color: Styles.blackColor,
                                        ),
                                      ),
                                      Text(
                                        profile.gender == "female"
                                            ? 'Femenino'
                                            : 'Masculino',
                                        style: const TextStyle(
                                          fontFamily: 'Lato',
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          color: Styles.iconColorBack,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      SizedBox(
                                        width: double
                                            .infinity, // Ocupa todo el ancho disponible
                                        height: 34,
                                        child: ButtonDefaultWidget(
                                          heigthButtom: 40,
                                          borderSize: 30,
                                          title: 'Ver perfil >',
                                          textSize: 12,
                                          callback: () {
                                            print(
                                                'info pert 2 ${jsonEncode(profile.id)}');

                                            controller.updateProfile(profile);

                                            medicalHistoryController
                                                .updateField("pet_id",
                                                    profile.id.toString());

                                            Get.toNamed(
                                              Routes.PROFILEPET,
                                              arguments:
                                                  profile, // Pasar el perfil de la mascota como argumento
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
              }),
            ),
            if (AuthServiceApis.dataCurrentUser.userType == 'user')
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ButtonDefaultWidget(
                  title: 'Nueva Mascota +',
                  callback: () async {
                    var result = await Get.toNamed(Routes.ADDPET);
                    if (result != null) {
                      controller.addProfile(result);
                    }
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
