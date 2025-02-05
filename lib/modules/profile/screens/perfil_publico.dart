import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:pawlly/modules/integracion/controller/comentarios/ranting_controller.dart';
import 'package:pawlly/modules/pet_owner_profile/controllers/pet_owner_profile_controller.dart';
import 'package:pawlly/modules/pet_owner_profile/screens/widgets/comments_section.dart';
import 'package:pawlly/modules/profile/screens/components/profile_action.dart';
import 'package:pawlly/modules/profile/screens/components/profile_details.dart';
import 'package:pawlly/modules/profile/screens/components/profile_header.dart';
import 'package:pawlly/modules/profile/screens/components/sobremi.dart';
import 'package:pawlly/modules/profile/screens/components/veteinari_info.dart';
import 'package:pawlly/services/auth_service_apis.dart';
import 'package:pawlly/styles/styles.dart';

class PublicProfilePage extends StatefulWidget {
  PublicProfilePage({Key? key}) : super(key: key);

  @override
  State<PublicProfilePage> createState() => _PublicProfilePageState();
}

class _PublicProfilePageState extends State<PublicProfilePage> {
  final UserProfileController profileController =
      Get.put(UserProfileController());

  final PetOwnerProfileController controller =
      Get.put(PetOwnerProfileController());

  final CommentController comentariosController = Get.put(CommentController());
  @override
  void initState() {
    super.initState();
    // Llamamos al fetchUserData sólo aquí, para que no se repita en cada build
    profileController.fetchUserData('${AuthServiceApis.dataCurrentUser.id}');
    comentariosController.fetchComments(
        '${AuthServiceApis.dataCurrentUser.id}', "user");
  }

  @override
  Widget build(BuildContext context) {
    comentariosController.fetchComments(
        '${AuthServiceApis.dataCurrentUser.id}', "user");
    return Scaffold(
      backgroundColor: Styles.whiteColor,
      body: Container(
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
                  controller: controller, profileController: profileController),
              const SizedBox(height: 20),
              const SizedBox(
                height: 20,
                child: Divider(
                  thickness: .2,
                  color: Color.fromARGB(255, 170, 165, 157),
                ),
              ),
              const SizedBox(height: 20),
              VeterinarianInfo(
                  controller: controller, profileController: profileController),
              const SizedBox(height: 10),
              Sobremi(
                  profileController: profileController, controller: controller),
              const SizedBox(height: 20),
              ProfileActions(
                  controller: controller, profileController: profileController),
              const SizedBox(
                height: 20,
              ),
              CommentsSection(
                id: '${AuthServiceApis.dataCurrentUser.id}',
                expert: false,
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
