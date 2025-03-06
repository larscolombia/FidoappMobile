import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:pawlly/components/button_default_widget.dart';
import 'package:pawlly/modules/components/style.dart';
import 'package:pawlly/modules/integracion/controller/diario/activida_mascota_controller.dart';

class FiltrarActividad extends StatefulWidget {
  final PetActivityController controller;

  const FiltrarActividad({Key? key, required this.controller})
      : super(key: key);

  @override
  State<FiltrarActividad> createState() => _FiltrarActividadState();

  static void show(BuildContext context, PetActivityController controller) {
    showDialog(
      context: context,
      builder: (context) {
        return FiltrarActividad(controller: controller);
      },
    );
  }
}

class _FiltrarActividadState extends State<FiltrarActividad> {
  /// Opciones de orden
  final List<String> sortingOptions = ["Más recientes", "A - Z", "Z - A"];
  String? selectedSorting;

  /// Control de "ver más" en Categoría
  bool showMoreCategories = false;

  /// Opciones de fecha (chips)
  final List<String> dateChips = [
    "Hace 1 año",
    "Hace 2 meses",
    "Hace 1 semana"
  ];
  String? selectedDateChip;

  @override
  void initState() {
    super.initState();
    // Si tienes un valor inicial para sorting, asígalo aquí
    // selectedSorting = "Más recientes";
  }

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;

    return AlertDialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      backgroundColor: Colors.white,
      contentPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      content: Container(
        width: 300, // Ajusta el ancho del popup
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Encabezado: "Filtrar por" + botón cerrar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Filtrar por',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontFamily: 'Lato',
                    ),
                  ),
                  InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    child: Image.asset(
                      'assets/icons/x.png',
                      width: 20,
                      height: 20,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),
              const Divider(thickness: 0.5, color: Colors.grey),

              /// Sección Orden
              const SizedBox(height: 8),
              const Text(
                'Ordenar',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontFamily: 'Lato',
                ),
              ),
              const SizedBox(height: 8),
              Column(
                children: sortingOptions.map((option) {
                  return Row(
                    children: [
                      Radio<String>(
                        value: option,
                        groupValue: selectedSorting,
                        onChanged: (value) {
                          setState(() {
                            selectedSorting = value;
                          });
                          // Lógica para filtrar o actualizar algo...
                        },
                        activeColor: Styles.primaryColor,
                        visualDensity: VisualDensity.compact,
                      ),
                      Text(option),
                    ],
                  );
                }).toList(),
              ),

              const SizedBox(height: 16),
              const Divider(thickness: 0.5, color: Colors.grey),

              /// Sección Categoría
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
                () {
                  // Mostramos solo algunas categorías si no está en "ver más"
                  final maxToShow = showMoreCategories
                      ? controller.categories.length
                      : 4; // 4 es un ejemplo
                  final categoriesToShow =
                      controller.categories.take(maxToShow).toList();

                  return Column(
                    children: [
                      ...categoriesToShow.map((category) {
                        return Row(
                          children: [
                            Checkbox(
                              value:
                                  controller.diario['category_id'] == category,
                              onChanged: (bool? value) {
                                if (value == true) {
                                  controller.updateField(
                                      'category_id', category);
                                } else {
                                  controller.updateField('category_id', '');
                                }
                                // Lógica interna
                                controller.buscarIdCategoria(
                                  controller.categoria_value(category),
                                );
                                // Si quieres cerrar el modal al seleccionar:
                                // Navigator.of(context).pop();
                                setState(() {});
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(2),
                              ),
                              checkColor: Styles.colorContainer,
                              activeColor: Styles.primaryColor,
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              visualDensity: VisualDensity.compact,
                            ),
                            const SizedBox(width: 8),
                            Text(category),
                          ],
                        );
                      }).toList(),

                      // Botón "Ver más / Ver menos"
                      if (controller.categories.length > 4)
                        Align(
                          alignment: Alignment.centerLeft,
                          child: TextButton(
                            onPressed: () {
                              setState(() {
                                showMoreCategories = !showMoreCategories;
                              });
                            },
                            child: Text(
                                showMoreCategories ? 'Ver menos' : 'Ver más'),
                          ),
                        ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 16),
              const Divider(thickness: 0.5, color: Colors.grey),

              /// Sección Fecha
              const SizedBox(height: 8),
              const Text(
                'Fecha',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontFamily: 'Lato',
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ...dateChips.map((dateLabel) {
                    final isSelected = (selectedDateChip == dateLabel);
                    return ChoiceChip(
                      label: Text(dateLabel),
                      selected: isSelected,
                      selectedColor: Styles.primaryColor,
                      onSelected: (bool selected) {
                        setState(() {
                          selectedDateChip = selected ? dateLabel : null;
                        });
                        // Lógica para filtrar por fecha
                      },
                      backgroundColor: const Color.fromARGB(255, 245, 245, 245),
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                      ),
                    );
                  }),
                ],
              ),

              const SizedBox(height: 24),

              // Botón "Filtrar"
              Center(
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Styles.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () {
                      // Aplica la lógica de filtrar
                      // y cierra el diálogo
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'Filtrar',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
