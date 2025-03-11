import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pawlly/modules/diario/diario.dart';
import 'package:pawlly/modules/home/controllers/home_controller.dart';
import 'package:pawlly/modules/home/screens/home_screen.dart';
import 'package:pawlly/modules/integracion/util/role_user.dart';
import 'package:pawlly/styles/styles.dart';

class MenuOfNavigation extends GetView<HomeController> {
  final RoleUser roleUser = Get.put(RoleUser());

  MenuOfNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 85,
      decoration: BoxDecoration(
        color: Styles.primaryColor,
        borderRadius: BorderRadius.circular(66),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Obx(
        () => Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNavItem(
              path: 'assets/icons/svg/Vector.svg',
              label: 'Inicio',
              index: 0,
              controller: controller,
            ),
            _buildNavItem(
              path: 'assets/icons/svg/Union.svg',
              label: 'Agenda',
              index: 1,
              controller: controller,
            ),
            _buildNavItem(
              path: 'assets/icons/svg/Group 1000003098.svg',
              label: 'Diario',
              index: 4,
              controller: controller,
            ),
            if (roleUser.roleUser.value == roleUser.tipoUsuario('user') ||
                roleUser.roleUser.value == roleUser.tipoUsuario('entrenador'))
              _buildNavItem(
                path: 'assets/icons/svg/Vector1.svg',
                label: 'Entrenamientos',
                index: 2,
                controller: controller,
              ),
            _buildNavItem(
              path: 'assets/icons/svg/Group 1000003080.svg',
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
    required String path,
    required String label,
    required int index,
    required HomeController controller,
  }) {
    final bool isSelected = controller.selectedIndex.value == index;

    return GestureDetector(
      behavior: HitTestBehavior
          .translucent, // Asegura que detecte toques en toda el área

      onTap: () async {
        switch (index) {
          case 0:
            controller.titulo.value = "Bienvenido de vuelta";
            controller.subtitle.value = "¿Qué haremos hoy?";
            break;
          case 1:
            controller.titulo.value = "Agenda";
            controller.subtitle.value = "¿Qué haremos hoy?";
            break;
          case 2:
            controller.titulo.value = "Entrenamiento";
            controller.subtitle.value = "para tu mascota";
            break;
          case 3:
            controller.titulo.value = "Explorar Contenido";
            controller.subtitle.value = "y consejos para tu mascota";
            break;
          case 4:
            controller.titulo.value = "Diario";
            controller.subtitle.value = "de tu mascota";
            break;
        }

        controller.updateIndex(index);

        if (index == 4) {
          Get.to(() => Diario());
        } else {
          Get.to(() => HomeScreen());
        }
      },
      child: IntrinsicWidth(
        // Ajusta el tamaño del botón al contenido
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOutQuad,
          padding: const EdgeInsets.symmetric(
              vertical: 12, horizontal: 10), // Aumenta el área táctil

          decoration: BoxDecoration(
            color: isSelected ? const Color(0xffFC9214) : Colors.transparent,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                path,
                width: 28,
                height: 28,
                color: Colors.white,
              ),
              if (isSelected)
                Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: Text(
                    label,
                    overflow: TextOverflow.ellipsis, // Evita desbordes
                    softWrap: false,
                    maxLines: 1,
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.w700,
                      fontSize: 13.33,
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
