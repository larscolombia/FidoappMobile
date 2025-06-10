import 'package:get/get.dart';
import 'package:pawlly/modules/apprenticeship/controllers/home_controller.dart';

class ApprenticeshipBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ApprenticeshipController>(
      () => ApprenticeshipController(),
    );
  }
}
