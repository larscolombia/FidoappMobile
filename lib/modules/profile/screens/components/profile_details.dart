import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:pawlly/modules/pet_owner_profile/controllers/pet_owner_profile_controller.dart';
import 'package:pawlly/styles/styles.dart';

class ProfileDetails extends StatelessWidget {
  final PetOwnerProfileController controller;
  final UserProfileController profileController;

  const ProfileDetails({
    Key? key,
    required this.controller,
    required this.profileController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(() {
          if (profileController.isLoading.value) {
            return const SizedBox(
              child: Center(
                child: Text('cargando ...'),
              ),
            );
          }
          return SizedBox(
            width: MediaQuery.of(context).size.width - 100,
            child: Stack(
              children: [
                Positioned(
                  child: GestureDetector(
                    onTap: () {
                      // Lógica para ir al perfil de usuario
                      Get.back();
                    },
                    child: const Icon(
                      Icons.arrow_back_ios,
                      color: Styles.iconColorBack,
                      size: 20,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.location_on,
                      color: Styles.primaryColor,
                      size: 20,
                    ),
                    Text(
                      profileController.user.value.address ?? "",
                      style: const TextStyle(
                        color: Styles.primaryColor,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Lato',
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
        }),
        const SizedBox(height: 10),
        Obx(() {
          if (profileController.isLoading.value) {
            return const SizedBox(
              child: Center(
                child: Text('cargando ...'),
              ),
            );
          }
          return SizedBox(
            width: MediaQuery.of(context).size.width - 100,
            child: Text(
              profileController.user.value.firstName ?? "",
              style: Styles.dashboardTitle20,
              textAlign: TextAlign.center,
            ),
          );
        }),
        Obx(() {
          if (profileController.isLoading.value) {
            return const SizedBox(
              child: Text('cargando ...'),
            );
          }
          return Text(
            profileController.user.value.userType == "vet"
                ? "Veterinario"
                : "Entrenador",
            style: const TextStyle(
              color: Color(0xff555555),
              fontSize: 12,
              fontWeight: FontWeight.bold,
              fontFamily: 'Lato',
            ),
          );
        }),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RatingBar.builder(
              initialRating: controller.rating.value,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: const EdgeInsets.symmetric(horizontal: 2.0),
              itemSize: 20.0,
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: Styles.iconColorBack,
              ),
              onRatingUpdate: (rating) {},
              ignoreGestures: true,
            ),
            const SizedBox(width: 8),
            Text(
              controller.rating.value.toString(),
              style: Styles.secondTextTitle,
            ),
          ],
        ),
      ],
    );
  }
}
