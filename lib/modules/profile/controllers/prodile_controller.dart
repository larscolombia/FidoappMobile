import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class MiPerfilController extends GetxController {
  var isEditing = false.obs;
  var nombreController = TextEditingController(text: 'Victoria').obs;
  var apellidoController = TextEditingController(text: 'Doe').obs;
  var correoController =
      TextEditingController(text: 'victoria.doe@example.com').obs;
  var sexoValue = 'Femenino'.obs;
  var duenioValue = 'Sí'.obs;
  var profileImagePath = ''.obs;

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
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      profileImagePath.value = pickedFile.path;
    }
  }
}
