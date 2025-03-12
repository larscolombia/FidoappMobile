// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
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
import 'package:pawlly/components/custom_snackbar.dart';

class SignInController extends GetxController {
  RxBool isNavigateToDashboard = false.obs;

  RxBool isRememberMe = true.obs;
  RxBool isLoading = false.obs;
  RxString userName = "".obs;

  TextEditingController emailCont =
      TextEditingController(text: Constants.DEFAULT_EMAIL);
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
    final userIsRemeberMe =
        getValueFromLocal(SharedPreferenceConst.IS_REMEMBER_ME);
    final userNameFromLocal =
        getValueFromLocal(SharedPreferenceConst.USER_NAME);
    if (userNameFromLocal is String) {
      userName(userNameFromLocal);
    }
    if (userIsRemeberMe == true) {
      final userEmail = getValueFromLocal(SharedPreferenceConst.USER_EMAIL);
      if (userEmail is String) {
        emailCont.text = userEmail;
      }
      final userPASSWORD =
          getValueFromLocal(SharedPreferenceConst.USER_PASSWORD);
      if (userPASSWORD is String) {
        passwordCont.text = userPASSWORD;
      }
    }
    super.onInit();
  }

  Future<void> saveForm() async {
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
      isLoading(false);
      CustomSnackbar.show(
        title: 'Error',
        message: e.toString(),
        isError: true,
      );
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
          barrierDismissible:
              false, // No permite cerrar al tocar fuera del diálogo
          builder: (context) => AlertDialog(
            title: Text('Seleccione su rol'),
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
                onPressed: () =>
                    Navigator.of(context).pop(null), // Devolver null si cancela
                child: Text('Cancelar'),
              ),
              TextButton(
                onPressed: () =>
                    Navigator.of(context).pop(LoginTypeConst.LOGIN_TYPE_USER),
                child: Text('Aceptar'),
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
        UserKeys.userType: value.userType ??
            LoginTypeConst
                .LOGIN_TYPE_USER, // Usar rol predeterminado si no es nuevo usuario
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
      toast(e.toString(), print: true);
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
      await AuthServiceApis.loginUser(request: request, isSocialLogin: true)
          .then((value) async {
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

  void handleLoginResponse(
      {required LoginResponse loginResponse, bool isSocialLogin = false}) {
    if (true) {
      //role
      loginUserData(loginResponse.userData);
      loginUserData.value.playerId = playerId.value;
      loginUserData.value.isSocialLogin = isSocialLogin;
      setValueToLocal(SharedPreferenceConst.USER_DATA, loginUserData.toJson());
      setValueToLocal(SharedPreferenceConst.USER_PASSWORD,
          isSocialLogin ? "" : passwordCont.text.trim());
      isLoggedIn(true);
      setValueToLocal(SharedPreferenceConst.IS_LOGGED_IN, true);
      setValueToLocal(SharedPreferenceConst.IS_REMEMBER_ME, isRememberMe.value);

      isLoading(false);
      if (!isNavigateToDashboard.value) {
        Get.offAll(() => HomeScreen(), binding: BindingsBuilder(() {
          Get.put(HomeController());
        }));
      } else {
        try {
          HomeController homeScreenController = Get.find();
          homeScreenController.updateIndex(0);
        } catch (e) {
          log('homeScreenController Get.find E: $e');
        }
        /*
        try {
          DashboardController dashboardController = Get.find();
          dashboardController.reloadBottomTabs();
        } catch (e) {
          log('dashboardController Get.find E: $e');
        }
        try {
          HomeScreenController homeScreenController = Get.find();
          homeScreenController.init();
        } catch (e) {
          log('homeScreenController Get.find E: $e');
        }
        try {
          BookingsController bookingsController = Get.find();
          bookingsController.getBookingList();
        } catch (e) {
          log('appointmentsController Get.find E: $e');
        }
        try {
          myPetsScreenController.init();
        } catch (e) {
          log('myPetsScreenController.init E: $e');
        }
        */
        log('Else : isNavigateToDashboard.value');
        // Get.back(result: true);
      }
    } else {
      isLoading(false);
      toast('Sorry User Cannot Signin'); //TODO: string translation
    }
  }
}
