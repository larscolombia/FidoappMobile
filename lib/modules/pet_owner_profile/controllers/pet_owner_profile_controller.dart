import 'package:get/get.dart';

class PetOwnerProfileController extends GetxController {
  var ownerName = ''.obs;
  var email = ''.obs;
  var phone = ''.obs;
  var address = ''.obs;
  var profileImagePath = ''.obs; // La URL de la imagen del perfil
  var rating = 3.3.obs; // Clasificación por defecto (valor de 0.0 a 5.0)
  var userType =
      ''.obs; // Tipo de usuario (veterinario, entrenador, dueño, etc.)

  @override
  void onInit() {
    super.onInit();

    // Recibir los datos del perfil pasados como argumentos
    if (Get.arguments != null) {
      var person = Get.arguments;

      ownerName.value = person['name'] ?? 'No name provided';
      email.value = person['email'] ?? 'No email provided';
      phone.value = person['phone'] ?? 'No phone provided';
      address.value = person['address'] ?? 'No address provided';
      profileImagePath.value =
          person['profileImage'] ?? ''; // Asignar la imagen si existe
      rating.value = person['rating'] ?? 4.0; // Asignar el rating si existe
      userType.value =
          person['userType'] ?? 'Dueño'; // Asignar el tipo de usuario si existe
    }
  }

  void editProfile() {
    // Lógica para navegar a la pantalla de edición del perfil
    Get.toNamed('/edit-profile');
  }
}
