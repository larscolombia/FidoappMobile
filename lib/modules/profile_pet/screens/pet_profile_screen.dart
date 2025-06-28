import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pawlly/components/button_default_widget.dart';
import 'package:pawlly/modules/components/regresr_components.dart';
import 'package:pawlly/modules/components/style.dart';
import 'package:pawlly/modules/profile_pet/controllers/profile_pet_controller.dart';
import 'package:pawlly/modules/profile_pet/screens/pet_passport_form.dart';
import 'package:pawlly/modules/profile_pet/screens/widget/information_tab.dart';
import 'package:pawlly/modules/profile_pet/screens/widget/medical_histor_tab.dart';
import 'package:pawlly/services/auth_service_apis.dart';

class PetProfileScreen extends StatelessWidget {
  const PetProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Porcentaje de la pantalla que ocupará la imagen superior
    final size = MediaQuery.sizeOf(context);
    final double topImageHeight = size.height * 0.35;

    final ProfilePetController controller = Get.put(ProfilePetController());
    // final HomeController homeController = Get.find<HomeController>();
    // final PetControllerv2 petController = Get.put(PetControllerv2());

    // var body = Obx(() {
    var body = Stack(
      children: [
        /// 1) Imagen superior
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: topImageHeight,
          child: Obx(() {
            if (controller.profileImagePath.value.isEmpty) {
              return Image.asset(
                'assets/images/404.jpg', // Ruta de la imagen predeterminada
                fit: BoxFit.cover,
              );
            }

            final imageUrl = controller.profileImagePath.value;

            return CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              placeholder: (context, url) => const Center(
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
                      // color: Colors.white,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
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
                                  SizedBox(
                                    width: MediaQuery.sizeOf(context).width - 100,
                                    child: BarraBack(
                                      titulo: "Perfil de la Mascota",
                                      size: 20,
                                      callback: () => Get.back(),
                                    ),
                                  ),
                                  if (AuthServiceApis.dataCurrentUser.userType == 'user')
                                    ElevatedButton(
                                      onPressed: () {
                                        Get.to(const PetPassportForm());
                                      },
                                      style: ElevatedButton.styleFrom(
                                        elevation: 0,
                                        padding: EdgeInsets.zero,
                                        backgroundColor: Styles.colorContainer,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(15),
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
                              // Información
                              Obx(
                                () => ButtonDefaultWidget(
                                  title: 'Información',
                                  callback: () => controller.changeTab(0),
                                  widthButtom: (MediaQuery.sizeOf(context).width / 2) - 30,
                                  defaultColor:
                                      controller.selectedTab.value == 0 ? Styles.iconColorBack : Colors.white,
                                  textColor: controller.selectedTab.value == 0 ? Styles.whiteColor : Colors.black,
                                  border: controller.selectedTab.value == 0
                                      ? null
                                      : const BorderSide(color: Color(0xFFEFEFEF), width: 1),
                                  textSize: 14,
                                ),
                              ),
                              // Historial Médico
                              Obx(
                                () => ButtonDefaultWidget(
                                  title: 'Historial Médico',
                                  callback: () => controller.changeTab(1),
                                  widthButtom: (MediaQuery.sizeOf(context).width / 2) - 30,
                                  defaultColor:
                                      controller.selectedTab.value == 1 ? Styles.iconColorBack : Colors.white,
                                  textColor: controller.selectedTab.value == 1 ? Styles.whiteColor : Colors.black,
                                  border: controller.selectedTab.value == 1
                                      ? null
                                      : const BorderSide(color: Color(0xFFEFEFEF), width: 1),
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
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: body,
    );
  }
}
