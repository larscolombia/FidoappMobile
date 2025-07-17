import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pawlly/components/button_default_widget.dart';
import 'package:pawlly/modules/components/regresr_components.dart';
import 'package:pawlly/modules/components/style.dart';
import 'package:pawlly/modules/home/controllers/home_controller.dart';
import 'package:pawlly/modules/profile_pet/controllers/profile_pet_controller.dart';
import 'package:pawlly/modules/profile_pet/screens/pasaporte_mascota.dart';
import 'package:pawlly/modules/profile_pet/screens/widget/information_tab.dart';
import 'package:pawlly/modules/profile_pet/screens/widget/medical_histor_tab.dart';
import 'package:pawlly/services/auth_service_apis.dart';

class ProfilePetScreen extends StatelessWidget {
  ProfilePetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    // Porcentaje de la pantalla que ocupará la imagen superior
    final double topImageHeight = size.height * 0.35;

    final ProfilePetController controller = Get.put(ProfilePetController());
    final HomeController homeController = Get.find<HomeController>();
    final imageSize = size.height / 4;

    //final PetControllerv2 petController = Get.put(PetControllerv2());
    return Obx(() {
      // Verificar si hay una mascota seleccionada
      if (homeController.selectedProfile.value == null) {
        return Scaffold(
          backgroundColor: Styles.colorContainer,
          body: const Center(
            child: Text(
              'No hay mascota seleccionada',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
                fontFamily: 'Lato',
              ),
            ),
          ),
        );
      }

      var pet = homeController.selectedProfile.value!;
      
      return Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            /// 1) Imagen superior
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: topImageHeight,
              child: Stack(
                children: [
                  Obx(() {
                    final imageUrl = controller.profileImagePath.value.isNotEmpty
                        ? controller.profileImagePath.value
                        : 'https://via.placeholder.com/600x400';

                    return Container(
                      width: double.infinity,
                      height: double.infinity,
                      child: ClipRRect(
                        borderRadius: BorderRadius.zero, // Sin bordes redondeados para mantener consistencia
                        child: CachedNetworkImage(
                          imageUrl: imageUrl,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                          placeholder: (context, url) => Container(
                            width: double.infinity,
                            height: double.infinity,
                            color: Colors.grey[300],
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                          errorWidget: (context, url, error) {
                            // Imagen predeterminada si falla la carga
                            return Container(
                              width: double.infinity,
                              height: double.infinity,
                              color: Colors.grey[300],
                              child: Image.asset(
                                'assets/images/404.jpg',
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  }),
                  // Botón flotante para editar imagen
                  Positioned(
                    bottom: 50,
                    right: 20,
                    child: Obx(() => GestureDetector(
                      onTap: () async {
                        if (controller.isPickerActive.value) return; // Evitar múltiples taps
                        
                        await controller.pickImage();
                        
                        // Si se seleccionó una imagen y es diferente a la actual, actualizar solo la foto
                        if (controller.profileImagePath.value.isNotEmpty && 
                            controller.profileImagePath.value != pet.petImage) {
                          await controller.updatePetProfilePhoto();
                          // Actualizar la imagen en HomeController también
                          final homeController = Get.find<HomeController>();
                          homeController.refresh();
                        }
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Styles.iconColorBack,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: controller.isPickerActive.value
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 24,
                              ),
                      ),
                    )),
                  ),
                ],
              ),
            ),

            /// 2) Contenedor blanco superpuesto
            /// Se inicia un poco antes del final de la imagen (-40 px en lugar de -30)
            Positioned(
              top: topImageHeight - 40,
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                // Color de fondo y bordes redondeados en la parte superior
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                  // Pequeña sombra para que se note más el superpuesto
                ),
                child: CustomScrollView(
                  slivers: [
                    // Imagen de fondo

                    // Contenido del perfil
                    SliverToBoxAdapter(
                      child: Container(
                        padding: Styles.paddingAll,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(40)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Sección del Perfil
                            Container(
                              padding: const EdgeInsets.only(top: 20),
                              alignment: Alignment.center,
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width: MediaQuery.sizeOf(context).width -
                                            100,
                                        child: BarraBack(
                                          titulo: "Perfil de la Mascota",
                                          size: 20,
                                          callback: () => Get.back(),
                                        ),
                                      ),
                                      if (AuthServiceApis
                                              .dataCurrentUser.userType ==
                                          'user')
                                        ElevatedButton(
                                          onPressed: () {
                                            Get.to(PasaporteMascota());
                                          },
                                          style: ElevatedButton.styleFrom(
                                            elevation: 0,
                                            padding: EdgeInsets.zero,
                                            backgroundColor:
                                                Styles.colorContainer,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                            minimumSize: const Size(48, 48),
                                          ),
                                          child: SvgPicture.asset(
                                            'assets/icons/svg/edit-2.svg',
                                          ),
                                        )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            // Pestañas
                            Container(
                              margin: const EdgeInsets.only(top: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Obx(
                                    () => ButtonDefaultWidget(
                                      title: 'Información',
                                      callback: () => controller.changeTab(0),
                                      widthButtom:
                                          (MediaQuery.sizeOf(context).width /
                                                  2) -
                                              30,
                                      defaultColor:
                                          controller.selectedTab.value == 0
                                              ? Styles.iconColorBack
                                              : Colors.white,
                                      textColor: controller.selectedTab.value == 0
                                          ? Styles.whiteColor
                                          : Colors.black,
                                      border: controller.selectedTab.value == 0
                                          ? null
                                          : const BorderSide(
                                              color: Color(0xFFEFEFEF), width: 1),
                                      textSize: 14,
                                    ),
                                  ),
                                  Obx(
                                    () => ButtonDefaultWidget(
                                      title: 'Historial Médico',
                                      callback: () => controller.changeTab(1),
                                      widthButtom:
                                          (MediaQuery.sizeOf(context).width /
                                                  2) -
                                              30,
                                      defaultColor:
                                          controller.selectedTab.value == 1
                                              ? Styles.iconColorBack
                                              : Colors.white,
                                      textColor: controller.selectedTab.value == 1
                                          ? Styles.whiteColor
                                          : Colors.black,
                                      border: controller.selectedTab.value == 1
                                          ? null
                                          : const BorderSide(
                                              color: Color(0xFFEFEFEF), width: 1),
                                      textSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Divider(height: 40, thickness: .2),
                          ],
                        ),
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          Obx(() {
                            if (controller.selectedTab.value == 0) {
                              return InformationTab(controller: controller);
                            } else {
                              return MedicalHistoryTab(controller: controller);
                            }
                          }),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
