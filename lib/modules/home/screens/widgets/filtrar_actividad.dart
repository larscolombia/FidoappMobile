import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pawlly/modules/components/custom_checkbox.dart';
import 'package:pawlly/modules/components/style.dart';
import 'package:pawlly/modules/helper/helper.dart';
import 'package:pawlly/modules/integracion/controller/diario/activida_mascota_controller.dart';

class FiltrarActividad extends StatefulWidget {
  final PetActivityController controller;

  const FiltrarActividad({super.key, required this.controller});

  static void show(BuildContext context, PetActivityController controller) {
    showDialog(
      context: context,
      builder: (context) {
        return FiltrarActividad(controller: controller);
      },
    );
  }

  @override
  State<FiltrarActividad> createState() => _FiltrarActividadState();
}

class _FiltrarActividadState extends State<FiltrarActividad> {
  /// Opciones de orden
  final List<String> sortingOptions = ["Más recientes", "A-Z", "Z-A"];
  String? selectedSorting;

  /// Opciones de fecha (chips)
  final List<String> dateChips = [
    "Hace 1 año",
    "Hace 2 meses",
    "Hace 1 semana"
  ];
  String? selectedDateChip;

  /// Para "Ver más" en Categoría
  bool showMoreCategories = false;

  /// Categoría seleccionada
  String? selectedCategory;

  @override
  void initState() {
    super.initState();
    // Si quieres un valor por defecto, puedes asignarlo aquí
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
        borderRadius: BorderRadius.circular(28),
      ),
      content: Container(
        width: 302, // Ajusta ancho del popup
        height: 581,
        padding: const EdgeInsets.all(Helper.paddingDefault),

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
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontFamily: 'Lato',
                    ),
                  ),
                  Helper.closeButton(context),
                ],
              ),

              const SizedBox(height: 5),
              const Divider(thickness: 0.5, color: Helper.dividerColor),

              Column(
                children: sortingOptions.map((option) {
                  bool isSelected = (selectedSorting == option);
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      // Usamos Row para alinear el checkbox y el texto
                      children: [
                        CustomCheckbox(
                          // Usamos tu CustomCheckbox con padding interno
                          isChecked:
                              isSelected, // Cambiamos 'value' por 'isChecked'
                          onChanged: (bool newValue) {
                            // Cambiamos 'bool? newValue' por 'bool newValue'
                            setState(() {
                              if (newValue == true) {
                                selectedSorting = option;
                              } else {
                                selectedSorting = null;
                              }
                            });
                          },
                        ),
                        const SizedBox(
                            width: 8), // Espacio entre el checkbox y el texto
                        Text(
                          option,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                            fontFamily: 'Lato',
                          ),
                        ), // Texto al lado del checkbox
                      ],
                    ),
                  );
                }).toList(),
              ),

              /// Sección Categoría
              const SizedBox(height: 4),
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
              Obx(() {
                // Podrías mostrar solo 3 o 4 categorías si no está en "ver más"
                final maxToShow =
                    showMoreCategories ? controller.categories.length : 3;
                final categoriesToShow =
                    controller.categories.take(maxToShow).toList();

                return Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          CustomCheckbox(
                            isChecked: false,
                            onChanged: (bool newValue) {},
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Informe médico',
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'Lato',
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    ...categoriesToShow.map((category) {
                      bool isSelected = (selectedCategory == category);
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8, left: 14.00),
                        child: Row(
                          children: [
                            CustomCheckbox(
                              isChecked: isSelected,
                              onChanged: (bool newValue) {
                                if (newValue) {
                                  setState(() {
                                    selectedCategory = category;
                                  });
                                } else if (selectedCategory == category) {
                                  setState(() {
                                    selectedCategory = null;
                                  });
                                }
                              },
                            ),
                            const SizedBox(width: 8),
                            Text(
                              category,
                              style: const TextStyle(
                                fontSize: 14,
                                fontFamily: 'Lato',
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                    if (controller.categories.length > 3)
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
              }),

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
                      selectedColor: Colors.grey,
                      onSelected: (bool selected) {
                        setState(() {
                          selectedDateChip = selected ? dateLabel : null;
                        });
                      },
                      backgroundColor:
                          isSelected ? Colors.grey : Styles.colorContainer,
                      labelStyle: TextStyle(
                        fontFamily: Helper.funte1,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.white : Styles.iconColor,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(
                          color:
                              isSelected ? Colors.white : Styles.colorContainer,
                          width: .5,
                        ),
                      ),
                      showCheckmark: false, // Quitamos la palomita
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
                      // 1. Llamamos a applyFilters en el controlador
                      widget.controller.applyFilters(
                        categoryName: selectedCategory,
                        sortType: selectedSorting,
                        dateLabel: selectedDateChip,
                      );

                      // 2. Cerrar el diálogo
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
