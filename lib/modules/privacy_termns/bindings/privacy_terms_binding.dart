import 'package:get/get.dart';
import 'package:pawlly/modules/privacy_termns/controllers/privacy_terms_controller.dart';
import 'package:pawlly/modules/profile_pet/controllers/profile_pet_controller.dart';

class PrivacyTermsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PrivacyTermsController>(
      () => PrivacyTermsController(),
    );
  }
}
