import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pawlly/modules/components/input_text_icon.dart';
import 'package:pawlly/modules/components/regresr_components.dart';
import 'package:pawlly/modules/components/seleccionar_mascota.dart';
import 'package:pawlly/modules/components/style.dart';
import 'package:pawlly/modules/home/controllers/home_controller.dart';
import 'package:pawlly/modules/home/screens/pages/header_notification.dart';
import 'package:pawlly/modules/integracion/controller/historial_clinico/historial_clinico_controller.dart';
import 'package:pawlly/routes/app_pages.dart';

class Pacientes extends StatelessWidget {
  Pacientes({super.key});
  final HomeController _homeController = Get.put(HomeController());
  final HistorialClinicoController medicalHistoryController =
      Get.put(HistorialClinicoController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      color: Styles.colorContainer,
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Positioned(top: 0, left: 0, right: 0, child: HeaderNotification()),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(0),
                  topRight: Radius.circular(0),
                ),
              ),
              child: CustomScrollView(
                slivers: [
                  SliverList(
                    delegate: SliverChildListDelegate([
                      const SizedBox(
                        height: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 350,
                            child: BarraBack(
                              titulo: 'Registro de Pacientes',
                              callback: () {
                                Get.back();
                              },
                            ),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: 350,
                            child: InputTextWithIcon(
                              hintText: 'Realiza tu búsqueda',
                              iconPath: 'assets/icons/svg/search-status.svg',
                              iconPosition: IconPosition.left,
                              height: 60.0, // Altura personalizada
                              onChanged: (value) =>
                                  _homeController.searchPetByName(value),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ]),
                  ),
                  Obx(() {
                    if (_homeController.profiles.isEmpty) {
                      return const SliverToBoxAdapter(
                        child: SizedBox(),
                      );
                    }
                    var pets = _homeController.filterPet;
                    return SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          var profile = pets[index];
                          var isSelected =
                              _homeController.selectedProfile.value == profile;
                          return GestureDetector(
                            onTap: () {
                              // Navegar a la vista correspondiente

                              _homeController.updateSelectedProfile(profile);
                              medicalHistoryController.updateField(
                                  "pet_id", profile.id.toString());

                              Get.toNamed(
                                Routes.PROFILEPET,
                                arguments:
                                    profile, // Pasar el perfil de la mascota como argumento
                              );
                            },
                            child: SeleccionarMascota(
                              name: profile.name,
                              edad: profile.age,
                              avatar: profile.petImage,
                            ),
                          );
                        },
                        childCount: pets.length,
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
