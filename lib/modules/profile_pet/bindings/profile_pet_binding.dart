import 'package:get/get.dart';
import 'package:pawlly/modules/profile_pet/controllers/profile_pet_controller.dart';

class ProfilePetBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfilePetController>(
      () => ProfilePetController(),
    );
  }
}
