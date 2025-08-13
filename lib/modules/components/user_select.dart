import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pawlly/components/debounce_gesture_detector.dart';
import 'package:pawlly/modules/components/select_user.dart';
import 'package:pawlly/modules/components/style.dart';
import 'package:pawlly/modules/helper/helper.dart';
import 'package:pawlly/modules/integracion/controller/user_type/user_controller.dart';

class UserEventoSeleccionado extends StatelessWidget {
  final UserController userController = Get.put(UserController());
  final bool? withDelete;
  UserEventoSeleccionado({
    super.key,
    this.withDelete = false,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      var user = userController.selectedUser;
      if (user.value == null) {
        return const Text(
          'Aún no hay personas invitadas a\neste evento',
          style: TextStyle(
              color: Color(0xFF959595),
              fontSize: 14,
              fontFamily: 'Lato',
              fontWeight: FontWeight.w500),
          textAlign: TextAlign.center,
        );
      }

      return Row(
        children: [
          Expanded(
            flex: 5,
            child: SelectedAvatar(
              nombre: user.value!.firstName,
              imageUrl: user.value!.profileImage,
              profesion: Helper.tipoUsuario(user.value!.userType ?? ""),
              showArrow: false,
            ),
          ),
          const SizedBox(width: 10),
          if (withDelete!)
            Expanded(
              flex: 1,
              child: DebounceGestureDetector(
                debounceDuration: const Duration(milliseconds: 400),
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
      );
    });
  }
}
