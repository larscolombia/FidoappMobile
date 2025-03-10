import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pawlly/modules/components/registro.dart';
import 'package:pawlly/modules/integracion/controller/historial_clinico/historial_clinico_controller.dart';

import 'package:pawlly/modules/profile_pet/screens/confirmar_formulario.dart';
import 'package:pawlly/services/auth_service_apis.dart';

class HistorialGrid extends StatelessWidget {
  final HistorialClinicoController controller;

  const HistorialGrid({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Suponiendo que filteredHistorialClinico es un Rxn<List<PetHistory>>
      final historial = controller.filteredHistorialClinico;
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      if (historial.value.isEmpty) {
        return const Center(child: Text('No hay datos disponibles.'));
      }
      return GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 0.70,
        ),
        itemCount: historial.value.length,
        itemBuilder: (context, index) {
          final history = historial.value[index];
          return Registro(
            titulo: history.reportName ?? '',
            subtitulo: history.categoryName ?? '',
            fecha: history.createdAt.toString(),
            registroId: history.id.toString(),
            callback: () {
              controller.isEditing.value = true;
              Get.to(() => ConfirmarFormulario(
                    isEdit: AuthServiceApis.dataCurrentUser.userType == 'user'
                        ? true
                        : false,
                    historialClinico: history,
                  ));
            },
          );
        },
      );
    });
  }
}
