import 'package:get/get.dart';
import 'package:pawlly/modules/auth/password/controllers/change_success_password_controller.dart';

class ChangeSuccessPasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChangeSuccessPasswordController>(
      () => ChangeSuccessPasswordController(),
    );
  }
}
