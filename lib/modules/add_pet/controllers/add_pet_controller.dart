import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pawlly/components/custom_snackbar.dart';
import 'package:pawlly/models/brear_model.dart';
import 'package:pawlly/modules/integracion/controller/notificaciones/notificaciones_controller.dart';
import 'package:pawlly/repositories/pets_repository.dart';
import 'package:pawlly/services/auth_service_apis.dart';
import 'package:pawlly/services/breeds_service_apis.dart';


class AddPetController extends GetxController {
  final petsRepository = Get.put(PetsRepository());

  RxBool isLoading = false.obs;
  // Controladores para los campos de texto
  TextEditingController petName = TextEditingController();
  TextEditingController petDescription = TextEditingController();
  TextEditingController petWeightController = TextEditingController();
  TextEditingController petBirthDateController = TextEditingController();
  TextEditingController petBreed = TextEditingController();

  // Observables
  var petBirthDate = DateTime.now().obs;
  var petGender = ''.obs;
  var petWeight = 0.0.obs;
  var petWeightUnit = 'Kg'.obs;
  var breedList = <BreedModel>[].obs;
  var petImage = Rx<XFile?>(null);
  var base64Image = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchBreedsList(); // Llamar a la API cuando se inicializa el controlador
  }

  // Método para obtener la lista de razas desde la API
  Future<void> fetchBreedsList() async {
    final breeds = await BreedsServiceApis.getBreedsListApi();
    if (breeds.isNotEmpty) {
      breedList.assignAll(breeds);
    } else {
      // Manejar el error si la lista está vacía
      CustomSnackbar.show(
        title: 'Error',
        message: 'No se pudo cargar la lista de razas',
        isError: true,
      );
    }
  }

  // Método para seleccionar una imagen y convertirla a Base64
  void pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      petImage.value = image; // Mantener la referencia al archivo de imagen
    }
  }

  void toogleWeightUnit() {
    if (petWeightUnit.value == 'Kg') {
      petWeightUnit.value = 'Lb';
    } else if (petWeightUnit.value == 'Lb') {
      petWeightUnit.value = 'Kg';
    }
  }

  void submitForm(GlobalKey<FormState> formKey) async {
    if (formKey.currentState?.validate() ?? false) {
      isLoading(true);

      petWeight.value = double.tryParse(petWeightController.text) ?? 0.0;

      Map<String, String> petData = {
        'name': petName.text,
        'additional_info': petDescription.text,
        // 'pettype': '...', Se va a utilizar posteriormente para indicar la especie
        'date_of_birth': petBirthDateController.text, // Se envía en formato 2025-06-27
        'breed_name': petBreed.text,
        'gender': petGender.value,
        'weight': petWeight.value.toString(),
        'weight_unit': petWeightUnit.value,
        'user_id': AuthServiceApis.dataCurrentUser.id.toString(),
      };

      print('petData: $petData');
      petData.removeWhere((key, value) => value.isEmpty);

      try {
        final newPet = await petsRepository.createPet(
          body: petData,
          imagePath: petImage.value?.path ?? '', // Añadir la ruta de la imagen
        );

        if (newPet != null) {
          final notificationController = Get.find<NotificationController>();
          await notificationController.fetchNotifications();
        } else {
          throw Exception('Error al crear la mascota');
        }
      } catch (e) {
        print('Error al crear la mascota: $e');
        /** 
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
        );*/
      } finally {
        isLoading(false);
      }
    }
  }
  
  void resetForm() {
    petName.clear();
    petDescription.clear();
    petWeightController.clear();
    petBirthDateController.clear();
    petBreed.clear();
    petGender.value = '';
    petWeight.value = 0.0;
    petWeightUnit.value = 'Kg';
    petImage.value = null;
    base64Image.value = '';
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
