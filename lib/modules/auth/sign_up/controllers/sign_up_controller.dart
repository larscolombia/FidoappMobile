// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:pawlly/components/custom_alert_dialog_widget.dart';
import 'package:pawlly/main.dart';
import 'package:pawlly/modules/auth/sign_in/screens/signin_screen.dart';
import 'package:pawlly/services/auth_service_apis.dart';
import 'package:pawlly/utils/common_base.dart';
import 'package:pawlly/utils/constants.dart';
import 'package:pawlly/components/custom_snackbar.dart';

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
        title: 'Error',
        message: locale.value.pleaseAcceptTermsAnd,
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
        UserKeys.userType: LoginTypeConst.LOGIN_TYPE_USER,
      };

      final value = await AuthServiceApis.createUser(request: req);
      CustomSnackbar.show(
        title: 'Éxito',
        message: '¡Felicidades! Tu cuenta ha sido creada.',
        isError: false,
      );

      Get.offUntil(
        GetPageRoute(page: () => SignInScreen()),
        (route) => route.isFirst,
      );
    } catch (e) {
      CustomSnackbar.show(
        title: 'Error',
        message: e.toString(),
        isError: true,
      );
    } finally {
      isLoading(false);
    }
  }
}
