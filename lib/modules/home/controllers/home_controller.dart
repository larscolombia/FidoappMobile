import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:pawlly/modules/apprenticeship/screens/Apprenticeship.dart';
import 'package:pawlly/modules/home/screens/home_screen.dart';
import 'package:pawlly/routes/app_pages.dart';

class HomeController extends GetxController {
  var selectedIndex = 0.obs;
  var profiles = [].obs; // Lista de perfiles
  var selectedProfile = ''.obs; // Perfil seleccionado

  // Método para actualizar el índice seleccionado
  void updateIndex(int index) {
    selectedIndex.value = index;
  }

  // Método para navegar a diferentes pantallas
  void pantallas(index) {
    switch (index) {
      case 0:
        Get.toNamed(Routes.HOME);
        break;
      case 1:
        Get.toNamed(Routes.CALENDAR);
        break;
      /*
      case 2:
        Get.toNamed(Routes.APPRENTICESHIP);
        break;
        */
    }
  }

  // Método para actualizar el perfil seleccionado
  void updateProfile(String profile) {
    selectedProfile.value = profile;
  }

  // Método para agregar un nuevo perfil con datos de mascota
  void addProfile(Map<String, dynamic> petData) {
    profiles.add(petData);
  }
}
