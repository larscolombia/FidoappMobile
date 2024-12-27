import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pawlly/modules/components/input_text.dart';
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
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              color: Styles.colorContainer,
            ),
            height: 200,
            child: HeaderNotification(),
          ),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
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
                            width: MediaQuery.of(context).size.width - 100,
                            child: BarraBack(
                              titulo: 'Registro de Pacientes',
                              callback: () {
                                Get.back();
                              },
                            ),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: MediaQuery.of(context).size.width - 100,
                            child: InputText(
                              placeholder: 'Realizar búsqueda',
                              onChanged: (value) => print(value),
                              fondoColor: Colors.white,
                              prefiIcon: const Icon(
                                Icons.search,
                              ),
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
                    var pets = _homeController.profiles;
                    return SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          var profile = pets[index];
                          var isSelected =
                              _homeController.selectedProfile.value == profile;
                          return GestureDetector(
                            onTap: () {
                              // Navegar a la vista correspondiente

                              _homeController.updateProfile(profile);
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
