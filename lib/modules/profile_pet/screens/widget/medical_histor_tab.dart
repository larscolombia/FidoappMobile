import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pawlly/components/button_default_widget.dart';
import 'package:pawlly/components/custom_select_form_field_widget.dart';
import 'package:pawlly/modules/components/historia_componente.dart';
import 'package:pawlly/modules/components/historia_grid.dart';
import 'package:pawlly/modules/components/input_select.dart';
import 'package:pawlly/modules/components/input_text_icon.dart';
import 'package:pawlly/modules/components/recarga_componente.dart';
import 'package:pawlly/modules/components/registro.dart';
import 'package:pawlly/modules/helper/helper.dart';
import 'package:pawlly/modules/home/controllers/home_controller.dart';
import 'package:pawlly/modules/integracion/controller/categoria/categoria_controller.dart';
import 'package:pawlly/modules/integracion/controller/historial_clinico/historial_clinico_controller.dart';
import 'package:pawlly/modules/integracion/model/historial_clinico/historial_clinico_model.dart';
import 'package:pawlly/modules/integracion/util/role_user.dart';
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
  final RoleUser roleUser = Get.find<RoleUser>();
  final HomeController homeController = Get.find<HomeController>();
  MedicalHistoryTab({super.key, required this.controller});

  String reporType(String? value) {
    switch (value) {
      case '1':
        return 'Vacunas';
      case '2':
        return 'Antiparasitante';
      case '3':
        return 'Antigarrapata';
      default:
        return '1';
    }
  }

  @override
  Widget build(BuildContext context) {
    medicalHistoryController.fetchHistorialClinico(controller.petProfile.id);
    var ancho = MediaQuery.of(context).size.width;
    var margen = Helper.margenDefault;
    return SingleChildScrollView(
      // Cambiamos a SingleChildScrollView para manejar el contenido desplazable
      child: Padding(
        padding: Styles.paddingAll,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (roleUser.roleUser.value == roleUser.tipoUsuario('vet'))
              SizedBox(
                width: ancho,
                child: SizedBox(
                  width: ancho,
                  child: Column(
                    children: [
                      InputSelect(
                        onChanged: (value) {
                          medicalHistoryController.reseterReportData();
                          medicalHistoryController.isEditing.value = false;
                          medicalHistoryController.updateField(
                              'report_name', reporType(value));
                          medicalHistoryController.updateField(
                              'report_type', int.parse(value ?? '1'));
                          Get.to(
                            () => FormularioRegistro(),
                          );
                        },
                        TextColor: Colors.white,
                        borderColor: Styles.primaryColor,
                        color: Styles.primaryColor,
                        placeholder: 'Agregar nuevo informe',
                        prefiIconSVG: 'assets/icons/svg/document-text.svg',
                        suffixIcon: "assets/icons/svg/plus.svg",
                        iconColor: Colors.white, // Set icon color to white
                        textAlignment: TextAlignment.left,
                        fonsize: 16,
                        items: const [
                          DropdownMenuItem(
                            value: '1',
                            child: Text('Vacunas', style: Helper.selectStyle),
                          ),
                          DropdownMenuItem(
                            value: '2',
                            child: Text('Antiparasitante',
                                style: Helper.selectStyle),
                          ),
                          DropdownMenuItem(
                            value: '3',
                            child: Text('Antigarrapata',
                                style: Helper.selectStyle),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            // Título
            SizedBox(height: margen),
            const Text(
              'Historia Clínica',
              style: Styles.dashboardTitle20,
            ),
            const SizedBox(height: 16),
            // Barra de búsqueda y botón de filtro
            Row(
              children: [
                Expanded(
                  child: InputTextWithIcon(
                    hintText: 'Realiza tu búsqueda',
                    iconPath: 'assets/icons/search.png',
                    iconPosition: IconPosition.left,
                    height: 60.0, // Altura personalizada
                    onChanged: (value) {
                      medicalHistoryController.filterHistorialClinico(
                        reportName: value,
                      );
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
            const SizedBox(
              height: 20,
            ),
            HistorialGrid(controller: medicalHistoryController),
            SizedBox(height: margen),
            RecargaComponente(
              callback: () {
                medicalHistoryController.fetchHistorialClinico(
                    homeController.selectedProfile.value!.id);
              },
            ),
            SizedBox(height: margen * 3),
          ],
        ),
      ),
    );
  }
}
