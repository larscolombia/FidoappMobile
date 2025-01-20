import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pawlly/components/button_default_widget.dart';
import 'package:pawlly/modules/components/recarga_componente.dart';
import 'package:pawlly/modules/home/controllers/home_controller.dart';
import 'package:pawlly/modules/home/screens/Diario/detalles_diario.dart';
import 'package:pawlly/modules/integracion/controller/diario/activida_mascota_controller.dart';
import 'package:pawlly/styles/recursos.dart';
import 'package:pawlly/styles/styles.dart';

class DiarioMascotas extends StatefulWidget {
  // Recibe el PetActivityController como parámetro
  final PetActivityController controller;
  final HomeController homeController;
  DiarioMascotas(
      {super.key, required this.controller, required this.homeController});

  @override
  State<DiarioMascotas> createState() => _DiarioMascotasState();
}

class _DiarioMascotasState extends State<DiarioMascotas> {
  @override
  void initState() {
    super.initState();
    // Ahora no es necesario llamar a fetchPetActivities aquí,
    // ya que el controlador ya debería tener los datos o puede ser llamado externamente.
    if (widget.homeController.selectedProfile.value != null &&
        widget.controller.filteredActivities.isEmpty) {
      widget.controller.fetchPetActivities(
          widget.homeController.selectedProfile.value!.id.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    // Usamos el controlador pasado a través del widget
    return Obx(() {
      // Solo vuelve a cargar las actividades si están vacías
      if (widget.controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (widget.controller.filteredActivities.isEmpty) {
        return const Center(child: Text('No hay actividades disponibles.'));
      }

      return SingleChildScrollView(
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(8.0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 5.0,
            mainAxisSpacing: 4.0,
            childAspectRatio: 0.66,
          ),
          itemCount: widget.controller.filteredActivities.length,
          itemBuilder: (context, index) {
            final actividad = widget.controller.filteredActivities[index];

            return Container(
              width: 200,
              height: 200,
              padding: const EdgeInsets.only(
                top: 26,
                left: 26,
                right: 26,
                bottom: 20,
              ),
              decoration: BoxDecoration(
                color: Styles.whiteColor,
                borderRadius: BorderRadius.circular(16),
                border: widget.controller.diario['actividadId'] == actividad.id
                    ? Border.all(color: Styles.primaryColor, width: 1)
                    : Border.all(color: Recursos.ColorBorderSuave, width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 83,
                    child: Text(
                      actividad.actividad ?? '',
                      style: const TextStyle(
                        fontSize: 18,
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    actividad.categoryName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.w700,
                      color: Styles.iconColorBack,
                    ),
                  ),
                  Text(
                    actividad.date.toString(),
                    style: const TextStyle(
                      fontSize: 12,
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.w500,
                      color: Color(0xff959595),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Registro Nro. ${actividad.id}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.w500,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                  const Spacer(),
                  const SizedBox(height: 4),
                  Center(
                    child: SizedBox(
                      height: 35,
                      width: 150,
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: ButtonDefaultWidget(
                          title: 'Abrir >',
                          callback: () {
                            widget.controller.getActivityById(actividad.id);
                            Get.to(() => DetallesDiario());
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
