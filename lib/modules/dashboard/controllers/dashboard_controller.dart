import 'package:get/get.dart';
import 'package:pawlly/models/user_data_model.dart';
import 'package:pawlly/routes/app_pages.dart';
import 'package:pawlly/services/auth_service_apis.dart';
import 'package:pawlly/utils/social_logins.dart';

class DashboardController extends GetxController {
  late UserData currentUser;
  var profileImagePath = ''.obs;
  var name = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Cargar los datos del usuario desde AuthServiceApis al iniciar el controlador
    currentUser = AuthServiceApis.dataCurrentUser; // Asegúrate de que el servicio esté correctamente configurado

    // Inicializar los controladores con los datos del usuario actual
    name.value = currentUser.firstName;
    profileImagePath.value = currentUser.profileImage; // Imagen de perfil del usuario
  
    ever(AuthServiceApis.profileChange, (DateTime time) {
      currentUser = AuthServiceApis.dataCurrentUser;
      profileImagePath.value = currentUser.profileImage;
    });
  }


  Future<void> logoutUser() async {
    // Llama a la función para cerrar sesión en backend
    await AuthServiceApis.logoutApi();

    // Cerrar sesión de Google/Firebase para permitir seleccionar otra cuenta
    await GoogleSignInAuthService.signOutGoogle();

    // Agregar un pequeño retraso antes de redirigir
    Future.delayed(const Duration(milliseconds: 500), () {
      // Redirigir al usuario a la pantalla de inicio de sesión
      Get.offAllNamed(Routes.SIGNIN); // Limpia el historial de rutas y redirige al login
    });
  }
}
