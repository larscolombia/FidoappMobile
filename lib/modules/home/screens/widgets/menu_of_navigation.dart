import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pawlly/modules/home/controllers/home_controller.dart';
import 'package:pawlly/modules/integracion/util/role_user.dart';
import 'package:pawlly/styles/styles.dart';

class MenuOfNavigation extends GetView<HomeController> {
  final RoleUser roleUser = Get.put(RoleUser());

  MenuOfNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    // Se usa LayoutBuilder para obtener las dimensiones disponibles.
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        // Definimos un breakpoint para mostrar/ocultar la etiqueta.
        final showLabel = width > 350;
        return Obx(
          () => Container(
            width: width,
            height: 75,
            decoration: const BoxDecoration(
              color: Styles.primaryColor,
              borderRadius: BorderRadius.all(
                Radius.circular(66),
              ),
            ),
            // Agregamos un poco de padding horizontal si es necesario
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildNavItem(
                  path: 'assets/icons/inicio.png',
                  label: 'Inicio',
                  index: 0,
                  controller: controller,
                  showLabel: showLabel,
                ),
                _buildNavItem(
                  path: 'assets/icons/calendario.png',
                  label: 'Agenda',
                  index: 1,
                  controller: controller,
                  showLabel: showLabel,
                ),
                _buildNavItem(
                  path: 'assets/icons/diario.png',
                  label: 'Diario',
                  index: 4,
                  controller: controller,
                  showLabel: showLabel,
                ),
                if (roleUser.roleUser.value == roleUser.tipoUsuario('user') ||
                    roleUser.roleUser.value ==
                        roleUser.tipoUsuario('entrenador'))
                  _buildNavItem(
                    path: 'assets/icons/entrenos.png',
                    label: 'Entrenamiento',
                    index: 2,
                    controller: controller,
                    showLabel: showLabel,
                  ),
                _buildNavItem(
                  path: 'assets/icons/explorar.png',
                  label: 'Explorar',
                  index: 3,
                  controller: controller,
                  showLabel: showLabel,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildNavItem({
    String? path,
    required String label,
    required int index,
    required HomeController controller,
    required bool showLabel,
  }) {
    // Determinamos si este ítem está seleccionado
    final bool isSelected = controller.selectedIndex.value == index;

    return GestureDetector(
      onTap: () {
        controller.updateIndex(index);
        // Aquí puedes agregar lógica adicional de navegación si fuese necesario.
      },
      child: Container(
        decoration: isSelected
            ? BoxDecoration(
                color: const Color.fromRGBO(252, 146, 20, 1),
                borderRadius: BorderRadius.circular(25),
              )
            : null,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              path ?? 'assets/icons/aprendisaje.png',
              width: 24,
              height: 24,
            ),
            // Solo se muestra la etiqueta si hay espacio (showLabel == true)
            if (isSelected && showLabel) ...[
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Styles.whiteColor,
                    fontFamily: 'Lato',
                    fontWeight: FontWeight.w400,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
