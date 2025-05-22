import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pawlly/modules/components/style.dart';
import 'package:pawlly/modules/integracion/model/user_type/user_model.dart';
import 'package:pawlly/modules/pet_owner_profile/controllers/pet_owner_profile_controller.dart';
import 'package:pawlly/modules/pet_owner_profile/screens/pet_owner_profile.dart';

class UserCard extends StatelessWidget {
  final User user;

  UserCard({super.key, required this.user});
  final UserProfileController profileController =
      Get.find<UserProfileController>();
  @override
  Widget build(BuildContext context) {
    double rating = double.parse(user.rating.toString());
    String roundedRating = rating.toStringAsFixed(1);
    return GestureDetector(
      onTap: () {
        var users = user.profile;

        profileController
            .fetchUserData('${user.id}'); // Obtener los datos del usuario
        print('perfil usuario ${jsonEncode(profileController.user.value)}');
        if (users?.id != null) {
          Get.to(() => PetOwnerProfileScreen(id: '${user.id}'));
        } else {}
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color.fromARGB(255, 179, 173, 173),
            width: .2,
          ),
        ),
        child: Row(
          children: [
            // Imagen del usuario
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Styles.fiveColor, width: 2),
                borderRadius: BorderRadius.circular(30),
              ),
              child: CircleAvatar(
                radius: 30,
                backgroundImage: user.profileImage != null
                    ? NetworkImage(user.profileImage!)
                    : const AssetImage('assets/images/default_user.png')
                        as ImageProvider,
                backgroundColor: Colors.grey[200],
              ),
            ),
            const SizedBox(width: 16),
            // Información del usuario
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.firstName ?? "",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Lato',
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: Colors.red,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          user.address ?? "",
                          style: const TextStyle(
                            fontSize: 14,
                            color: Styles.primaryColor,
                            fontFamily: 'Lato',
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: Colors.orange,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        roundedRating,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(width: 4),
                      SizedBox(
                        width: 100,
                        child: Text(
                          user.profile?.expert ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14,
                            fontFamily: 'Lato',
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Flecha de acción
            const Icon(
              Icons.arrow_forward_ios,
              color: Styles.fiveColor,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
