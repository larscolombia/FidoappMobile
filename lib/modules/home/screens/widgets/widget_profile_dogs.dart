import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pawlly/components/button_default_widget.dart';
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
                  const Text(
                    'Selecciona un perfil',
                    style: TextStyle(
                      fontSize: 18,
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
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(
                          Icons.arrow_back_ios,
                          color: Styles.primaryColor,
                          size: 22,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Text(
                        'Lista de Mascotas',
                        style: Styles.dashboardTitle20,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
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
                  return ListView.builder(
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
                            children: [
                              // Imagen del perfil que ocupa exactamente el 50% del ancho del contenedor
                              Container(
                                width: (MediaQuery.of(context).size.width -
                                        64) *
                                    0.5, // Asegura que ocupe el 50% considerando los márgenes
                                height: 100,
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
                              // Contenido del perfil que ocupa el otro 50% del ancho
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      profile.name,
                                      style: const TextStyle(
                                        fontFamily: 'Lato',
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Styles.blackColor,
                                      ),
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
                                    const SizedBox(height: 4),
                                    Text(
                                      profile.gender,
                                      style: const TextStyle(
                                        fontFamily: 'Lato',
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        color: Styles.iconColorBack,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    ButtonDefaultWidget(
                                      heigthButtom: 40,
                                      borderSize: 30,
                                      title: 'Ver perfil >',
                                      callback: () {
                                        controller.updateProfile(profile);
                                        medicalHistoryController.updateField(
                                            "pet_id", profile.id.toString());

                                        Get.toNamed(
                                          Routes.PROFILEPET,
                                          arguments:
                                              profile, // Pasar el perfil de la mascota como argumento
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              }),
            ),
            if (AuthServiceApis.dataCurrentUser.userType == 'user')
              ButtonDefaultWidget(
                title: 'Nueva Mascota +',
                callback: () async {
                  var result = await Get.toNamed(Routes.ADDPET);
                  if (result != null) {
                    controller.addProfile(result);
                  }
                },
              ),
          ],
        ),
      ),
    );
  }
}
