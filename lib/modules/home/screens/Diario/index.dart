import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pawlly/components/button_default_widget.dart';
import 'package:pawlly/modules/components/registro.dart';
import 'package:pawlly/modules/home/controllers/home_controller.dart';
import 'package:pawlly/modules/home/screens/Diario/detalles_diario.dart';
import 'package:pawlly/modules/integracion/controller/diario/activida_mascota_controller.dart';
import 'package:pawlly/styles/recursos.dart';
import 'package:pawlly/styles/styles.dart';

class DiarioMascotas extends StatefulWidget {
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
    if (widget.homeController.selectedProfile.value != null &&
        widget.controller.filteredActivities.isEmpty) {
      widget.controller.fetchPetActivities(
          widget.homeController.selectedProfile.value!.id.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (widget.controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (widget.controller.filteredActivities.isEmpty) {
        return const Center(child: Text('No hay actividades disponibles.'));
      }

      return LayoutBuilder(
        builder: (context, constraints) {
          final crossAxisCount = constraints.maxWidth > 600 ? 3 : 2;

          return SingleChildScrollView(
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 5.0,
                mainAxisSpacing: 5.0,
                childAspectRatio: constraints.maxWidth > 600
                    ? 0.700
                    : 0.900, // Ajustar aquí el valor
              ),
              itemCount: widget.controller.filteredActivities.length,
              itemBuilder: (context, index) {
                final actividad = widget.controller.filteredActivities[index];

                return Registro(
                  titulo: actividad.actividad ?? '',
                  subtitulo: actividad.categoryName,
                  fecha: actividad.date.toString(),
                  registroId: actividad.id.toString(),
                  callback: () {
                    widget.controller.getActivityById(actividad.id);
                    Get.to(() => DetallesDiario());
                  },
                );
              },
            ),
          );
        },
      );
    });
  }
}
