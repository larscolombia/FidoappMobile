import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:pawlly/services/auth_service_apis.dart';

class RoleUser extends GetxController {
  RxString roleUser = "".obs;

  @override
  void onInit() {
    getRoleUser();
  }

  void getRoleUser() {
    roleUser.value = AuthServiceApis.dataCurrentUser.userType;
  }

  String tipoUsuario(String type) {
    switch (type) {
      case 'vet':
        return "vet";
      case 'user':
        return "user";
      case 'entrenador':
        return "trainer";
      default:
        return "admin";
    }
  }
}
