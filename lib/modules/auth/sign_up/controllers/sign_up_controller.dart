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
import 'package:pawlly/utils/constants.dart';

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
        "last_name": fisrtNameCont.text.trim(),
        "password": passwordCont.text.trim(),
        UserKeys.userType: LoginTypeConst.LOGIN_TYPE_USER,
      };

      final value = await AuthServiceApis.createUser(request: req);
      toast(value.message.toString(), print: true);

      // Mostrar el diálogo de éxito con dos botones
      Get.dialog(
        CustomAlertDialog(
          icon: Icons.check_circle_outline,
          title: locale.value.actionPerformedSuccessfully,
          description: "¡Felicidades! Tu cuenta ha sido creada.",
          primaryButtonText: "Continuar",
          onPrimaryButtonPressed: () {
            // Navegar a la pantalla de inicio de sesión sin iniciar sesión automáticamente
            Get.offUntil(GetPageRoute(page: () => SignInScreen()),
                (route) => route.isFirst);
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
}
