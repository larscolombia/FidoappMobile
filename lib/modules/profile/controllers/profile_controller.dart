import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:pawlly/components/custom_alert_dialog_widget.dart';
import 'package:pawlly/components/custom_snackbar.dart';
import 'package:pawlly/configs.dart';
import 'package:pawlly/models/user_data_model.dart';
import 'package:pawlly/modules/pet_owner_profile/controllers/pet_owner_profile_controller.dart';
import 'package:pawlly/services/auth_service_apis.dart';

import '../../auth/sign_in/screens/signin_screen.dart';

class ProfileController extends GetxController {
  var profileController = Get.put(UserProfileController());
  late UserData currentUser; // Instancia del modelo de datos de usuario
  var isLoading = false.obs;
  var isEditing = false.obs;
  var nameController = TextEditingController().obs;
  var lastNameController = TextEditingController().obs;
  var passwordController = TextEditingController(text: '').obs; // Por seguridad, normalmente no se pre-llenaría
  var userGenCont = TextEditingController().obs;
  var userTypeCont = TextEditingController().obs;
  var emailController = TextEditingController().obs;
  var sexoValue = ''.obs;
  var duenioValue = ''.obs;
  var profileImagePath = ''.obs;
  var isPickerActive = false.obs; // Añadir una bandera para el estado activo del picker
  var userprofile = UserData().obs;
  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    // Cargar los datos del usuario desde AuthServiceApis al iniciar el controlador
    currentUser = AuthServiceApis.dataCurrentUser; // Asegúrate de que el servicio esté correctamente configurado
    dataUser();
    // Inicializar los controladores con los datos del usuario actual
    nameController.value.text = currentUser.firstName;
    lastNameController.value.text = currentUser.lastName;
    emailController.value.text = currentUser.email;
    userGenCont.value.text = mapGender(currentUser.gender);
    userTypeCont.value.text = currentUser.userType;
    profileImagePath.value = currentUser.profileImage; // Imagen de perfil del usuario

    // Configura los valores iniciales de los campos sexo y dueño
    sexoValue.value = currentUser.gender.isNotEmpty ? currentUser.gender : 'Femenino'; // Valor predeterminado si no está definido
    duenioValue.value = currentUser.userType.isNotEmpty ? currentUser.userType : 'Sí'; // Ajusta según el valor de userType o pon un valor por defecto
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

  // Definición del objeto user con tipos específicos
  var user = {
    'first_name': "",
    'lastName': "",
    'email': "",
    'gender': "",
    'profile_image': "",
    'id': "",
    'expert': "",
    'about_self': "",
    'address': "",
    'tags': <String>[], // Lista de cadenas
    'validation_number': ""
  };

  void addUserTag(Map<String, dynamic> user, String tag) {
    List<String> tags = List<String>.from(user['tags']);
    tags.add(tag);
    user['tags'] = tags;
  }

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
      Map<String, String> fields = {};

      user.forEach((key, value) {
        if (key == 'tags' && value is List<String>) {
          // Limpiar las comillas escapadas de las tags
          List<String> cleanTags = value.map((tag) {
            return tag.replaceAll("\"", ""); // Eliminar las comillas escapadas
          }).toList();

          // Serializar como un array JSON limpio
          fields[key] = jsonEncode(cleanTags); // Generará ["hhhj", "hjj"]
        } else if (value is String && value.isNotEmpty && key != 'profile_image') {
          // Añadir otros campos al request, excluyendo 'profile_image'
          fields[key] = value;
        }
      });

      // Añadir los campos al request
      fields.forEach((key, value) {
        request.fields[key] = value;
      });

      // Agregar la imagen si está disponible
      if (user['profile_image'] != null && user['profile_image'] is String && (user['profile_image'] as String).isNotEmpty) {
        request.files.add(await http.MultipartFile.fromPath(
          'profile_image',
          user['profile_image'] as String,
        ));
      }

      // Enviar la solicitud
      final response = await request.send();

