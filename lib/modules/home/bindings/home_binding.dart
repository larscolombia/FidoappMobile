import 'package:get/get.dart';
import 'package:pawlly/modules/calendar/controllers/calendar_controller.dart';
import 'package:pawlly/modules/home/controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(
      () => HomeController(),
    );
    Get.lazyPut<CalendarController>(
      () => CalendarController(),
    );
  }
}
