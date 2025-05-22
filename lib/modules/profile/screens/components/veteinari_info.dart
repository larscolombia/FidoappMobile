import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:pawlly/modules/pet_owner_profile/controllers/pet_owner_profile_controller.dart';

class VeterinarianInfo extends StatelessWidget {
  final PetOwnerProfileController controller;
  final UserProfileController profileController;

  const VeterinarianInfo({
    Key? key,
    required this.controller,
    required this.profileController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (profileController.user.value.userType != 'user') {
      return Obx(() {
        if (controller.veterinarianLinked.value) {
          return Container(
            height: 54,
            width: MediaQuery.sizeOf(context).width,
            margin: const EdgeInsets.symmetric(vertical: 10.0),
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: const Color(0xFFE5FEED),
              border: Border.all(
                color: const Color(0xFF19A02F),
                width: 0.5,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/icons/palomiar.png'),
                SizedBox(width: 8),
                Text(
                  profileController.user.value.userType == 'vet'
                      ? 'Veterinario Calificado'
                      : "Entrenador Calificado",
                  style: const TextStyle(
                    color: Color(0xFF19A02F),
                    fontWeight: FontWeight.bold,
                    fontFamily: 'lato',
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      });
    }
    return const SizedBox.shrink();
  }
}
