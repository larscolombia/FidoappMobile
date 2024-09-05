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
  // Controladores para los campos de texto
  TextEditingController petName = TextEditingController();
  TextEditingController petDescription = TextEditingController();
  TextEditingController petWeightController = TextEditingController();
  TextEditingController petBirthDateController = TextEditingController();
  TextEditingController petBreed = TextEditingController();

  // Observables
  var petImage = Rx<XFile?>(null);
  var petBirthDate = DateTime.now().obs;
  var petGender = ''.obs;
  var petWeight = 0.0.obs;
  var breedList = <BreedModel>[].obs; // Observable para la lista de razas

  @override
  void onInit() {
    super.onInit();
    fetchBreedsList(); // Llamar a la API cuando se inicializa el controlador
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

  // Método para seleccionar una imagen
  void pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      petImage.value = image;
    }
  }

  // Método para seleccionar la fecha de nacimiento
  Future<void> pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: petBirthDate.value,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != petBirthDate.value) {
      petBirthDate.value = picked;
      petBirthDateController.text =
          petBirthDate.value.toLocal().toString().split(' ')[0];
    }
  }

  void submitForm(GlobalKey<FormState> formKey) async {
    if (formKey.currentState?.validate() ?? false) {
      isLoading(true);

      petWeight.value = double.tryParse(petWeightController.text) ?? 0.0;

      Map<String, dynamic> petData = {
        'name': petName.text,
        'description': petDescription.text,
        'pet_image': petImage.value != null ? petImage.value!.path : null,
        'date_of_birth': petBirthDateController.text,
        'breed_name': petBreed.text,
        'gender': petGender.value,
        'weight': petWeight.value,
        'user_id': AuthServiceApis.dataCurrentUser.id,
      };

      // Eliminar las claves con valores nulos o vacíos
      petData.removeWhere(
          (key, value) => value == null || value == '' || value == 0.0);

      try {
        final newPet = await PetService.postCreatePetApi(body: petData);

        if (newPet != null) {
          // Actualizar la lista de mascotas en HomeController
          final homeController = Get.find<HomeController>();
          homeController.profiles
              .add(newPet); // Agregar la nueva mascota a la lista
          homeController.profiles.refresh(); // Refrescar la lista

          // Mostrar el diálogo de éxito
          Get.dialog(
            CustomAlertDialog(
              icon: Icons.check_circle_outline,
              title: 'Mascota creada',
              description: 'La mascota ha sido creada exitosamente.',
              primaryButtonText: 'Continuar',
              onPrimaryButtonPressed: () {
                Get.back(); // Cerrar el diálogo
                Get.back(); // Regresar a la pantalla anterior
                Get.back();
              },
            ),
            barrierDismissible:
                false, // No permite cerrar el diálogo tocando fuera
          );
        } else {
          throw Exception('Error al crear la mascota');
        }
      } catch (e) {
        print('Error al crear la mascota: $e');

        // Mostrar el diálogo de error
        Get.dialog(
          CustomAlertDialog(
            icon: Icons.error_outline,
            title: 'Error',
            description: 'Hubo un problema al crear la mascota.',
            primaryButtonText: 'Regresar',
            onPrimaryButtonPressed: () {
              Get.back(); // Cerrar el diálogo
            },
          ),
          barrierDismissible:
              false, // No permite cerrar el diálogo tocando fuera
        );
      } finally {
        isLoading(false);
      }
    }
  }

  @override
  void onClose() {
    petName.dispose();
    petDescription.dispose();
    petWeightController.dispose();
    petBreed.dispose();
    petBirthDateController.dispose();
    super.onClose();
  }
}
