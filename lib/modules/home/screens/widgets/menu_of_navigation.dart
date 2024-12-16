import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pawlly/modules/home/controllers/home_controller.dart';
import 'package:pawlly/modules/integracion/util/role_user.dart';
import 'package:pawlly/services/auth_service_apis.dart';
import 'package:pawlly/styles/styles.dart';

class MenuOfNavigation extends GetView<HomeController> {
  final RoleUser roleUser = Get.put(RoleUser());
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Obx(
      () => Container(
        width: width,
        height: 75,
        decoration: BoxDecoration(
          color: Styles.primaryColor,
          borderRadius: BorderRadius.all(
            Radius.circular(66),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(
              path: 'assets/icons/inicio.png',
              label: 'Inicio',
              index: 0,
              controller: controller,
            ),
            _buildNavItem(
              path: 'assets/icons/calendario.png',
              label: 'Agenda',
              index: 1,
              controller: controller,
            ),
            _buildNavItem(
              path: 'assets/icons/diario.png',
              label: 'Diario',
              index: 4,
              controller: controller,
            ),
            if (roleUser.roleUser.value == roleUser.tipoUsuario('user') ||
                roleUser.roleUser.value == roleUser.tipoUsuario('entrenador'))
              _buildNavItem(
                path: 'assets/icons/entrenos.png',
                label: 'Entrenamiento',
                index: 2,
                controller: controller,
              ),
            _buildNavItem(
              path: 'assets/icons/explorar.png',
              label: 'Explorar',
              index: 3,
              controller: controller,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    String? path,
    required String label,
    required int index,
    required HomeController controller,
  }) {
    bool isSelected = controller.selectedIndex.value == index;

    return GestureDetector(
      onTap: () {
        controller.updateIndex(index);
        // controller.pantallas(index);
      },
      child: Container(
        decoration: isSelected
            ? BoxDecoration(
                color: Color.fromRGBO(252, 146, 20, 1),
                borderRadius: BorderRadius.circular(25),
              )
            : null,
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        child: Row(
          children: [
            Image.asset(
              path ?? 'assets/icons/aprendisaje.png',
              width: 24,
            ),
            if (isSelected) ...[
              SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: Styles.whiteColor,
                  fontFamily: 'Lato',
                  fontWeight: FontWeight.w400,
                  fontSize: 13,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
