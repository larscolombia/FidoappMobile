import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:pawlly/services/auth_service_apis.dart';
import 'package:pawlly/services/pet_service_apis.dart'; // Asegúrate de importar tu servicio

class AddPetController extends GetxController {
  // Controladores para los campos de texto
  TextEditingController petName = TextEditingController();
  TextEditingController petDescription = TextEditingController();
  TextEditingController petWeightController = TextEditingController();
  TextEditingController petBirthDateController = TextEditingController();

  // Observables para los demás campos
  var petImage = Rx<XFile?>(null);
  var petBirthDate = DateTime.now().obs;
  TextEditingController petBreed = TextEditingController();
  var petGender = ''.obs;
  var petWeight = 0.0.obs;

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
      // Sincroniza el valor del controlador de peso con la variable observable
      petWeight.value = double.tryParse(petWeightController.text) ?? 0.0;

      // Mapea los datos del formulario en un Map<String, dynamic>
      Map<String, dynamic> petData = {
        'name': petName.text,
        'description': petDescription.text,
        'pet_image': petImage.value != null ? petImage.value!.path : null,
        'date_of_birth': petBirthDateController.text,
        'breed_name': petBreed.text,
        'gender': petGender.value,
        'weight': petWeight.value,
        'user_id': AuthServiceApis
            .idCurrentUser, // Asegúrate de que el user_id está disponible
      };

      // Llamar al servicio para crear la mascota
      final newPet = await PetService.postCreatePetApi(body: petData);

      if (newPet != null) {
        // Mascota creada con éxito
        Get.snackbar('Éxito', 'Mascota creada con éxito');
        Get.back(result: newPet);
      } else {
        // Error al crear la mascota
        Get.snackbar('Error', 'Hubo un problema al crear la mascota');
      }
    } else {
      // Aquí puedes manejar lo que suceda si la validación falla
    }
  }

  // Limpiar los controladores cuando se destruye el controlador
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
