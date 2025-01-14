import 'dart:convert';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pawlly/components/custom_alert_dialog_widget.dart';
import 'package:pawlly/configs.dart';
import 'package:pawlly/models/user_data_model.dart';
import 'package:pawlly/modules/auth/model/login_response_model.dart';
import 'dart:io';
import 'package:pawlly/services/auth_service_apis.dart';

import 'package:http/http.dart' as http;

class ProfileController extends GetxController {
  late UserData currentUser; // Instancia del modelo de datos de usuario
  var isLoading = false.obs;
  var isEditing = false.obs;
  var nameController = TextEditingController().obs;
  var lastNameController = TextEditingController().obs;
  var passwordController = TextEditingController(text: '')
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
    currentUser = AuthServiceApis
        .dataCurrentUser; // Asegúrate de que el servicio esté correctamente configurado
    dataUser();
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
        user['profile_image'] = pickedFile.path;
      }
    } finally {
      isPickerActive.value = false; // Marcar el picker como inactivo
    }
  }

  var user = {
    'first_name': "",
    'lastName': "",
    'email': "",
    'gender': "",
    'userType': "",
    'profile_image': "",
    'id': "",
    'role': "",
    'about_self': "",
    'address': ""
  };
  void dataUser() {
    user['first_name'] = currentUser.firstName;
    user['last_name'] = currentUser.lastName;
    user['email'] = currentUser.email;
    user['gender'] = currentUser.gender;
    user['userType'] = currentUser.userType;
    user['profileImage'] = currentUser.profileImage;
  }

  Future<void> updateProfile() async {
    try {
      isLoading.value = true;

      final url = Uri.parse('$DOMAIN_URL/api/update-profile');

      // Crear la solicitud multipart
      final request = http.MultipartRequest('POST', url);

      // Agregar encabezados
      request.headers.addAll({
        'Authorization': 'Bearer ${AuthServiceApis.dataCurrentUser.apiToken}',
      });

      // Agregar datos del usuario
      user.forEach((key, value) {
        if (value.isNotEmpty && key != 'profile_image') {
          request.fields[key] = value.toString();
        }
      });

      // Agregar la imagen si está disponible
      if (user['profile_image'] != null && user['profile_image']!.isNotEmpty) {
        request.files.add(await http.MultipartFile.fromPath(
          'profile_image',
          user[
              'profile_image']!, // Usa el operador de null-aware para asegurar que no sea nulo
        ));
      }

      // Enviar la solicitud
      final response = await request.send();

      // Manejar la respuesta
      print('response data ususario ${response.statusCode}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseBody = await response.stream.bytesToString();
        final data = json.decode(responseBody);
        Get.snackbar(
          'exito',
          'Perfil actualizado exitosamente',
          backgroundColor: Colors.green,
        );
        print('response data ususario $data');
        // currentUser = UserData.fromJson(data['data']);
        currentUser.profileImage = data['data']['profile_image'];
        userGenCont.value.text = data['data']['gender'].toLowerCase();
        currentUser.gender = data['data']['gender'].toLowerCase();
        user['last_name'] = data['data']['last_name'];
        currentUser.lastName = data['data']['last_name'];
      } else {
        final responseBody = await response.stream.bytesToString();
        print('Error al actualizar el perfil: $responseBody');
      }
    } catch (e) {
      print('Excepción: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
