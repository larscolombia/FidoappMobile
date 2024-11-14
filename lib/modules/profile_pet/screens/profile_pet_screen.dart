import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pawlly/components/button_default_widget.dart';
import 'package:pawlly/configs.dart';
import 'package:pawlly/models/event_model.dart';
import 'package:pawlly/modules/profile_pet/controllers/profile_pet_controller.dart';
import 'package:pawlly/modules/profile_pet/screens/widget/information_tab.dart';
import 'package:pawlly/modules/profile_pet/screens/widget/medical_histor_tab.dart';
import 'package:pawlly/modules/profile_pet/screens/widget/pet_info_modal.dart';

import 'package:pawlly/styles/styles.dart';

class ProfilePetScreen extends StatelessWidget {
  final ProfilePetController controller = Get.put(ProfilePetController());

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final imageSize = size.height / 4;
    // ignore: unused_local_variable

    return Scaffold(
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
                  errorWidget: (context, url, error) => Icon(Icons.error),
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
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: const Icon(
                                Icons.arrow_back_ios,
                                color: Styles.primaryColor,
                                size: 22,
                              ),
                            ),
                            const Text(
                              'Perfil de la Mascota',
                              style: Styles.dashboardTitle20,
                            ),
                            Obx(
                              () => ElevatedButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return PetInfoModal(
                                          controller:
                                              controller); // Pasa el controlador
                                    },
                                  );
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
                  const Divider(height: 40, thickness: 1),
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
