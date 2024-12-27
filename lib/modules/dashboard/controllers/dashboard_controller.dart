import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pawlly/models/user_data_model.dart';
import 'dart:io';

import 'package:pawlly/modules/auth/model/login_response_model.dart';
import 'package:pawlly/routes/app_pages.dart';
import 'package:pawlly/services/auth_service_apis.dart';

class DashboardController extends GetxController {
  late UserData currentUser;
  var profileImagePath = ''.obs;
  var name = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Cargar los datos del usuario desde AuthServiceApis al iniciar el controlador
    currentUser = AuthServiceApis
        .dataCurrentUser; // Asegúrate de que el servicio esté correctamente configurado

    // Inicializar los controladores con los datos del usuario actual
    name.value = currentUser.firstName;
    profileImagePath.value =
        currentUser.profileImage; // Imagen de perfil del usuario
  }

  Future<void> logoutUser() async {
    // Llama a la función para cerrar sesión
    await AuthServiceApis.logoutApi();

    // Agregar un pequeño retraso antes de redirigir
    Future.delayed(const Duration(milliseconds: 500), () {
      // Redirigir al usuario a la pantalla de inicio de sesión
      Get.offAllNamed(
          Routes.SIGNIN); // Limpia el historial de rutas y redirige al login
    });
  }
}
