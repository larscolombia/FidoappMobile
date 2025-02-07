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
    return Obx(() {
      if (profileController.isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
      return Column(
        children: [
          Container(
            padding: Styles.paddingAll,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Sobre ${profileController.user.value.fullName}',
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'lato',
                  ),
                ),
              ),
            ),
          ),
          profileController.user.value.userType != 'user'
              ? Column(
                  children: [
                    Container(
                      padding: Styles.paddingAll,
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            profileController.user.value.address ?? "",
                            style: Styles.secondTextTitle,
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: Styles.paddingAll,
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            profileController.user.value.email ?? "",
                            style: Styles.secondTextTitle,
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: Styles.paddingAll,
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            profileController.user.value.gender ?? "",
                            style: Styles.secondTextTitle,
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : Container(
                  padding: Styles.paddingAll,
                  width: MediaQuery.of(context).size.width,
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
                ),
        ],
      );
    });
  }
}
