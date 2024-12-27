import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pawlly/components/custom_alert_dialog_widget.dart';
import 'package:pawlly/models/pet_list_res_model.dart';
import 'package:pawlly/modules/home/controllers/home_controller.dart';
import 'package:pawlly/services/pet_service_apis.dart';

class ProfilePetController extends GetxController {
  final TextEditingController searchController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  late PetData petProfile;
  var isEditing = false.obs;
  var selectedTab = 0.obs;
  var petName = ''.obs;
  var petBreed = ''.obs;
  var petDescription = 'sxaxasxasx'.obs;
  var petAge = ''.obs;
  var petBirthDate = '01/01/2021'.obs;
  var petWeight = ''.obs;
  var petGender = ''.obs;

  var associatedPersons = [
    {'name': 'John Doe', 'relation': 'Dueño'},
    {'name': 'Jane Smiths', 'relation': 'Veterinario'},
    {'name': 'Alice Johnson', 'relation': 'Invitado'},
  ].obs;
  var profileImagePath = ''.obs;
  var isPickerActive = false.obs;
  var medicalHistory = [
    // Agrega más registros según sea necesario
  ].obs;

  var userTypeCont = TextEditingController().obs;
  var emailController = TextEditingController().obs;

  var selectedSortOption = ''.obs;
  var selectedCategory = ''.obs;

  var sortOptions = ['Más reciente', 'A-Z', 'Z-A'].obs;
  var categories = ['Consulta', 'Vacuna', 'Cirugía', 'Examen', 'Otro'].obs;

  @override
  void onInit() {
    super.onInit();
    // Recibe el perfil de la mascota desde los argumentos
    petProfile = Get.arguments as PetData;
    print('controlador del perfil onInit $petProfile');
    // Ahora puedes inicializar las variables con los datos del perfil recibido
    petName.value = petProfile.name;
    petBreed.value = petProfile.breed;
    petDescription.value = petProfile.description ?? '';

    petAge.value = petProfile.age;
    petGender.value = petProfile.gender;
    profileImagePath.value = petProfile.petImage ?? '';

    // Puedes agregar más inicializaciones según los datos disponibles en PetData
  }

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

  // Función para actualizar el perfil de la mascota
  Future<void> updatePetProfile() async {
    // Recoger los datos actualizados en un Map
    Map<String, dynamic> updatedData = {
      'name': petName.value,
      'breed_name': petBreed.value,
      'size': 'Medium', // Ejemplo, podrías agregar un controlador para esto
      'date_of_birth': petBirthDate.value,
      'gender': petGender.value,
      'weight': double.tryParse(petWeight.value) ?? 0.0,
      'user_id': petProfile.userId,
      'additional_info': petDescription.value,
      'pet_image':
          profileImagePath.value.isNotEmpty ? profileImagePath.value : null,
      'age': petAge.value,
    };

    // Llamar al servicio para editar el perfil de la mascota
    final updatedPet = await PetService.postEditPetApi(
      petId: petProfile.id,
      body: updatedData,
    );

    if (updatedPet != null) {
      // Actualización exitosa, puedes actualizar el perfil localmente o realizar alguna otra acción
      petProfile = updatedPet;
      Get.snackbar('Éxito', 'Perfil de la mascota actualizado con éxito');
    } else {
      // Manejo del error
      Get.snackbar('Error', 'Hubo un problema al actualizar el perfil');
    }
  }

  // Eliminar mascota con confirmación
  void deletePet() {
    Get.dialog(
      AlertDialog(
        title: const Text('Confirmar eliminación'),
        content:
            Text('¿Estás seguro de que deseas eliminar a ${petName.value}?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(), // Cerrar el modal sin eliminar
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () async {
              Get.back(); // Cerrar el modal antes de ejecutar la eliminación
              final success =
                  await _deletePetApi(); // Llamar a la función para eliminar la mascota
              if (success) {
                // Obtener el controlador de HomeController para actualizar la lista
                final homeController = Get.find<HomeController>();

                // Eliminar el pet de la lista en HomeController
                homeController.profiles
                    .removeWhere((pet) => pet.id == petProfile.id);

                // Mostrar el diálogo de éxito con el CustomAlertDialog
                Get.dialog(
                  CustomAlertDialog(
                    icon: Icons.check_circle_outline,
                    title: 'Éxito',
                    description: 'La mascota ha sido eliminada exitosamente.',
                    primaryButtonText: 'Aceptar',
                    onPrimaryButtonPressed: () {
                      Get.back(); // Cerrar el diálogo
                      Get.back();
                      Get.back();
                    },
                  ),
                  barrierDismissible:
                      false, // No permite cerrar el diálogo tocando fuera
                );
              } else {
                // Mostrar el diálogo de error con el CustomAlertDialog
                Get.dialog(
                  CustomAlertDialog(
                    icon: Icons.error_outline,
                    title: 'Error',
                    description: 'Hubo un problema al eliminar la mascota.',
                    primaryButtonText: 'Aceptar',
                    onPrimaryButtonPressed: () {
                      Get.back(); // Cerrar el diálogo
                    },
                  ),
                  barrierDismissible:
                      false, // No permite cerrar el diálogo tocando fuera
                );
              }
            },
            child: const Text('Sí', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

// Función para eliminar la mascota a través del API
  Future<bool> _deletePetApi() async {
    try {
      final response = await PetService.deletePetApi(id: petProfile.id);
      return response != null;
    } catch (e) {
      print('Error al eliminar la mascota: $e');
      return false;
    }
  }
}
