import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:pawlly/modules/pet_owner_profile/controllers/pet_owner_profile_controller.dart';
import 'package:pawlly/styles/styles.dart';

class Sobremi extends StatelessWidget {
  const Sobremi({
    super.key,
    required this.profileController,
    required this.controller,
  });

  final UserProfileController profileController;
  final PetOwnerProfileController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final tags = profileController.user.value.profile?.tags ?? [];
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(
              context, 'Sobre ${profileController.user.value.fullName}'),
          _buildInfoRow(
              context, profileController.user.value.profile?.aboutSelf ?? ""),
          if (controller.veterinarianLinked.value)
            Container(
              margin: const EdgeInsets.only(bottom: 12.0),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFE5FEED),
                border: Border.all(color: const Color(0xFF19A02F), width: 0.5),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset('assets/icons/palomiar.png'),
                  const SizedBox(width: 8),
                  Text(
                    profileController.user.value.userType == 'vet'
                        ? 'Veterinario asignado a tu mascota'
                        : 'Entrenador asignado a tu mascota',
                    style: const TextStyle(
                      color: Color(0xFF19A02F),
                      fontWeight: FontWeight.bold,
                      fontFamily: 'lato',
                    ),
                  ),
                ],
              ),
            ),
          if (tags.isNotEmpty)
            Container(
              width: MediaQuery.sizeOf(context).width,
              padding: Styles.paddingAll,
              child: Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: tags.map((area) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 26.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF7E5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      area,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFFFC9214),
                        fontWeight: FontWeight.bold,
                        fontFamily: 'lato',
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
        ],
      );
    });
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Container(
      padding: Styles.paddingAll,
      width: MediaQuery.sizeOf(context).width,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontFamily: 'lato',
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String info) {
    return Container(
      padding: Styles.paddingAll,
      width: MediaQuery.sizeOf(context).width,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            info,
            style: Styles.secondTextTitle,
            textAlign: TextAlign.left,
          ),
        ),
      ),
    );
  }
}
