import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:pawlly/modules/apprenticeship/screens/Apprenticeship.dart';
import 'package:pawlly/modules/home/screens/home_screen.dart';
import 'package:pawlly/routes/app_pages.dart';

class HomeController extends GetxController {
  var selectedIndex = 0.obs;

  void updateIndex(int index) {
    selectedIndex.value = index;
  }

  void pantallas(index) {
    switch (index) {
      case 0:
        Get.toNamed(Routes.HOME);
        break;
      case 2:
        Get.toNamed(Routes.APPRENTICESHIP);
        break;
    }
  }
}
