import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pawlly/components/button_default_widget.dart';
import 'package:pawlly/modules/integracion/controller/historial_clinico/historial_clinico_controller.dart';

class FilterDialog extends StatelessWidget {
  final HistorialClinicoController controller;

  const FilterDialog({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    // Variables para almacenar temporalmente los valores del rango de fechas
    final startDateController = TextEditingController();
    final endDateController = TextEditingController();
    final reportNameController = TextEditingController();

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
            const SizedBox(height: 16),
            const Text(
              'Ordenar por',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Obx(
              () => Column(
                children: controller.sortOptions.map((option) {
                  return Row(
                    children: [
                      Checkbox(
                        value: controller.selectedSortOption.value == option,
                        onChanged: (bool? value) {
                          controller.selectSortOption(option);
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
                      Text(option),
                    ],
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Categoría',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Obx(
              () => Column(
                children: controller.categories.map((category) {
                  return Row(
                    children: [
                      Checkbox(
                        value: controller.selectedCategory.value == category,
                        onChanged: (bool? value) {
                          controller.selectCategory(category);
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
          ],
        ),
      ),
      actions: [
        ButtonDefaultWidget(
          title: 'Filtrar',
          callback: () {
            // Extraer valores ingresados
            final reportName = reportNameController.text;
            final startDate = startDateController.text;
            final endDate = endDateController.text;

            // Aplicar los filtros en el controlador
            controller.filterHistorialClinico(
              reportName: reportName.isNotEmpty ? reportName : null,
              startDate: startDate.isNotEmpty ? startDate : null,
              endDate: endDate.isNotEmpty ? endDate : null,
              category: controller.selectedCategory.value,
            );

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

  static void show(
      BuildContext context, HistorialClinicoController controller) {
    showDialog(
      context: context,
      builder: (context) {
        return FilterDialog(controller: controller);
      },
    );
  }
}
