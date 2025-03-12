// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:pawlly/services/auth_service_apis.dart';
import 'package:pawlly/utils/common_base.dart';
import 'package:pawlly/components/custom_snackbar.dart';

class ForgetPasswordController extends GetxController {
  RxBool isLoading = false.obs;

  TextEditingController emailCont = TextEditingController();
  saveForm() async {
    try {
      isLoading(true);
      hideKeyBoardWithoutContext();

      Map<String, dynamic> req = {
        'email': emailCont.text.trim(),
      };

      await AuthServiceApis.forgotPasswordAPI(request: req);
      isLoading(false);
      CustomSnackbar.show(
        title: 'Éxito',
        message: 'Se han enviado las instrucciones a tu correo electrónico',
        isError: false,
      );
      Get.back();
    } catch (e) {
      isLoading(false);
      CustomSnackbar.show(
        title: 'Error',
        message: e.toString(),
        isError: true,
      );
    }
  }
}
