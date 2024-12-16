import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pawlly/components/button_default_widget.dart';
import 'package:pawlly/configs.dart';
import 'package:pawlly/models/event_model.dart';
import 'package:pawlly/modules/components/regresr_components.dart';
import 'package:pawlly/modules/home/screens/home_screen.dart';
import 'package:pawlly/modules/integracion/controller/mascotas/mascotas_controller.dart';
import 'package:pawlly/modules/profile_pet/controllers/profile_pet_controller.dart';
import 'package:pawlly/modules/profile_pet/screens/widget/information_tab.dart';
import 'package:pawlly/modules/profile_pet/screens/widget/medical_histor_tab.dart';
import 'package:pawlly/modules/profile_pet/screens/widget/pet_info_modal.dart';
import 'package:pawlly/services/auth_service_apis.dart';

import 'package:pawlly/styles/styles.dart';

class ProfilePetScreen extends StatelessWidget {
  final ProfilePetController controller = Get.put(ProfilePetController());
  //final PetControllerv2 petController = Get.put(PetControllerv2());

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final imageSize = size.height / 4;
    // ignore: unused_local_variable
    //petController.showPet();
    print(' que esta pasando ?${controller.profileImagePath.value.isNotEmpty}');
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // Imagen de fondo
          SliverAppBar(
            expandedHeight: imageSize + 36,
            flexibleSpace: FlexibleSpaceBar(
              background: Obx(() {
                final imageUrl = controller.profileImagePath.value.isNotEmpty
                    ? controller.profileImagePath.value
                    : 'https://via.placeholder.com/600x400';

                return CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) {
                    // Imagen predeterminada si falla la carga
                    return Image.asset(
                      'assets/images/404.jpg', // Ruta de la imagen predeterminada
                      fit: BoxFit.cover,
                    );
                  },
                );
              }),
            ),
            pinned: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),

          // Contenido del perfil
          SliverToBoxAdapter(
            child: Container(
              padding: Styles.paddingAll,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            BarraBack(
                              titulo: "Perfil de la Mascotas",
                              callback: () => Get.off(HomeScreen()),
                            ),
                            if (AuthServiceApis.dataCurrentUser.userType ==
                                'user')
                              Obx(
                                () => ElevatedButton(
                                  onPressed: () {
                                    /**
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return PetInfoModal(
                                          controller:
                                              controller); // Pasa el controlador
                                    },
                                  );*/
                                  },
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    backgroundColor: controller.isEditing.value
                                        ? Styles.iconColorBack
                                        : Styles.greyTextColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    minimumSize: const Size(48, 48),
                                  ),
                                  child: const Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                              ),
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
                                (MediaQuery.of(context).size.width / 2) - 30,
                            defaultColor: controller.selectedTab.value == 0
                                ? Styles.iconColorBack
                                : Colors.transparent,
                            textColor: controller.selectedTab.value == 0
                                ? Styles.whiteColor
                                : Colors.black,
                            border: controller.selectedTab.value == 0
                                ? null
                                : const BorderSide(
                                    color: Colors.grey, width: 1),
                            textSize: 14,
                          ),
                        ),
                        Obx(
                          () => ButtonDefaultWidget(
                            title: 'Historial Médico',
                            callback: () => controller.changeTab(1),
                            widthButtom:
                                (MediaQuery.of(context).size.width / 2) - 30,
                            defaultColor: controller.selectedTab.value == 1
                                ? Styles.iconColorBack
                                : Colors.transparent,
                            textColor: controller.selectedTab.value == 1
                                ? Styles.whiteColor
                                : Colors.black,
                            border: controller.selectedTab.value == 1
                                ? null
                                : const BorderSide(
                                    color: Colors.grey, width: 1),
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
    );
  }
}
