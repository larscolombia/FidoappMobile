import 'package:get/get.dart';
import 'package:pawlly/modules/profile_pet/controllers/profile_pet_controller.dart';

class ProfilePetBinding extends Bindings {
  @override
  void dependencies() {
    // Eliminar el controlador anterior si existe
    if (Get.isRegistered<ProfilePetController>()) {
      Get.delete<ProfilePetController>();
    }
    
    // Crear una nueva instancia del controlador
    Get.put<ProfilePetController>(
      ProfilePetController(),
      permanent: false,
    );
  }
}
