import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pawlly/components/button_default_widget.dart';
import 'package:pawlly/modules/integracion/controller/historial_clinico/historial_clinico_controller.dart';

class FilterDialog extends StatefulWidget {
  final HistorialClinicoController controller;

  const FilterDialog({super.key, required this.controller});

  @override
  State<FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  bool _isApplying = false;

  @override
  Widget build(BuildContext context) {
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
                children: widget.controller.sortOptions.map((option) {
                  return Row(
                    children: [
                      Checkbox(
                        value: widget.controller.selectedSortOption.value == option,
                        onChanged: (bool? value) {
                          widget.controller.selectSortOption(option);
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
                children: widget.controller.categories.map((category) {
                  return Row(
                    children: [
                      Checkbox(
                        value: widget.controller.selectedCategory.value == category,
                        onChanged: (bool? value) {
                          widget.controller.selectCategory(category);
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
          isLoading: _isApplying,
          callback: () {
            if (_isApplying) return;
            setState(() => _isApplying = true);
            final reportName = reportNameController.text;
            final startDate = startDateController.text;
            final endDate = endDateController.text;

            widget.controller.filterHistorialClinico(
              reportName: reportName.isNotEmpty ? reportName : null,
              startDate: startDate.isNotEmpty ? startDate : null,
              endDate: endDate.isNotEmpty ? endDate : null,
              category: widget.controller.selectedCategory.value,
            );

            Navigator.of(context).pop();
          },
        ),
        TextButton(
          onPressed: _isApplying
              ? null
              : () {
                  Navigator.of(context).pop();
                },
          child: const Text('Cancelar'),
        ),
      ],
    );
  }

  static Future<void> show(
      BuildContext context, HistorialClinicoController controller) {
    return showDialog(
      context: context,
      builder: (context) {
        return FilterDialog(controller: controller);
      },
    );
  }
}
