// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:pawlly/components/custom_snackbar.dart';
import 'package:pawlly/models/login_response_model.dart';
import 'package:pawlly/modules/components/input_select.dart';
import 'package:pawlly/modules/home/controllers/home_controller.dart';
import 'package:pawlly/modules/home/screens/home_screen.dart';
import 'package:pawlly/services/auth_service_apis.dart';
import 'package:pawlly/utils/app_common.dart';
import 'package:pawlly/utils/common_base.dart';
import 'package:pawlly/utils/constants.dart';
import 'package:pawlly/utils/local_storage.dart';
import 'package:pawlly/utils/social_logins.dart';

import '../../../welcome/screens/welcome_screen.dart';

class SignInController extends GetxController {
  RxBool isNavigateToDashboard = false.obs;

  RxBool isRememberMe = true.obs;
  RxBool isLoading = false.obs;
  RxString userName = "".obs;

  TextEditingController emailCont = TextEditingController(text: Constants.DEFAULT_EMAIL);
  TextEditingController passwordCont = TextEditingController(text: '');

  FocusNode emailFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();

  void toggleSwitch() {
    isRememberMe.value = !isRememberMe.value;
  }

  @override
  void onInit() {
    if (Get.arguments is bool) {
      isNavigateToDashboard(Get.arguments == true);
    }
    final userIsRemeberMe = getValueFromLocal(SharedPreferenceConst.IS_REMEMBER_ME);
    final userNameFromLocal = getValueFromLocal(SharedPreferenceConst.USER_NAME);
    if (userNameFromLocal is String) {
      userName(userNameFromLocal);
    }
    if (userIsRemeberMe == true) {
      final userEmail = getValueFromLocal(SharedPreferenceConst.USER_EMAIL);
      if (userEmail is String) {
        emailCont.text = userEmail;
      }
      final userPASSWORD = getValueFromLocal(SharedPreferenceConst.USER_PASSWORD);
      if (userPASSWORD is String) {
        passwordCont.text = userPASSWORD;
      }
    }
    super.onInit();
  }

  Future<void> saveForm() async {
    // Validar campos vacíos
    if (emailCont.text.isEmpty || passwordCont.text.isEmpty) {
      CustomSnackbar.show(
        title: 'Campos requeridos',
        message: 'Por favor ingrese su correo y contraseña',
        isError: true,
      );
      return;
    }

    try {
      isLoading(true);
      hideKeyBoardWithoutContext();

      Map<String, dynamic> req = {
        'email': emailCont.text.trim(),
        'password': passwordCont.text.trim(),
        UserKeys.userType: LoginTypeConst.LOGIN_TYPE_USER,
      };

      final value = await AuthServiceApis.loginUser(request: req);
      handleLoginResponse(loginResponse: value);
      CustomSnackbar.show(
        title: 'Bienvenido',
        message: 'Has iniciado sesión exitosamente',
        isError: false,
      );
    } catch (e) {
      // Si el error es de usuario no registrado, mostrar mensaje específico
      if (e.toString().contains('user not found') || e.toString().contains('no registered')) {
        CustomSnackbar.show(
          title: 'Usuario no registrado',
          message: 'Por favor regístrese antes de iniciar sesión',
          isError: true,
        );
      } else {
        CustomSnackbar.show(
          title: 'Error',
          message: e.toString(),
          isError: true,
        );
      }
    } finally {
      isLoading(false);
    }
  }

