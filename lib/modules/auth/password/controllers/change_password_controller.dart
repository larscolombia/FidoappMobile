// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pawlly/components/custom_snackbar.dart';
import 'package:pawlly/main.dart';
import 'package:pawlly/services/auth_service_apis.dart';
import 'package:pawlly/utils/app_common.dart';

import '../../../../../utils/common_base.dart';
import '../../../../../utils/constants.dart';
import '../../../../../utils/local_storage.dart';
import '../screens/pages/password_set_success.dart';

class ChangePasswordController extends GetxController {
  RxBool isLoading = false.obs;
  TextEditingController oldPasswordCont = TextEditingController();
  TextEditingController newpasswordCont = TextEditingController();
  TextEditingController confirmPasswordCont = TextEditingController();

  @override
  void onInit() {
    oldPasswordCont.text =
        getValueFromLocal(SharedPreferenceConst.USER_PASSWORD);
    super.onInit();
  }

  saveForm() async {
    try {
      isLoading(true);

      if (getValueFromLocal(SharedPreferenceConst.USER_PASSWORD) !=
          oldPasswordCont.text.trim()) {
        CustomSnackbar.show(
          title: 'Error',
          message: locale.value.yourOldPasswordDoesnT,
          isError: true,
        );
        return;
      } else if (newpasswordCont.text.trim() !=
          confirmPasswordCont.text.trim()) {
        CustomSnackbar.show(
          title: 'Error',
          message: locale.value.yourNewPasswordDoesnT,
          isError: true,
        );
        return;
      } else if (oldPasswordCont.text.trim() == newpasswordCont.text.trim()) {
        CustomSnackbar.show(
          title: 'Error',
          message: locale.value.oldAndNewPassword,
          isError: true,
        );
        return;
      }

      hideKeyBoardWithoutContext();
      Map<String, dynamic> req = {
        'old_password': getValueFromLocal(SharedPreferenceConst.USER_PASSWORD),
        'new_password': confirmPasswordCont.text.trim(),
      };

      final value = await AuthServiceApis.changePasswordAPI(request: req);
      setValueToLocal(
          SharedPreferenceConst.USER_PASSWORD, confirmPasswordCont.text.trim());
      loginUserData.value.apiToken = value.data.apiToken;

      CustomSnackbar.show(
        title: 'Éxito',
        message: 'Contraseña actualizada correctamente',
        isError: false,
      );

      Get.to(() => const PasswordSetSuccess());
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
