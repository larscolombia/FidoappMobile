import 'package:get/get.dart';

class Helper extends GetX {
  Helper({required super.builder});

  static Helper get instance => Get.find<Helper>();

  static const margenDefault = 16.0;
  static const paddingDefault = 26.0;
  static String tipoUsuario(String userType) {
    switch (userType) {
      case 'vet':
        return 'Veterinario';
      case 'trainer':
        return 'Entrenador';
      case 'user':
        return 'Usuario';
      default:
        return 'Usuario';
    }
  }
}
