import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePetController extends GetxController {
  final TextEditingController searchController = TextEditingController();

  var isEditing = false.obs;
  var selectedTab = 0.obs;
  var petName = 'Oasis'.obs;
  var petBreed = 'Golden Retriever'.obs;
  var petDescription = 'Una mascota muy amigable y juguetona.'.obs;
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
  var medicalHistory = [
    {
      'title': 'Consulta General',
      'type': 'Consulta',
      'date': '01/08/2023',
      'reportNumber': '12345'
    },
    {
      'title': 'Vacunación Anual',
      'type': 'Vacuna',
      'date': '15/07/2023',
      'reportNumber': '67890'
    },
    // Agrega más registros según sea necesario
  ].obs;

  var userTypeCont = TextEditingController().obs;
  var emailController = TextEditingController().obs;

  var selectedSortOption = ''.obs;
  var selectedCategory = ''.obs;

  var sortOptions = ['Más reciente', 'A-Z', 'Z-A'].obs;
  var categories = ['Consulta', 'Vacuna', 'Cirugía', 'Examen', 'Otro'].obs;

  void selectOption(String option, RxString selectedOption) {
    selectedOption.value = option; // Selecciona la nueva opción
  }

  void selectSortOption(String option) {
    selectOption(option, selectedSortOption);
  }

  void selectCategory(String category) {
    selectOption(category, selectedCategory);
  }

  // Filtrar historial médico
  void filterMedicalHistory(String query) {
    // Lógica de filtrado aquí
  }

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
    Get.back();
    Get.snackbar(
        'Mascota eliminada', 'La mascota ha sido eliminada exitosamente');
  }
}
