import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pawlly/components/button_default_widget.dart';
import 'package:pawlly/modules/components/recarga_componente.dart';
import 'package:pawlly/modules/home/controllers/home_controller.dart';
import 'package:pawlly/modules/home/screens/Diario/detalles_diario.dart';
import 'package:pawlly/modules/integracion/controller/diario/activida_mascota_controller.dart';
import 'package:pawlly/styles/styles.dart';

class DiarioMascotas extends StatelessWidget {
  final PetActivityController controller = Get.put(PetActivityController());
  final HomeController homeController = Get.find<HomeController>();

  DiarioMascotas({super.key});
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (homeController.selectedProfile.value != null) {
        controller.fetchPetActivities(
            homeController.selectedProfile.value!.id.toString());
      }
    });

    return Obx(() {
      if (controller.isLoading.value) {
        // Muestra un indicador de carga mientras se están obteniendo los datos
        return const Center(child: CircularProgressIndicator());
      }

      // Si el array está vacío, muestra un mensaje adecuado
      if (controller.filteredActivities.isEmpty) {
        return const Center(child: Text('No hay actividades disponibles.'));
      }

      return SingleChildScrollView(
        child: GridView.builder(
          shrinkWrap:
              true, // Hace que el GridView ocupe solo el espacio necesario
          physics:
              const NeverScrollableScrollPhysics(), // Desactiva el desplazamiento en el GridView
          padding: const EdgeInsets.all(8.0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 5.0,
            mainAxisSpacing: 4.0,
            childAspectRatio: 0.75, // Ajusta este valor según sea necesario
          ),
          itemCount: controller.filteredActivities.length,
          itemBuilder: (context, index) {
            final actividad = controller.filteredActivities[index];
            print('ultimo id ${controller.diario['actividadId']}');
            return Container(
              width: MediaQuery.of(context).size.width,
              height: 200,
              margin: const EdgeInsets.symmetric(vertical: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Styles.whiteColor,
                borderRadius: BorderRadius.circular(10),
                border: controller.diario['actividadId'] == actividad.id
                    ? Border.all(color: Styles.primaryColor, width: 1)
                    : Border.all(color: Colors.black, width: .2),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    actividad.actividad,
                    style: const TextStyle(
                      fontSize: 18,
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    actividad.notas,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.w800,
                      color: Styles.iconColorBack,
                    ),
                  ),
                  Text(
                    actividad.date.toString(),
                    style: const TextStyle(
                      fontSize: 14,
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.w800,
                      color: Color.fromARGB(255, 139, 137, 132),
                    ),
                  ),
                  Text(
                    'Registro Nro: ${actividad.id}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.w800,
                      color: Color.fromARGB(255, 139, 137, 132),
                    ),
                  ),
                  const Spacer(),
                  const SizedBox(height: 8),
                  Center(
                    child: SizedBox(
                      height: 35,
                      width: 150,
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: ButtonDefaultWidget(
                          title: 'Ver detalles >',
                          callback: () {
                            controller.getActivityById(actividad.id);
                            Get.to(DetallesDiario());
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            );
          },
        ),
      );
    });
  }
}
