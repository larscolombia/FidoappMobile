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
      height: 75,
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
        // Actualiza el índice seleccionado
        print('inicio $index');
        controller.updateIndex(index);

        // Prefetch de datos y navegación optimizada
        if (index == 4) {
          //await Future.delayed(const Duration(milliseconds: 50));
          Get.to(() => Diario()); // Limpia la pila con Get.off
        } else {
          //await Future.delayed(const Duration(milliseconds: 50));
          Get.to(() => HomeScreen());
        }
      },
      child: AnimatedContainer(
        duration: const Duration(seconds: 1), // Animación rápida
        curve: Curves.easeOutQuad, // Curva fluida
        padding: EdgeInsets.symmetric(
          vertical: isSelected ? 10 : 5,
          horizontal: isSelected ? 16 : 10,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(
                  0xffFC9214) // Fondo naranja cuando está seleccionado
              : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Ícono
            SvgPicture.asset(
              path,
              width: 24,
              height: 24,
              color: Colors.white,
            ),
            // Texto deslizante al seleccionarse
            AnimatedSize(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOutQuad,
              child: isSelected
                  ? Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: Text(
                        label,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    )
                  : const SizedBox
                      .shrink(), // Oculta el texto si no está seleccionado
            ),
          ],
        ),
      ),
    );
  }
}
