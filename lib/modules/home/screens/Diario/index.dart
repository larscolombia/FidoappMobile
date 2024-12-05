import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pawlly/components/button_default_widget.dart';
import 'package:pawlly/modules/home/controllers/home_controller.dart';
import 'package:pawlly/modules/integracion/controller/diario/activida_mascota_controller.dart';
import 'package:pawlly/styles/styles.dart';

class DiarioMascotas extends StatelessWidget {
  final PetActivityController controller = Get.put(PetActivityController());
  final HomeController homeController = Get.find<HomeController>();
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchPetActivities('${homeController.selectedProfile}');
    });

    return Obx(() {
      if (controller.isLoading.value) {
        // Muestra un indicador de carga mientras se están obteniendo los datos
        return Center(child: CircularProgressIndicator());
      }

      // Si el array está vacío, muestra un mensaje adecuado
      if (controller.activities.isEmpty) {
        return Center(child: Text('No hay actividades disponibles.'));
      }

      return SingleChildScrollView(
        child: GridView.builder(
          shrinkWrap:
              true, // Hace que el GridView ocupe solo el espacio necesario
          physics:
              NeverScrollableScrollPhysics(), // Desactiva el desplazamiento en el GridView
          padding: EdgeInsets.all(8.0),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
            childAspectRatio: 0.75, // Ajusta este valor según sea necesario
          ),
          itemCount: controller.activities.length,
          itemBuilder: (context, index) {
            final actividad = controller.activities[index];
            return Container(
              width: 145,
              height: 200,
              margin: EdgeInsets.symmetric(vertical: 8),
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Styles.whiteColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${actividad.notas}',
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '${actividad.actividad}',
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.w800,
                      color: Styles.iconColorBack,
                    ),
                  ),
                  Text(
                    '${actividad.date.toString()}',
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.w800,
                      color: const Color.fromARGB(255, 139, 137, 132),
                    ),
                  ),
                  Text(
                    'Registro Nro: ${actividad.id}',
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.w800,
                      color: const Color.fromARGB(255, 139, 137, 132),
                    ),
                  ),
                  Spacer(),
                  const SizedBox(height: 8),
                  Center(
                    child: Container(
                      height: 35,
                      width: 109,
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: ButtonDefaultWidget(
                          title: 'Ver detalles >',
                          callback: () {
                            print('Ver detalles >');
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );
    });
  }
}
