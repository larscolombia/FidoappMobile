import 'package:get/get.dart';
import 'package:pawlly/modules/training/controllers/training_controller.dart';

class TrainingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TrainingController>(
      () => TrainingController(),
    );
  }
}
