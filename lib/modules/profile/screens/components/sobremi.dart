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
      return Column(
        children: [
          _buildSectionTitle(
              context, 'Sobre ${profileController.user.value.fullName}'),
          _buildInfoRow(context, profileController.user.value.address ?? ""),
          _buildInfoRow(context, profileController.user.value.email ?? ""),
          _buildInfoRow(context, profileController.user.value.gender ?? ""),
          _buildInfoRow(
              context, profileController.user.value.profile?.aboutSelf ?? ""),
        ],
      );
    });
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Container(
      padding: Styles.paddingAll,
      width: MediaQuery.of(context).size.width,
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
      width: MediaQuery.of(context).size.width,
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
