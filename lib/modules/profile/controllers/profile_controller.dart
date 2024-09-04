import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pawlly/models/user_data_model.dart';
import 'package:pawlly/modules/auth/model/login_response_model.dart';
import 'dart:io';
import 'package:pawlly/services/auth_service_apis.dart';

class ProfileController extends GetxController {
  late UserData currentUser; // Instancia del modelo de datos de usuario

  var isEditing = false.obs;
  var nameController = TextEditingController().obs;
  var lastNameController = TextEditingController().obs;
  var passwordController = TextEditingController(text: '12345678')
      .obs; // Por seguridad, normalmente no se pre-llenaría
  var userGenCont = TextEditingController().obs;
  var userTypeCont = TextEditingController().obs;
  var emailController = TextEditingController().obs;
  var sexoValue = ''.obs;
  var duenioValue = ''.obs;
  var profileImagePath = ''.obs;
  var isPickerActive =
      false.obs; // Añadir una bandera para el estado activo del picker

  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    // Cargar los datos del usuario desde AuthServiceApis al iniciar el controlador
    currentUser = AuthServiceApis.dataCurrentUser
        as UserData; // Asegúrate de que el servicio esté correctamente configurado

    // Inicializar los controladores con los datos del usuario actual
    nameController.value.text = currentUser.firstName;
    lastNameController.value.text = currentUser.lastName;
    emailController.value.text = currentUser.email;
    userGenCont.value.text = currentUser.gender;
    userTypeCont.value.text = currentUser.userType;
    profileImagePath.value =
        currentUser.profileImage; // Imagen de perfil del usuario

    // Configura los valores iniciales de los campos sexo y dueño
    sexoValue.value = currentUser.gender.isNotEmpty
        ? currentUser.gender
        : 'Femenino'; // Valor predeterminado si no está definido
    duenioValue.value = currentUser.userType.isNotEmpty
        ? currentUser.userType
        : 'Sí'; // Ajusta según el valor de userType o pon un valor por defecto
  }

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
