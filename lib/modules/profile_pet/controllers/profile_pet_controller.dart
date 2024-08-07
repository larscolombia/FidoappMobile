import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePetController extends GetxController {
  var isEditing = false.obs;
  var selectedTab = 0.obs; // 0: Información, 1: Historial Médico
  var petName = 'Oasis'.obs;
  var petBreed = 'Golden Retriever'.obs;
  var petDescription = 'Una mascota muy amigable y juguetona. '.obs;
  var petAge = '2 años'.obs;
  var petBirthDate = '01/01/2021'.obs;
  var petWeight = '10 kg'.obs;
  var petGender = 'Hembra'.obs;
  var associatedPersons = [
    {'name': 'John Doe', 'relation': 'Dueño'},
    {'name': 'Jane Smith', 'relation': 'Veterinario'},
    {'name': 'Alice Johnson', 'relation': 'Invitado'}
  ].obs;
  var profileImagePath = ''.obs;
  var isPickerActive = false.obs;

  final ImagePicker _picker = ImagePicker();

  // Cambiar entre pestañas
  void changeTab(int index) {
    selectedTab.value = index;
  }

  // Alternar modo de edición
  void toggleEditing() {
    isEditing.value = !isEditing.value;
  }

  // Seleccionar imagen
  Future<void> pickImage() async {
    if (isPickerActive.value) return;
    isPickerActive.value = true;

    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        profileImagePath.value = pickedFile.path;
      }
    } finally {
      isPickerActive.value = false;
    }
  }

  // Eliminar mascota
  void deletePet() {
    // Lógica para eliminar mascota
    Get.back();
    Get.snackbar(
        'Mascota eliminada', 'La mascota ha sido eliminada exitosamente');
  }
}
