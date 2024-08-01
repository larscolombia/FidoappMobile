import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

class AddPetController extends GetxController {
  // Controladores para los campos de texto
  TextEditingController petName =
      TextEditingController(); // Controlador para el nombre de la mascota
  TextEditingController petDescription =
      TextEditingController(); // Controlador para la descripción de la mascota
  TextEditingController petWeightController =
      TextEditingController(); // Controlador para el campo de peso
  TextEditingController petBirthDateController =
      TextEditingController(); // Controlador para la fecha de nacimiento

  // Observables para los demás campos
  var petImage = Rx<XFile?>(null); // Observable para la imagen de la mascota
  var petBirthDate =
      DateTime.now().obs; // Observable para la fecha de nacimiento
  TextEditingController petBreed =
      TextEditingController(); // Controlador para la raza de la mascota
  var petGender = ''.obs; // Observable para el género de la mascota
  var petWeight = 0.0.obs; // Observable para el peso de la mascota

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
      // Actualiza el controlador de texto para reflejar la nueva fecha
      petBirthDateController.text =
          petBirthDate.value.toLocal().toString().split(' ')[0];
    }
  }

  // Método para manejar el envío del formulario
  void submitForm(GlobalKey<FormState> formKey) {
    if (formKey.currentState?.validate() ?? false) {
      // Sincroniza el valor del controlador de peso con la variable observable
      petWeight.value = double.tryParse(petWeightController.text) ?? 0.0;

      // Recoger los datos de los campos y enviarlos de vuelta
      Get.back(result: {
        'name': petName.text,
        'description': petDescription.text,
        'image': petImage.value,
        'birthDate': petBirthDate.value,
        'breed': petBreed.text,
        'gender': petGender.value,
        'weight': petWeight.value,
      });
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
