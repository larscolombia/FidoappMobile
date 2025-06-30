import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pawlly/components/custom_alert_dialog_widget.dart';
import 'package:pawlly/components/custom_snackbar.dart';
import 'package:pawlly/models/pet_data.dart';
import 'package:pawlly/repositories/pets_repository.dart';


class ProfilePetController extends GetxController {
  final petsRepository = Get.put(PetsRepository());
  
  final TextEditingController searchController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  final Rx<PetData> petProfile = PetData.empty().obs;

  var isEditing = false.obs;
  var selectedTab = 0.obs;
  var petName = ''.obs;
  var petBreed = ''.obs;
  var petDescription = ''.obs;
  var petAge = ''.obs;
  var petBirthDate = ''.obs;
  var petWeight = ''.obs;
  var petGender = ''.obs;

  var associatedPersons = [
    {'name': 'John Doe', 'relation': 'Dueño'},
    {'name': 'Jane Smiths', 'relation': 'Veterinario'},
    {'name': 'Alice Johnson', 'relation': 'Invitado'},
  ].obs;
  var profileImagePath = ''.obs;
  var isPickerActive = false.obs;
  var medicalHistory = [].obs;

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
    petProfile.value = Get.arguments as PetData;
    print('controlador del perfil onInit ${jsonEncode(petProfile)}');
    // Ahora puedes inicializar las variables con los datos del perfil recibido
    petName.value = petProfile.value.name;
    petBreed.value = petProfile.value.breed;
    petDescription.value = petProfile.value.description ?? '';

    petAge.value = petProfile.value.age;
    petGender.value = petProfile.value.gender;
    profileImagePath.value = petProfile.value.petImage ?? '';
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
  Future<void> updatePetProfile(PetData petData) async {
    // Recoger los datos actualizados en un Map
    // Map<String, dynamic> updatedData = {
    //   'name': petName.value,
    //   'breed_name': petBreed.value,
    //   'size': 'Medium', // Ejemplo, podrías agregar un controlador para esto
    //   'date_of_birth': petBirthDate.value,
    //   'gender': petGender.value,
    //   'weight': double.tryParse(petWeight.value) ?? 0.0,
    //   'user_id': petProfile.userId,
    //   'additional_info': petDescription.value,
    //   'pet_image': profileImagePath.value.isNotEmpty ? profileImagePath.value : null,
    //   'age': petAge.value,
    // };

    // Llamar al servicio para editar el perfil de la mascota
    final updatedPet = await petsRepository.updatePet(petData);

    if (updatedPet != null) {
      // Actualización exitosa, puedes actualizar el perfil localmente o realizar alguna otra acción
      petProfile.value = updatedPet;
      CustomSnackbar.show(
        title: 'Éxito',
        message: 'Perfil de la mascota actualizado con éxito',
        isError: false,
      );
    } else {
      // Manejo del error
      CustomSnackbar.show(
        title: 'Error',
        message: 'Hubo un problema al actualizar el perfil',
        isError: true,
      );
    }
  }

  // Eliminar mascota con confirmación
  void deletePet() {
    Get.dialog(
      CustomAlertDialog(
        icon: Icons.pets,
        title: "Confirmar eliminación",
        description: "¿Estás seguro de que deseas eliminar a ${petName.value}?",
        buttonCancelar: true,
        primaryButtonText: "Eliminar",
        onPrimaryButtonPressed: () async {
          Get.back(); // Cierra el modal antes de ejecutar la eliminación

          final success = await petsRepository.deletePet(petProfile.value.id);

          if (success) {
            // Muestra un mensaje de éxito
            Get.dialog(
              CustomAlertDialog(
                icon: Icons.check_circle_outline,
                title: "Éxito",
                description: "La mascota ha sido eliminada exitosamente.",
                primaryButtonText: "Aceptar",
                onPrimaryButtonPressed: () {
                  // TODO: Verificar cuántos modales están abiertos en este punto
                  Get.close(3); // Cierra todos los modales abiertos
                },
              ),
              barrierDismissible: false,
            );
          } else {
            // Muestra un mensaje de error
            Get.dialog(
              CustomAlertDialog(
                icon: Icons.error_outline,
                title: "Error",
                description: "Hubo un problema al eliminar la mascota.",
                primaryButtonText: "Aceptar",
                onPrimaryButtonPressed: () => Get.back(),
              ),
              barrierDismissible: false,
            );
          }
        },
      ),
    );
  }
}