  googleSignIn(BuildContext context) async {
    try {
      isLoading(true);

      // Realizar el proceso de autenticación de Google
      final value = await GoogleSignInAuthService.signInWithGoogle();

      // Verifica si es un nuevo usuario
      if (value.isNewUser) {
        // Mostrar el diálogo solo si el usuario es nuevo
        final selectedRole = await showDialog<String?>(
          context: context,
          barrierDismissible: false, // No permite cerrar al tocar fuera del diálogo
          builder: (context) => AlertDialog(
            title: const Text('Seleccione su rol'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                InputSelect(
                  TextColor: Colors.black,
                  label: 'Categoría del registro',
                  placeholder: 'Seleccione el tipo de usuario',
                  onChanged: (value) {
                    LoginTypeConst.LOGIN_TYPE_USER = value ?? 'user';
                  },
                  items: const [
                    DropdownMenuItem(
                      value: 'user',
                      child: Text('Usuario'),
                    ),
                    DropdownMenuItem(
                      value: 'vet',
                      child: Text('Veterinario'),
                    ),
                    DropdownMenuItem(
                      value: 'trainer',
                      child: Text('Entrenador'),
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(null), // Devolver null si cancela
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(LoginTypeConst.LOGIN_TYPE_USER),
                child: const Text('Aceptar'),
              ),
            ],
          ),
        );

        // Verificar si el usuario canceló
        if (selectedRole == null) {
          log('Acción cancelada por el usuario.'); // Registro de cancelación
          isLoading(false); // Detener el spinner
          return; // Detener la ejecución del flujo
        }

        // Asignar el rol seleccionado
        value.userType = selectedRole; // Asignar el tipo de usuario
      }

      // Preparar los datos para la solicitud de inicio de sesión/registro
      Map<String, dynamic> request = {
        UserKeys.contactNumber: value.mobile,
        UserKeys.email: value.email,
        UserKeys.firstName: value.firstName,
        UserKeys.lastName: value.lastName,
        UserKeys.playerId: playerId.value,
        UserKeys.userType: value.userType ?? LoginTypeConst.LOGIN_TYPE_USER,
        UserKeys.username: value.userName,
        UserKeys.profileImage: value.profileImage,
        UserKeys.loginType: LoginTypeConst.LOGIN_TYPE_GOOGLE,
      };

      log('signInWithGoogle REQUEST: $request');

      // Llamar a la API de inicio de sesión o registro
      final loginResponse = await AuthServiceApis.loginUser(
        request: request,
        isSocialLogin: true,
      );

      // Manejar la respuesta del inicio de sesión
      handleLoginResponse(loginResponse: loginResponse, isSocialLogin: true);
    } catch (e) {
      log('Error durante signInWithGoogle: $e');
      // toast(e.toString(), print: true);
      toast('Tu cuenta no está configurada para iniciar sesión con Google.', print: true);
    } finally {
      isLoading(false);
    }
  }

  appleSignIn() async {
    isLoading(true);
    await GoogleSignInAuthService.signInWithApple().then((value) async {
      Map request = {
        UserKeys.contactNumber: value.mobile,
        UserKeys.email: value.email,
        UserKeys.firstName: value.firstName,
        UserKeys.lastName: value.lastName,
        UserKeys.playerId: playerId.value,
        UserKeys.userType: LoginTypeConst.LOGIN_TYPE_USER,
        UserKeys.username: value.userName,
        UserKeys.profileImage: value.profileImage,
        UserKeys.loginType: LoginTypeConst.LOGIN_TYPE_APPLE,
      };
      log('signInWithGoogle REQUEST: $request');

      /// Social Login Api
      await AuthServiceApis.loginUser(request: request, isSocialLogin: true).then((value) async {
        handleLoginResponse(loginResponse: value, isSocialLogin: true);
        print('VALUEEE LOGIN $value');
      }).catchError((e) {
        isLoading(false);
        toast(e.toString(), print: true);
      });
    }).catchError((e) {
      isLoading(false);
      toast(e.toString(), print: true);
    });
  }

  void handleLoginResponse({required LoginResponse loginResponse, bool isSocialLogin = false}) {
    loginUserData(loginResponse.userData);
    loginUserData.value.playerId = playerId.value;
    loginUserData.value.isSocialLogin = isSocialLogin;

    // Guardar datos incluyendo la contraseña si Remember Me está activo
    Map<String, dynamic> requestData = {
      UserKeys.email: loginResponse.userData.email,
    };

    if (isRememberMe.value && !isSocialLogin) {
      requestData['password'] = passwordCont.text.trim();
      setValueToLocal(SharedPreferenceConst.USER_PASSWORD, passwordCont.text.trim());
    }

    // Guardar estado de Remember Me
    setValueToLocal(SharedPreferenceConst.IS_REMEMBER_ME, isRememberMe.value);

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

  // Método para cerrar sesión
  Future<void> logout() async {
    try {
      isLoading(true);

      // Primero llamar al API de logout
      final result = await AuthServiceApis.logoutApi();

      // Cerrar sesión de Google/Firebase en caso de haber iniciado con ellos
      await GoogleSignInAuthService.signOutGoogle();

      if (result.status) {
        // Si el logout fue exitoso, navegar a WelcomeScreen
        isLoading(false);
        await Get.offAll(
          () => WelcomeScreen(),
          predicate: (route) => false,
        );
      } else {
        throw 'Error al cerrar sesión';
      }
    } catch (e) {
      print('Error durante logout: $e');
      isLoading(false);

      // Aún si hay error, intentar navegar al Welcome Screen
      await Get.offAll(() => WelcomeScreen());
    }
  }
}
