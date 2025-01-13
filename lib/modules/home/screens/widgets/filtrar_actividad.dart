import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:pawlly/components/button_default_widget.dart';
import 'package:pawlly/modules/components/style.dart';
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
      title: Column(
        children: [
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Filtrar por',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontFamily: 'Lato',
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Image.asset(
                      'assets/icons/x.png',
                      width: 20,
                      height: 20,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Divider(
                thickness: .2,
                color: Colors.grey,
              )
            ],
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                            controller.updateField('category_id', category);
                          } else {
                            controller.updateField('category_id', '');
                          }

                          controller.buscarIdCategoria(
                              controller.categoria_value(category));
                          Navigator.of(context).pop();
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(2),
                        ),
                        checkColor: Styles.colorContainer,
                        activeColor: Styles.primaryColor,
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
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Cerrar el diálogo sin aplicar
          },
          child: const Text('Cancelar',
              style: TextStyle(
                  color: Colors.black, fontSize: 12, fontFamily: 'Lato')),
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
