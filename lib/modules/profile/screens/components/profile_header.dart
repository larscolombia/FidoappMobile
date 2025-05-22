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
          width: MediaQuery.sizeOf(context).width,
          decoration: const BoxDecoration(
              color: Styles.colorContainer, border: Border()),
          child: Stack(
            children: [BorderRedondiado(top: headerHeight + 50)],
          ),
        ),
        Center(
          child: Container(
            margin: EdgeInsets.only(top: headerHeight),
            width: 124,
            height: 124,
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
                final profileImage = profileController.user.value.profileImage;
                return profileImage != null && profileImage.isNotEmpty
                    ? CircleAvatar(
                        radius: 46,
                        backgroundImage: NetworkImage(profileImage),
                        backgroundColor: Colors.transparent,
                      )
                    : const CircleAvatar(
                        radius: 46,
                        backgroundColor:
                            Colors.grey, // O un placeholder de tu elección
                        child: Icon(Icons.person, size: 46),
                      );
              },
            ),
          ),
        ),
      ],
    );
  }
}