      // Manejar la respuesta
      final responseBody = await response.stream.bytesToString();
      print('Response body: $responseBody');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(responseBody);
        await AuthServiceApis.saveUpdateProfileData(data);
        Get.dialog(
          //pisa papel
          CustomAlertDialog(
            assetImage: 'assets/icons/shield-tick.png',
            title: 'Acción Realizada Exitosamente',
            description: '',
            primaryButtonText: 'Aceptar',
            onPrimaryButtonPressed: () {
              profileController.fetchUserData("${AuthServiceApis.dataCurrentUser.id}");
              currentUser.profileImage = data['data']['profile_image'];
              //userGenCont.value.text = data['data']['gender';
              //   currentUser.gender = data['data']['gender'].toLowerCase();
              user['lastName'] = data['data']['last_name'];
              currentUser.lastName = data['data']['last_name'];
              Get.back();
            },
          ),
          barrierDismissible: true,
        );
      } else {
        print('Error al actualizar el perfil: $responseBody');
        CustomSnackbar.show(
          title: 'Error',
          message: 'No se pudo actualizar el perfil. Por favor, inténtalo nuevamente.',
          isError: true,
        );
      }
    } catch (e) {
      print('Excepción: $e');
      CustomSnackbar.show(
        title: 'Error',
        message: 'Ocurrió un error al actualizar el perfil: $e',
        isError: true,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchUserData(String id) async {
    try {
      print('Perfil de usuario: ${Uri.parse('$DOMAIN_URL/api/user-profile?user_id=${id}')}');
      final response = await http.get(
        Uri.parse('${Uri.parse('$DOMAIN_URL/api/user-profile?user_id=${id}')}'),
        headers: {
          'Authorization': 'Bearer ${AuthServiceApis.dataCurrentUser.apiToken}', // Reemplaza con tu lógica de token.
          'Content-Type': 'application/json',
        },
      );

      print('response profile ${response.statusCode}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        var data = json.decode(response.body)['data'];
        userprofile.value = UserData.fromJson(data); // Actualiza el modelo con la respuesta.
        print('userdata ${userprofile}');
      } else {
        CustomSnackbar.show(
          title: 'Error',
          message: 'Error al obtener datos del usuario',
          isError: true,
        );
      }
    } catch (e) {
      CustomSnackbar.show(
        title: 'Error',
        message: 'Error al obtener datos del usuario',
        isError: true,
      );
    } finally {
      isLoading(false);
    }
  }

  Future<void> deleteAccount() async {
    try {
      isLoading.value = true;

      final url = Uri.parse('$DOMAIN_URL/api/delete-account');

      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer ${AuthServiceApis.dataCurrentUser.apiToken}',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Logout the user and clear data
        await AuthServiceApis.logoutApi();

        Get.offAll(() => SignInScreen());

        CustomSnackbar.show(
          title: 'Cuenta eliminada',
          message: 'Tu cuenta ha sido eliminada exitosamente.',
          isError: false,
        );
      } else {
        print('Error al eliminar la cuenta: ${response.body}');
        CustomSnackbar.show(
          title: 'Error',
          message: 'No se pudo eliminar la cuenta. Por favor, inténtalo nuevamente.',
          isError: true,
        );
      }
    } catch (e) {
      print('Excepción: $e');
      CustomSnackbar.show(
        title: 'Error',
        message: 'Ocurrió un error al eliminar la cuenta: $e',
        isError: true,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void showDeleteConfirmation() {
    Get.dialog(
      CustomAlertDialog(
        title: '¿Estás seguro?',
        description: 'Esta acción eliminará permanentemente tu cuenta y todos tus datos. No podrás recuperarlos después.',
        primaryButtonText: 'Eliminar',
        secondaryButtonText: 'Cancelar',
        onPrimaryButtonPressed: () {
          Get.back(); // Close dialog
          deleteAccount(); // Call delete account method
        },
        onSecondaryButtonPressed: () {
          Get.back(); // Close dialog
        },
      ),
      barrierDismissible: true,
    );
  }

  String mapGender(String gender) {
    switch (gender) {
      case 'female':
        return 'Mujer';
      case 'male':
        return 'Hombre';
      case 'others':
        return 'Prefiero no decirlo';
      default:
        return '';
    }
  }
}
