import 'dart:convert';

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
    return Container(
      child: Column(children: [
        Obx(
          () {
            if (profileController.isLoading.value) {
              return const SizedBox(
                child: Text('cargando ...'),
              );
            }
            return Container(
              width: MediaQuery.of(context).size.width - 100,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Sobre ${profileController.user.value.firstName}',
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'lato',
                    ),
                  ),
                ),
              ),
            );
          },
        ),
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
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  profileController.user.value.profile?.aboutSelf ?? "",
                  style: Styles.secondTextTitle,
                  textAlign: TextAlign.left,
                ),
              ),
            ),
          );
        }),
      ]),
    );
  }
}
