import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pawlly/components/button_default_widget.dart';
import 'package:pawlly/modules/integracion/controller/diario/activida_mascota_controller.dart';

class FiltrarActividad extends StatelessWidget {
  final PetActivityController controller;

  const FiltrarActividad({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    // Variables para almacenar temporalmente los valores del rango de fechas y el nombre de la actividad
    final reportNameController = TextEditingController();
    final startDateController = TextEditingController();
    final endDateController = TextEditingController();

    return AlertDialog(
      backgroundColor: Colors.white,
      title: const Text(
        'Filtrar',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            const Text(
              'Categoría',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontFamily: 'Lato',
              ),
            ),
            const SizedBox(height: 8),
            Obx(
              () => Column(
                children: controller.categories.map((category) {
                  return Row(
                    children: [
                      Checkbox(
                        value: controller.diario['category_id'] == category,
                        onChanged: (bool? value) {
                          if (value == true) {
                            print('filtrar $value');
                            controller.updateField('category_id', category);
                          } else {
                            controller.updateField('category_id', '');
                          }
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(2),
                        ),
                        checkColor: Colors.white,
                        activeColor: Colors.black,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        visualDensity: VisualDensity.compact,
                      ),
                      const SizedBox(width: 8),
                      Text(category),
                    ],
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Ordenar por Fecha',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Obx(
              () => CheckboxListTile(
                title: const Text('Fecha de la más reciente a la más antigua'),
                value: controller.sortByDate.value,
                onChanged: (bool? value) {
                  controller.sortByDate.value = value ?? false;
                },
                controlAffinity: ListTileControlAffinity.leading,
                checkColor: Colors.white,
                activeColor: Colors.black,
              ),
            ),
          ],
        ),
      ),
      actions: [
        ButtonDefaultWidget(
          title: 'Aplicar Filtros',
          callback: () {
            // Extraer valores ingresados
            final reportName = reportNameController.text;

            // Aplicar los filtros en el controlador
            controller.filterPetActivities(reportName);

            Navigator.of(context).pop(); // Cerrar el diálogo
          },
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Cerrar el diálogo sin aplicar
          },
          child: const Text('Cancelar'),
        ),
      ],
    );
  }

  static void show(BuildContext context, PetActivityController controller) {
    showDialog(
      context: context,
      builder: (context) {
        return FiltrarActividad(controller: controller);
      },
    );
  }
}
