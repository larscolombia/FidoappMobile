// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:pawlly/main.dart';
import 'package:pawlly/utils/app_common.dart';

import '../screens/pages/password_set_success.dart';
import '../../../../../utils/common_base.dart';
import '../../../../../utils/constants.dart';
import '../../../../../utils/local_storage.dart';

class ChangeSuccessPasswordController extends GetxController {
  RxBool isLoading = false.obs;

  saveForm() async {
    print('change Pass Controller join');
  }
}
