import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';

class WelcomeController extends GetxController {
  final CarouselSliderController carouselController = CarouselSliderController();
  var currentIndex = 0.obs;

  void onPageChanged(int index, CarouselPageChangedReason reason) {
    currentIndex.value = index;
  }

  void onDotClicked(int index) {
    carouselController.animateToPage(index);
  }
}
