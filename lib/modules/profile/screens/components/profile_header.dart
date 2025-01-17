import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pawlly/modules/components/border_redondiado.dart';
import 'package:pawlly/modules/components/style.dart';
import 'package:pawlly/modules/pet_owner_profile/controllers/pet_owner_profile_controller.dart';

class ProfileHeader extends StatelessWidget {
  final UserProfileController profileController;
  final double headerHeight;

  const ProfileHeader({
    Key? key,
    required this.profileController,
    required this.headerHeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: headerHeight + 80,
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Styles.colorContainer,
          ),
          child: Stack(
            children: [BorderRedondiado(top: headerHeight + 50)],
          ),
        ),
        Center(
          child: Container(
            margin: EdgeInsets.only(top: headerHeight),
            width: 100,
            height: 100,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Styles.whiteColor,
              shape: BoxShape.circle,
              border: Border.all(
                color: Styles.iconColorBack,
                width: 3.0,
              ),
            ),
            child: Obx(
              () {
                if (profileController.isLoading.value) {
                  return const SizedBox(
                    child: Center(
                      child: Text('cargando ...'),
                    ),
                  );
                }
                return CircleAvatar(
                  radius: 46,
                  backgroundImage: NetworkImage(
                    profileController.user.value.profileImage ?? '',
                  ),
                  backgroundColor: Colors.transparent,
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
