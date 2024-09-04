import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:pawlly/models/brear_model.dart';
import 'package:pawlly/services/auth_service_apis.dart';
import 'package:pawlly/services/pet_service_apis.dart'; // Asegúrate de importar tu servicio

class AddPetController extends GetxController {
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

  // Método para manejar el envío del formulario
  void submitForm(GlobalKey<FormState> formKey) async {
    if (formKey.currentState?.validate() ?? false) {
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

      final newPet = await PetService.postCreatePetApi(body: petData);

      if (newPet != null) {
        Get.snackbar('Éxito', 'Mascota creada con éxito');
        Get.back(result: newPet);
      } else {
        Get.snackbar('Error', 'Hubo un problema al crear la mascota');
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
