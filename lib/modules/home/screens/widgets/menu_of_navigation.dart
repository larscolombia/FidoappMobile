import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pawlly/modules/home/controllers/home_controller.dart';
import 'package:pawlly/styles/styles.dart';

class MenuOfNavigation extends GetView<HomeController> {
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
              icon: Icons.home,
              label: 'Inicio',
              index: 0,
              controller: controller,
            ),
            _buildNavItem(
              icon: Icons.calendar_today,
              label: 'Agenda',
              index: 1,
              controller: controller,
            ),
            _buildNavItem(
              icon: Icons.pets,
              label: 'Entrenamiento',
              index: 2,
              controller: controller,
            ),
            _buildNavItem(
              icon: Icons.search,
              label: 'Explorar',
              index: 3,
              controller: controller,
            ),
            _buildNavItem(
              icon: Icons.note_sharp,
              label: 'Diario',
              index: 4,
              controller: controller,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    IconData? icon,
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
            Icon(
              icon,
              color: Styles.whiteColor,
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
