// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:pawlly/main.dart';
import 'package:pawlly/services/auth_service_apis.dart';
import 'package:pawlly/utils/app_common.dart';

import '../screens/pages/password_set_success.dart';
import '../../../../../utils/common_base.dart';
import '../../../../../utils/constants.dart';
import '../../../../../utils/local_storage.dart';

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
    print('change Pass Controller join');

    isLoading(true);
    try {
      if (getValueFromLocal(SharedPreferenceConst.USER_PASSWORD) !=
          oldPasswordCont.text.trim()) {
        toast(locale.value.yourOldPasswordDoesnT);
        return;
      } else if (newpasswordCont.text.trim() !=
          confirmPasswordCont.text.trim()) {
        toast(locale.value.yourNewPasswordDoesnT);
        return;
      } else if ((oldPasswordCont.text.trim() == newpasswordCont.text.trim()) &&
          oldPasswordCont.text.trim() == confirmPasswordCont.text.trim()) {
        toast(locale.value.oldAndNewPassword);
        return;
      }
      hideKeyBoardWithoutContext();

      Map<String, dynamic> req = {
        'old_password': getValueFromLocal(SharedPreferenceConst.USER_PASSWORD),
        'new_password': confirmPasswordCont.text.trim(),
      };

      await AuthServiceApis.changePasswordAPI(request: req).then((value) async {
        setValueToLocal(SharedPreferenceConst.USER_PASSWORD,
            confirmPasswordCont.text.trim());
        loginUserData.value.apiToken = value.data.apiToken;
        Get.to(() => const PasswordSetSuccess());
      }).catchError((e) {
        toast(e.toString(), print: true);
      });
    } catch (e) {
      toast(e.toString(), print: true);
    } finally {
      isLoading(false);
    }
  }
}
