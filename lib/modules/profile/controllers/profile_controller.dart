import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfileController extends GetxController {
  var isEditing = false.obs;
  var nameController = TextEditingController(text: 'Victoria').obs;
  var lastNameController = TextEditingController(text: 'Doe').obs;
  var passwordController = TextEditingController(text: '1234').obs;
  var userGenCont = TextEditingController(text: 'Masculino').obs;
  var userTypeCont = TextEditingController(text: 'Dueño de mascota').obs;
  var emailController =
      TextEditingController(text: 'victoria.doe@example.com').obs;
  var sexoValue = 'Femenino'.obs;
  var duenioValue = 'Sí'.obs;
  var profileImagePath = ''.obs;
  var isPickerActive =
      false.obs; // Añadir una bandera para el estado activo del picker

  final ImagePicker _picker = ImagePicker();

  void toggleEditing() {
    isEditing.value = !isEditing.value;
  }

  void updateSexo(String? value) {
    if (value != null) {
      sexoValue.value = value;
    }
  }

  void updateDuenio(String? value) {
    if (value != null) {
      duenioValue.value = value;
    }
  }

  Future<void> pickImage() async {
    if (isPickerActive.value) return; // Evitar llamadas concurrentes
    isPickerActive.value = true; // Marcar el picker como activo

    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        profileImagePath.value = pickedFile.path;
      }
    } finally {
      isPickerActive.value = false; // Marcar el picker como inactivo
    }
  }
}
