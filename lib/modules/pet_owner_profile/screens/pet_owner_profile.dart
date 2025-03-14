import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pawlly/components/button_default_widget.dart';
import 'package:pawlly/modules/auth/model/employee_model.dart';
import 'package:pawlly/modules/helper/helper.dart';
import 'package:pawlly/modules/pet_owner_profile/controllers/pet_owner_profile_controller.dart';
import 'package:pawlly/modules/pet_owner_profile/screens/widgets/comments_section.dart';
import 'package:pawlly/modules/pet_owner_profile/screens/widgets/list_pet.dart';
import 'package:pawlly/modules/profile/screens/components/profile_action.dart';
import 'package:pawlly/modules/profile/screens/components/profile_details.dart';
import 'package:pawlly/modules/profile/screens/components/profile_header.dart';
import 'package:pawlly/modules/profile/screens/components/sobremi.dart';
import 'package:pawlly/modules/profile/screens/components/veteinari_info.dart';
import 'package:pawlly/styles/recursos.dart';
import 'package:pawlly/styles/styles.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

//perfil del usuario
class PetOwnerProfileScreen extends StatefulWidget {
  final String id;
  PetOwnerProfileScreen({super.key, required this.id});

  @override
  _PetOwnerProfileScreenState createState() => _PetOwnerProfileScreenState();
}

class _PetOwnerProfileScreenState extends State<PetOwnerProfileScreen> {
  final PetOwnerProfileController controller =
      Get.put(PetOwnerProfileController());
  final UserProfileController profileController =
      Get.put(UserProfileController());

  @override
  void initState() {
    super.initState();
    profileController.fetchUserData(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.whiteColor,
      body: Stack(
        children: [
          Obx(() {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(36),
                  topRight: Radius.circular(36),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ProfileHeader(
                      profileController: profileController,
                      headerHeight: MediaQuery.of(context).size.height / 8,
                    ),
                    const SizedBox(height: 20),
                    ProfileDetails(
                      controller: controller,
                      profileController: profileController,
                      id: '${widget.id}',
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: Helper.paddingDefault,
                          right: Helper.paddingDefault),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 20,
                        child: Divider(
                          thickness: 1,
                          color: Recursos.ColorBorderSuave,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: Helper.paddingDefault,
                          right: Helper.paddingDefault),
                      child: VeterinarianInfo(
                        controller: controller,
                        profileController: profileController,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Sobremi(
                        profileController: profileController,
                        controller: controller),
                    /**
                    const SizedBox(height: 20),
                    ProfileActions(
                        controller: controller,
                        profileController: profileController), */
                    const SizedBox(height: 20),
                    profileController.user.value.userType == "user"
                        ? ListPet(pets: profileController.user.value.pets ?? [])
                        : CommentsSection(id: '${widget.id}'),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          }),
          Obx(() {
            if (profileController.isLoading.value) {
              return Container(
                color: Colors.black.withOpacity(0.5),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else {
              return const SizedBox.shrink();
            }
          }),
        ],
      ),
    );
  }
}
