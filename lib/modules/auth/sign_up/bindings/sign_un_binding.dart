import 'package:get/get.dart';
import 'package:pawlly/modules/auth/sign_up/controllers/sign_up_controller.dart';

class SignUpBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SignUpController>(
      () => SignUpController(),
    );
  }
}
