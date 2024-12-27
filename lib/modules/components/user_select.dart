import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pawlly/modules/components/select_user.dart';
import 'package:pawlly/modules/components/style.dart';
import 'package:pawlly/modules/integracion/controller/user_type/user_controller.dart';

class UserEventoSeleccionado extends StatelessWidget {
  final UserController userController = Get.put(UserController());

  UserEventoSeleccionado({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      var user = userController.selectedUser;
      if (user.value == null) {
        return const SizedBox(
          width: 302,
          child: Text('No hay usuario seleccionado para este evento'),
        );
      }

      return SizedBox(
        width: MediaQuery.of(context).size.width - 10,
        child: Row(
          children: [
            SizedBox(
              width: 240,
              child: SelectedAvatar(
                nombre: user.value!.firstName,
                imageUrl: user.value!.profileImage,
              ),
            ),
            const SizedBox(width: 10),
            SizedBox(
              width: 40,
              child: GestureDetector(
                onTap: () {
                  userController.deselectUser();
                },
                child: const Icon(
                  Icons.delete,
                  color: Styles.primaryColor,
                  size: 22,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
