import 'package:get/get.dart';
import 'package:pawlly/modules/add_pet/controllers/add_pet_controller.dart';

class AddPetBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddPetController>(
      () => AddPetController(),
    );
  }
}
