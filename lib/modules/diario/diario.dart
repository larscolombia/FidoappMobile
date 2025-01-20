import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pawlly/components/input_busqueda.dart';
import 'package:pawlly/modules/components/input_text.dart';
import 'package:pawlly/modules/components/recarga_componente.dart';
import 'package:pawlly/modules/components/regresr_components.dart';
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
    var margen = 16.0;
    var ancho =
        MediaQuery.of(context).size.width * 0.9; // Proporción más flexible
    var alturaAppBar = 148.0;
    var alturaFAB = 80.0; // Ajuste dinámico para el FAB

    return Scaffold(
      floatingActionButton: Container(
        margin: EdgeInsets.only(
            bottom: alturaFAB + 30), // Distancia del FAB desde el fondo
        child: FloatingActionButton(
          onPressed: () {
            Get.to(() => FormularioDiario());
          },
          shape: const CircleBorder(),
          backgroundColor: Styles.primaryColor,
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                width: double.infinity,
                height: alturaAppBar,
                decoration: const BoxDecoration(
                  color: Styles.blackColor,
                ),
                child: HeaderNotification(),
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 5),
                        SizedBox(width: ancho, child: ProfilesDogs()),
                        SizedBox(height: margen + 10),
                        SizedBox(
                          width: ancho,
                          child: BarraBack(
                            titulo: 'Registros en el Diario',
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
                                flex: 8,
                                child: InputBusqueda(
                                  onChanged: (value) =>
                                      historialClinicoController
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
                                    padding: EdgeInsets.zero,
                                    backgroundColor: Styles.fiveColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    minimumSize: const Size(48, 48),
                                  ),
                                  child: Image.asset('assets/icons/filtro.png'),
                                ),
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
                                "${homeController.selectedProfile.value!.id ?? '-1'}");
                          },
                        ),
                        SizedBox(height: margen + 100),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Obx(() {
            if (homeController.selectedIndex.value == 5 ||
                homeController.selectedIndex.value == 6) {
              return const SizedBox(height: 100);
            }
            return Positioned(
              left: 25,
              right: 25,
              bottom: 30, // Ajuste dinámico del menú
              child: MenuOfNavigation(),
            );
          }),
        ],
      ),
    );
  }
}
