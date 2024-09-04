import 'package:get/get.dart';
import 'package:pawlly/modules/pet_owner_profile/controllers/pet_owner_profile_controller.dart';

class PetOwnerProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PetOwnerProfileController>(
      () => PetOwnerProfileController(),
    );
  }
}
