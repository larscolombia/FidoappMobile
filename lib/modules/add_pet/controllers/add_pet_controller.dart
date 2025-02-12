import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:pawlly/components/custom_alert_dialog_widget.dart';
import 'package:pawlly/models/brear_model.dart';
import 'package:pawlly/modules/home/controllers/home_controller.dart';
import 'package:pawlly/services/auth_service_apis.dart';
import 'package:pawlly/services/pet_service_apis.dart'; // Asegúrate de importar tu servicio

class AddPetController extends GetxController {
  RxBool isLoading = false.obs;

  // Observables
  var petBirthDate = DateTime.now().obs;
  var breedList = <BreedModel>[].obs; // Observable para la lista de razas

  @override
  void onInit() {
    super.onInit();
    fetchBreedsList(); // Llamar a la API cuando se inicializa el controlador
  }

  // Método para limpiar el formulario
  void clearForm() {
    petBirthDate.value = DateTime.now();
    update();
  }

  // Método para obtener la lista de razas desde la API
  Future<void> fetchBreedsList() async {
    final breeds = await PetService.getBreedsListApi();
    if (breeds.isNotEmpty) {
      breedList.assignAll(breeds);
    } else {
      // Manejar el error si la lista está vacía
      Get.snackbar('Error', 'No se pudo cargar la lista de razas');
    }
  }

  Future<bool> submitForm(
    GlobalKey<FormState> formKey,
    String petName,
    String petDescription,
    String petWeight,
    String petBirthDate,
    String petBreed,
    String petGender,
    String petImagePath,
  ) async {
    if (formKey.currentState?.validate() ?? false) {
      isLoading(true);

      Map<String, String> petData = {
        'name': petName,
        'additional_info': petDescription,
        'date_of_birth': petBirthDate,
        'breed_name': petBreed,
        'gender': petGender,
        'weight': petWeight,
        'user_id': AuthServiceApis.dataCurrentUser.id.toString(),
      };

      print('petData: $petData');
      petData.removeWhere((key, value) => value.isEmpty);

      try {
        final newPet = await PetService.postCreatePetApi(
          body: petData,
          imagePath: petImagePath, // Añadir la ruta de la imagen
        );

        final homeController = Get.find<HomeController>();
        homeController.profiles.add(newPet!);
        homeController.profiles.refresh();

        Get.dialog(
          CustomAlertDialog(
            icon: Icons.check_circle_outline,
            title: 'Mascota creada',
            description: 'La mascota ha sido creada exitosamente.',
            primaryButtonText: 'Continuar',
            onPrimaryButtonPressed: () {
              clearForm();
              Get.back();
            },
          ),
          barrierDismissible: false,
        );
        return true;
      } catch (e) {
        print('Error al crear la mascota: $e');
        Get.dialog(
          CustomAlertDialog(
            icon: Icons.error_outline,
            title: 'Error',
            description: 'Hubo un problema al crear la mascota: $e',
            primaryButtonText: 'Regresar',
            onPrimaryButtonPressed: () {
              Get.back();
            },
          ),
          barrierDismissible: false,
        );
        return false;
      } finally {
        isLoading(false);
      }
    }
    return false;
  }
}
