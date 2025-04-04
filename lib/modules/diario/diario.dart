import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pawlly/components/input_busqueda.dart';
// import 'package:pawlly/modules/components/input_text.dart';
import 'package:pawlly/modules/components/recarga_componente.dart';
import 'package:pawlly/modules/components/regresr_components.dart';
// import 'package:pawlly/modules/components/reportar_mascota.dart';
import 'package:pawlly/modules/helper/helper.dart';
import 'package:pawlly/modules/home/controllers/home_controller.dart';
import 'package:pawlly/modules/home/screens/Diario/formulario_diario.dart';
import 'package:pawlly/modules/home/screens/Diario/index.dart';
import 'package:pawlly/modules/home/screens/pages/header_notification.dart';
import 'package:pawlly/modules/home/screens/pages/profile_dogs.dart';
import 'package:pawlly/modules/home/screens/widgets/filtrar_actividad.dart';
import 'package:pawlly/modules/home/screens/widgets/menu_of_navigation.dart';
import 'package:pawlly/modules/integracion/controller/diario/activida_mascota_controller.dart';
import 'package:pawlly/styles/styles.dart';

class Diario extends StatelessWidget {
  Diario({super.key});
  final HomeController homeController = Get.find<HomeController>();
  final PetActivityController historialClinicoController =
      Get.put(PetActivityController());

  @override
  Widget build(BuildContext context) {
    var margen = 16.00;
    var ancho = MediaQuery.of(context).size.width;

    // Asegurarse de no llamar a métodos que alteren el estado durante la construcción
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (homeController.selectedProfile.value != null) {
        historialClinicoController.fetchPetActivities(
            "${homeController.selectedProfile.value?.id ?? '-1'}");
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 148,
            decoration: const BoxDecoration(
              color: Styles.blackColor,
            ),
            child: HeaderNotification(),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                left: Helper.paddingDefault,
                right: Helper.paddingDefault,
                bottom: Helper.paddingDefault,
              ),
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ProfilesDogs(),
                      SizedBox(height: margen + 10),
                      SizedBox(
                        width: ancho,
                        child: BarraBack(
                          titulo: 'Registros en el Diario',
                          size: 20,
                          callback: () {
                            Get.back();
                          },
                        ),
                      ),
                      SizedBox(height: margen + 10),
                      SizedBox(
                        width: ancho,
                        child: Row(
                          children: [
                            Expanded(
                              flex: 11,
                              child: InputBusqueda(
                                onChanged: (value) => historialClinicoController
                                    .searchActivities(value),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              flex: 2,
                              child: ElevatedButton(
                                  onPressed: () {
                                    FiltrarActividad.show(
                                        context, historialClinicoController);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    padding: EdgeInsets.zero,
                                    backgroundColor: Styles.fiveColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      side: BorderSide(
                                        color: const Color(0xFFFC9214)
                                            .withOpacity(
                                                0.20), // Color del borde
                                        width: 0.55, // Grosor del borde
                                      ),
                                    ),
                                    minimumSize: const Size(58, 58),
                                  ),
                                  child: SvgPicture.asset(
                                    'assets/icons/svg/filters.svg',
                                    height: 25,
                                    width: 25,
                                  )),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: margen + 10),
                      SizedBox(
                        width: ancho,
                        child: DiarioMascotas(
                          homeController: homeController,
                          controller: historialClinicoController,
                        ),
                      ),
                      RecargaComponente(
                        callback: () {
                          historialClinicoController.fetchPetActivities(
                              "${homeController.selectedProfile.value?.id ?? '-1'}");
                        },
                      ),
                      SizedBox(height: margen + 10),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 10),
        child: FloatingActionButton(
          onPressed: () {
            Get.to(() => FormularioDiario());
          },
          elevation: 0,
          shape: const CircleBorder(),
          backgroundColor: Styles.primaryColor,
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
      bottomNavigationBar: Obx(
        () {
          if (homeController.selectedIndex.value == 5 ||
              homeController.selectedIndex.value == 6) {
            return const SizedBox(height: 0);
          }
          return Padding(
            padding: const EdgeInsets.only(left: 25, right: 25, bottom: 30),
            child: MenuOfNavigation(),
          );
        },
      ),
    );
  }
}
