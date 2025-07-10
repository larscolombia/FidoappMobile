import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pawlly/components/custom_alert_dialog_widget.dart';
import 'package:pawlly/models/pet_list_res_model.dart';
import 'package:pawlly/modules/home/controllers/home_controller.dart';
import 'package:pawlly/services/pet_service_apis.dart';
import 'package:pawlly/components/custom_snackbar.dart';

class ProfilePetController extends GetxController {
  final TextEditingController searchController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  late PetData petProfile;
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
    // Obtener el perfil de la mascota desde HomeController
    final homeController = Get.find<HomeController>();
    if (homeController.selectedProfile.value != null) {
    petProfile = homeController.selectedProfile.value!;
    print('controlador del perfil onInit ${jsonEncode(petProfile)}');
    
    // Inicializar las variables con los datos del perfil recibido
    _initializePetData();
    
    // Actualizar los datos de la mascota desde la API para asegurar información fresca
    _refreshPetData();
    } else {
      print('Error: No hay perfil seleccionado en HomeController');
    }
  }

  // Método para forzar la reinicialización del controlador
  void forceReinitialize() {
    final homeController = Get.find<HomeController>();
    if (homeController.selectedProfile.value != null) {
      petProfile = homeController.selectedProfile.value!;
      _initializePetData();
      _refreshPetData();
    }
  }

  @override
  void onClose() {
    // Limpiar recursos cuando se cierre el controlador
    searchController.dispose();
    super.onClose();
  }

  // Método para actualizar los datos de la mascota desde la API
  void _refreshPetData() {
    // Obtener la lista actualizada de mascotas
    final homeController = Get.find<HomeController>();
    homeController.fetchProfiles();
    
    // Usar un timer para esperar a que se complete la carga
    Future.delayed(const Duration(milliseconds: 500), () {
      // Buscar la mascota actualizada por ID
      final updatedPet = homeController.getPetById(petProfile.id);
      if (updatedPet.id != 0) { // Verificar que se encontró la mascota
        petProfile = updatedPet;
        print('Datos de mascota actualizados: ${jsonEncode(petProfile)}');
        // Actualizar las variables observables con los nuevos datos
        _initializePetData();
      }
    });
  }

  // Método para inicializar las variables con los datos del perfil
  void _initializePetData() {
    petName.value = petProfile.name;
    petBreed.value = petProfile.breed.isNotEmpty ? petProfile.breed : "Raza no disponible";
    petDescription.value = petProfile.description ?? '';
    petAge.value = petProfile.age;
    petGender.value = petProfile.gender;
    profileImagePath.value = petProfile.petImage ?? '';
    petBirthDate.value = petProfile.dateOfBirth ?? '';
    petWeight.value = petProfile.weight?.toString() ?? '';
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
      'gender': petGender.value,
      'weight': double.tryParse(petWeight.value) ?? 0.0,
      'user_id': petProfile.userId,
      'additional_info': petDescription.value,
      'pet_image':
          profileImagePath.value.isNotEmpty ? profileImagePath.value : null,
      'age': petAge.value,
    };

    // Solo agregar date_of_birth si no está vacío
    if (petBirthDate.value.isNotEmpty) {
      updatedData['date_of_birth'] = petBirthDate.value;
    }

    // Llamar al servicio para editar el perfil de la mascota
    final updatedPet = await PetService.postEditPetApi(
      petId: petProfile.id,
      body: updatedData,
    );

    if (updatedPet != null) {
      // Actualización exitosa
      petProfile = updatedPet;
      
      // Actualizar también en HomeController
      final homeController = Get.find<HomeController>();
      final index = homeController.profiles.indexWhere((pet) => pet.id == petProfile.id);
      if (index != -1) {
        homeController.profiles[index] = updatedPet;
        homeController.profiles.refresh();
      }
      
      // Actualizar la imagen en el controlador local
      if (updatedPet.petImage != null && updatedPet.petImage!.isNotEmpty) {
        profileImagePath.value = updatedPet.petImage!;
      }
      
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

  // Método para forzar la actualización de datos de la mascota
  void refreshPetData() {
    final homeController = Get.find<HomeController>();
    homeController.fetchProfiles();
    
    // Usar un timer para esperar a que se complete la carga
    Future.delayed(const Duration(milliseconds: 500), () {
      // Buscar la mascota actualizada por ID
      final updatedPet = homeController.getPetById(petProfile.id);
      if (updatedPet.id != 0) {
        petProfile = updatedPet;
        _initializePetData();
        print('Datos de mascota actualizados manualmente: ${jsonEncode(petProfile)}');
      }
    });
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

          final success = await _deletePetApi(); // Ejecuta la eliminación

          if (success) {
            // Actualiza la lista en HomeController
            final homeController = Get.find<HomeController>();
            homeController.profiles
                .removeWhere((pet) => pet.id == petProfile.id);

            // Verificar si la mascota eliminada era la seleccionada
            if (homeController.selectedProfile.value?.id == petProfile.id) {
              // Si hay otras mascotas disponibles, seleccionar la primera
              if (homeController.profiles.isNotEmpty) {
                homeController.selectedProfile.value = homeController.profiles.first;
              } else {
                // Si no hay más mascotas, limpiar la selección
                homeController.selectedProfile.value = null;
              }
            }

            // Muestra un mensaje de éxito
            Get.dialog(
              CustomAlertDialog(
                icon: Icons.check_circle_outline,
                title: "Éxito",
                description: "La mascota ha sido eliminada exitosamente.",
                primaryButtonText: "Aceptar",
                onPrimaryButtonPressed: () {
                  Get.close(3); // Cierra todos los modales abiertos
                  // Navegar de vuelta a la pantalla anterior
                  Get.back();
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
