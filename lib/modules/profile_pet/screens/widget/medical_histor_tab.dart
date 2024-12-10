import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pawlly/components/button_default_widget.dart';
import 'package:pawlly/components/custom_select_form_field_widget.dart';
import 'package:pawlly/modules/components/historia_componente.dart';
import 'package:pawlly/modules/components/input_select.dart';
import 'package:pawlly/modules/components/input_text_icon.dart';
import 'package:pawlly/modules/integracion/controller/categoria/categoria_controller.dart';
import 'package:pawlly/modules/integracion/controller/historial_clinico/historial_clinico_controller.dart';
import 'package:pawlly/modules/integracion/model/historial_clinico/historial_clinico_model.dart';
import 'package:pawlly/modules/profile_pet/controllers/profile_pet_controller.dart';
import 'package:pawlly/modules/profile_pet/screens/confirmar_formulario.dart';
import 'package:pawlly/modules/profile_pet/screens/form_historial.dart';
import 'package:pawlly/modules/profile_pet/screens/widget/show_filter_dialog.dart';
import 'package:pawlly/styles/styles.dart';

class MedicalHistoryTab extends StatelessWidget {
  final ProfilePetController controller;
  final HistorialClinicoController medicalHistoryController =
      Get.put(HistorialClinicoController());
  final CategoryController categoryController = Get.put(CategoryController());
  MedicalHistoryTab({required this.controller});

  String reporType(String? value) {
    switch (value) {
      case 'Vacunas':
        return '1';
      case 'Antiparasitante':
        return '2';
      case 'Antigarrapata':
        return '3';
      default:
        return '1';
    }
  }

  @override
  Widget build(BuildContext context) {
    medicalHistoryController.fetchHistorialClinico(controller.petProfile.id);
    return SingleChildScrollView(
      // Cambiamos a SingleChildScrollView para manejar el contenido desplazable
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /** para veterinario 
          Center(
            child: Container(
              width: 312,
              child: Container(
                width: 302,
                child: CustomSelectFormFieldWidget(
                  filcolorCustom: Styles.primaryColor,
                  textColor: Colors.white,
                  placeholder: 'Agregar nuevo informe',
                  controller: null,
                  items: [
                    'Vacunas',
                    'Antiparasitante',
                    'Antigarrapata',
                  ],
                  onChange: (value) {
                    medicalHistoryController.isEditing.value = false;
                    medicalHistoryController.updateField('report_name', value);
                    medicalHistoryController.updateField(
                        'report_type', reporType(value));
                    Get.off(FormularioRegistro());
                  },
                  icon: 'assets/icons/categori.png',
                ),
              ),
            ),
          ),*/
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
                  child: InputTextWithIcon(
                    hintText: 'Realiza tu búsqueda',
                    iconPath: 'assets/icons/search.png',
                    iconPosition: IconPosition.left,
                    height: 60.0, // Altura personalizada
                    onChanged: (value) {
                      medicalHistoryController.filterHistorialClinico(value);
                    },
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    FilterDialog.show(context, medicalHistoryController);
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
              if (historial.value.isEmpty) {
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
                    id: history.id.toString(),
                    callback: () {
                      // aqui historia clinica
                      medicalHistoryController.updateField(
                          'pet_id', history.petId);
                      medicalHistoryController.updateField(
                          'report_type', history.reportType);
                      medicalHistoryController.updateField(
                          'report_name', history.reportName);
                      medicalHistoryController.updateField(
                          'notes', history.notes);
                      medicalHistoryController.updateField(
                          'name', history.petName);
                      medicalHistoryController.updateField(
                          'weight', history.weight);
                      medicalHistoryController.updateField(
                          'date', history.fechaAplicacion);
                      medicalHistoryController.updateField(
                          'category', history.categoryName);

                      medicalHistoryController.isEditing.value = true;

                      Get.to(ConfirmarFormulario());
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
