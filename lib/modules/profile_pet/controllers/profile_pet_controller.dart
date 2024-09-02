import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pawlly/models/pet_list_res_model.dart';
import 'package:pawlly/services/pet_service_apis.dart';

class ProfilePetController extends GetxController {
  final TextEditingController searchController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  late PetData petProfile;
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

  @override
  void onInit() {
    super.onInit();
    // Recibe el perfil de la mascota desde los argumentos
    petProfile = Get.arguments as PetData;

    // Ahora puedes inicializar las variables con los datos del perfil recibido
    petName.value = petProfile.name;
    petBreed.value = petProfile.breed;
    petDescription.value =
        'Una mascota muy amigable y juguetona.'; // Puedes ajustar esto si tienes una descripción en tu modelo
    petAge.value = petProfile.age;
    petGender.value = petProfile.gender!;
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

  // Eliminar mascota
  void deletePet() {
    Get.back();
    Get.snackbar(
        'Mascota eliminada', 'La mascota ha sido eliminada exitosamente');
  }
}
/*

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pawlly/models/pet_list_res_model.dart';
import 'package:pawlly/services/pet_service_apis.dart';

class ProfilePetController extends GetxController {
  final TextEditingController searchController = TextEditingController();

  late PetData petProfile;
  var profile = PetProfile(
    name: 'Oasis',
    breed: 'Golden Retriever',
    description: 'Una mascota muy amigable y juguetona.',
    age: '2 años',
    birthDate: '01/01/2021',
    weight: '10 kg',
    gender: 'Hembra',
    imagePath: '',
    associatedPersons: [
      {'name': 'John Doe', 'relation': 'Dueño'},
      {'name': 'Jane Smith', 'relation': 'Veterinario'},
      {'name': 'Alice Johnson', 'relation': 'Invitado'},
    ],
    medicalHistory: [
      {'title': 'Consulta General', 'type': 'Consulta', 'date': '01/08/2023', 'reportNumber': '12345'},
      {'title': 'Vacunación Anual', 'type': 'Vacuna', 'date': '15/07/2023', 'reportNumber': '67890'},
    ],
  ).obs;

  var isEditing = false.obs;
  var selectedTab = 0.obs;
  var isPickerActive = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Recibe el perfil de la mascota desde los argumentos
    petProfile = Get.arguments as PetData;
    profile.update((val) {
      val?.updateFromPetData(petProfile);
    });

    // Llamar al servicio para obtener los detalles actualizados de la mascota
    fetchPetDetails();
  }

  // Función para obtener los detalles de la mascota desde el servicio
  Future<void> fetchPetDetails() async {
    final fetchedPet = await PetService.getPetDetailsApi(petId: petProfile.id);

    if (fetchedPet != null) {
      profile.update((val) {
        val?.updateFromPetData(fetchedPet);
      });
    } else {
      Get.snackbar('Error', 'No se pudieron recuperar los detalles de la mascota.');
    }
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
        profile.update((val) {
          val?.imagePath = pickedFile.path;
        });
      }
    } finally {
      isPickerActive.value = false;
    }
  }

  // Función para actualizar el perfil de la mascota
  Future<void> updatePetProfile() async {
    // Recoger los datos actualizados en un Map
    Map<String, dynamic> updatedData = {
      'name': profile.value.name,
      'breed_name': profile.value.breed,
      'size': 'Medium',
      'date_of_birth': profile.value.birthDate,
      'gender': profile.value.gender,
      'weight': double.tryParse(profile.value.weight) ?? 0.0,
      'user_id': petProfile.userId,
      'additional_info': profile.value.description,
      'pet_image': profile.value.imagePath.isNotEmpty ? profile.value.imagePath : null,
    };

    // Llamar al servicio para editar el perfil de la mascota
    final updatedPet = await PetService.postEditPetApi(
      petId: petProfile.id,
      body: updatedData,
    );

    if (updatedPet != null) {
      profile.update((val) {
        val?.updateFromPetData(updatedPet);
      });
      Get.snackbar('Éxito', 'Perfil de la mascota actualizado con éxito');
    } else {
      // Manejo del error
      Get.snackbar('Error', 'Hubo un problema al actualizar el perfil');
    }
  }

  // Eliminar mascota
  void deletePet() {
    Get.back();
    Get.snackbar('Mascota eliminada', 'La mascota ha sido eliminada exitosamente');
  }
}
*/