// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:pawlly/components/custom_alert_dialog_widget.dart';
import 'package:pawlly/components/custom_snackbar.dart';
import 'package:pawlly/main.dart';
import 'package:pawlly/modules/auth/sign_in/screens/signin_screen.dart';
import 'package:pawlly/services/auth_service_apis.dart';
import 'package:pawlly/utils/common_base.dart';
import 'package:pawlly/modules/home/controllers/home_controller.dart';
import 'package:pawlly/modules/home/screens/home_screen.dart';
import 'package:pawlly/utils/constants.dart';
import 'package:pawlly/utils/local_storage.dart';
import 'package:pawlly/utils/app_common.dart';

class SignUpController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool agree = false.obs;
  RxBool isAcceptedTc = false.obs;
  TextEditingController emailCont = TextEditingController();
  TextEditingController fisrtNameCont = TextEditingController();
  TextEditingController lastNameCont = TextEditingController();
  TextEditingController passwordCont = TextEditingController();
  TextEditingController password2Cont = TextEditingController();
  TextEditingController userTypeCont = TextEditingController();
  TextEditingController genCont = TextEditingController();
  TextEditingController certificationNumberCont = TextEditingController();
  TextEditingController certificationNameCont = TextEditingController();
  TextEditingController cvNameCont = TextEditingController();
  TextEditingController paymentAccountCont = TextEditingController();

  RxString certificationPath = ''.obs;
  RxString cvPath = ''.obs;
  RxBool isProfessional = false.obs;

  void onUserTypeChanged(String? value) {
    userTypeCont.text = value ?? '';
    if (value == 'Veterinario' || value == 'Entrenador') {
      isProfessional.value = true;
    } else {
      isProfessional.value = false;
    }
  }

  Future<void> saveForm() async {
    if (!isAcceptedTc.value) {
      CustomSnackbar.show(
        title: 'Términos y condiciones',
        message: 'Debe aceptar los términos y condiciones para continuar',
        isError: true,
      );
      return;
    }

    try {
      isLoading(true);
      hideKeyBoardWithoutContext();
      Map<String, dynamic> req = {
        "email": emailCont.text.trim(),
        "first_name": fisrtNameCont.text.trim(),
        "last_name": lastNameCont.text.trim(),
        "password": passwordCont.text.trim(),
        "gender": mapGender(genCont.text),
        "user_type": mapUserType(userTypeCont.text)
      };

      if (isProfessional.value) {
        if (certificationPath.value.isEmpty ||
            certificationNumberCont.text.trim().isEmpty ||
            cvPath.value.isEmpty) {
          CustomSnackbar.show(
            title: 'Campos incompletos',
            message: 'Complete la información profesional requerida',
            isError: true,
          );
          return;
        }
        req['certificate_number'] = certificationNumberCont.text.trim();
        if (paymentAccountCont.text.trim().isNotEmpty) {
          req['payment_account'] = paymentAccountCont.text.trim();
        }
      }
      final value = isProfessional.value
          ? await AuthServiceApis.createUserWithFiles(
              request: req,
              certificationPath: certificationPath.value,
              cvPath: cvPath.value,
            )
          : await AuthServiceApis.createUser(request: req);
      toast(value.message.toString(), print: true);

      String userType = mapUserType(userTypeCont.text);
      var message = userType != 'user'
          ? '¡Felicidades! Tu cuenta está pediente de aprobación'
          : '¡Felicidades! Tu cuenta ha sido creada.';

      // Mostrar el diálogo de éxito con dos botones
      Get.dialog(
        CustomAlertDialog(
          icon: Icons.check_circle_outline,
          title: locale.value.actionPerformedSuccessfully,
          description: message,
          primaryButtonText: "Continuar",
          onPrimaryButtonPressed: () async {
            Get.back();
            if (userType == 'user') {
              // Solo login automático para Dueño de Mascota
              await performAutoLogin();
            } else {
              // Para otros tipos, ir al login como antes
              Get.offUntil(GetPageRoute(page: () => SignInScreen()), (route) => route.isFirst);
            }
          },
        ),
        barrierDismissible: false, // No permite cerrar el diálogo tocando fuera
      );
    } catch (e) {
      log('E: $e');
      toast(e.toString(), print: true);

      // Mostrar el diálogo de error con un botón
      Get.dialog(
        CustomAlertDialog(
          icon: Icons.error_outline,
          title: locale.value.actionFailed,
          description: "Ha ocurrido un error.",
          primaryButtonText: "Regresar",
          onPrimaryButtonPressed: () {
            Get.back(); // Regresa al diálogo anterior
          },
        ),
        barrierDismissible: false, // No permite cerrar el diálogo tocando fuera
      );
    } finally {
      isLoading(false);
    }
  }

  // Método para realizar login automático después del registro
  Future<void> performAutoLogin() async {
    try {
      isLoading(true);
      
      // Preparar los datos para el login automático
      Map<String, dynamic> loginRequest = {
        'email': emailCont.text.trim(),
        'password': passwordCont.text.trim(),
        UserKeys.userType: mapUserType(userTypeCont.text),
      };

      // Realizar el login automático
      final loginResponse = await AuthServiceApis.loginUser(request: loginRequest);
      
      // Manejar la respuesta del login como en el SignInController
      handleAutoLoginResponse(loginResponse);
      
      CustomSnackbar.show(
        title: 'Bienvenido',
        message: 'Has iniciado sesión exitosamente',
        isError: false,
      );
      
    } catch (e) {
      log('Error en login automático: $e');
      CustomSnackbar.show(
        title: 'Error en login automático',
        message: 'Tu cuenta fue creada pero hubo un problema al iniciar sesión. Por favor inicia sesión manualmente.',
        isError: true,
      );
      
      // Navegar a la pantalla de login para que el usuario inicie sesión manualmente
      Get.offUntil(GetPageRoute(page: () => SignInScreen()), (route) => route.isFirst);
    } finally {
      isLoading(false);
    }
  }

  // Método para manejar la respuesta del login automático
  void handleAutoLoginResponse(loginResponse) {
    loginUserData(loginResponse.userData);
    loginUserData.value.playerId = playerId.value;
    loginUserData.value.isSocialLogin = false;

    // Guardar datos de sesión
    Map<String, dynamic> requestData = {
      UserKeys.email: loginResponse.userData.email,
    };

    // Guardar datos de sesión
    AuthServiceApis.saveLoginData(requestData, loginResponse.toJson());

    // Actualizar estado de sesión
    isLoggedIn(true);
    setValueToLocal(SharedPreferenceConst.IS_LOGGED_IN, true);

    // Navegar a HomeScreen
    Get.offAll(() => const HomeScreen(), binding: BindingsBuilder(() {
      Get.put(HomeController());
    }));
  }

  String mapGender(String gender) {
    switch (gender) {
      case 'Mujer':
        return 'female';
      case 'Hombre':
        return 'male';
      case 'Prefiero no decirlo':
        return 'others';
      default:
        return '';
    }
  }

  String mapUserType(String userType) {
    switch (userType) {
      case 'Veterinario':
        return 'vet';
      case 'Entrenador':
        return 'trainer';
      case 'Dueño de Mascota':
        return 'user';
      default:
        return '';
    }
  }
}
