import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pawlly/components/button_default_widget.dart';
import 'package:pawlly/modules/components/historia_componente.dart';
import 'package:pawlly/modules/components/input_select.dart';
import 'package:pawlly/modules/integracion/controller/categoria/categoria_controller.dart';
import 'package:pawlly/modules/integracion/controller/historial_clinico/historial_clinico_controller.dart';
import 'package:pawlly/modules/integracion/model/historial_clinico/historial_clinico_model.dart';
import 'package:pawlly/modules/profile_pet/controllers/profile_pet_controller.dart';
import 'package:pawlly/modules/profile_pet/screens/form_historial.dart';
import 'package:pawlly/modules/profile_pet/screens/widget/show_filter_dialog.dart';
import 'package:pawlly/styles/styles.dart';

class MedicalHistoryTab extends StatelessWidget {
  final ProfilePetController controller;
  final HistorialClinicoController medicalHistoryController =
      Get.put(HistorialClinicoController());
  final CategoryController categoryController = Get.put(CategoryController());
  MedicalHistoryTab({required this.controller});

  @override
  Widget build(BuildContext context) {
    medicalHistoryController.fetchHistorialClinico(controller.petProfile.id);
    return SingleChildScrollView(
      // Cambiamos a SingleChildScrollView para manejar el contenido desplazable
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 312,
              child: Container(
                width: 302,
                child: InputSelect(
                  prefiIcon: Icon(
                    Icons.file_copy,
                    color: Colors.white,
                    size: 24,
                  ),
                  placeholder: 'Agregar nuevo informe',
                  color: Styles.primaryColor,
                  TextColor: Colors.white,
                  onChanged: (value) {
                    medicalHistoryController.updateField("report_type", value);
                    Get.to(FormularioRegistro());
                  },
                  items: const [
                    DropdownMenuItem(
                      value: "1",
                      child: Text('Vacunas'),
                    ),
                    DropdownMenuItem(
                      value: '2',
                      child: Text('Antiparasitante'),
                    ),
                    DropdownMenuItem(
                      value: '3',
                      child: Text('com'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Título
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Historia Clínica',
              style: Styles.dashboardTitle20,
            ),
          ),
          const SizedBox(height: 1),
          // Barra de búsqueda y botón de filtro

          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller.searchController,
                    enabled: true,
                    obscureText: false,
                    decoration: InputDecoration(
                      hintText: 'Realiza tu búsqueda',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          'assets/icons/ic_search2.png',
                          width: 20,
                          height: 20,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    FilterDialog.show(context, controller);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    backgroundColor: Styles.fiveColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    minimumSize: const Size(48, 48),
                  ),
                  child: const Icon(
                    Icons.filter_list,
                    color: Styles.iconColorBack,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Obx(() {
              final historial = medicalHistoryController.historialClinico;
              if (medicalHistoryController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              if (historial.isEmpty) {
                return const Center(child: Text('No hay datos disponibles.'));
              }

              return GridView.builder(
                physics:
                    const NeverScrollableScrollPhysics(), // Desactivar el scroll del GridView
                shrinkWrap:
                    true, // Permitir que el GridView se ajuste al contenido
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 0.70,
                ),
                itemCount: historial.length,
                itemBuilder: (context, index) {
                  final history = historial[index];
                  return HistoriaMascotaComponent(
                    reportName: history.reportName,
                    categoryName: history.categoryName,
                    applicationDate: history.applicationDate,
                    callback: () {
                      // Acción para abrir el detalle del informe
                    },
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
