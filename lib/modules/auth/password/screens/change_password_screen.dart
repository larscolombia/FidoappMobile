import 'package:get/get.dart';

import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:pawlly/main.dart';
import 'package:pawlly/styles/styles.dart';
import 'package:pawlly/utils/common_base.dart';

import '../../../../../components/app_scaffold.dart';
import '../../../../../generated/assets.dart';
import '../controllers/change_password_controller.dart';

import '../../../../../utils/colors.dart';

class ChangePasswordScreen extends GetView<ChangePasswordController> {
  ChangePasswordScreen({super.key});
  final GlobalKey<FormState> _changePassformKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      isCenterTitle: true,
      appBartitleText: 'Cambiar Contraseña',
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _changePassformKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              32.height,
              SizedBox(
                width: Get.width * 0.8,
                child: Text(
                  locale.value.yourNewPasswordMust,
                  style: Styles.secondTextTitle,
                  textAlign: TextAlign.center,
                ),
              ),
              64.height,
              AppTextField(
                title: locale.value.oldPassword,
                textStyle: primaryTextStyle(size: 12),
                controller: controller.oldPasswordCont, // Optional
                textFieldType: TextFieldType.PASSWORD,
                decoration: inputDecoration(context,
                    fillColor: context.cardColor,
                    filled: true,
                    hintText: "${locale.value.eG} #123@156"),
                suffixPasswordVisibleWidget: const Icon(
                    Icons.remove_red_eye_outlined,
                    color: borderColor),
                suffixPasswordInvisibleWidget: commonLeadingWid(
                        imgPath: Assets.iconsIcEyeSlash,
                        icon: Icons.password_outlined,
                        color: borderColor)
                    .paddingAll(12),
              ),
              16.height,
              AppTextField(
                title: locale.value.newPassword,
                textStyle: primaryTextStyle(size: 12),
                controller: controller.newpasswordCont, // Optional
                textFieldType: TextFieldType.PASSWORD,
                decoration: inputDecoration(context,
                    fillColor: context.cardColor,
                    filled: true,
                    hintText: "${locale.value.eG}  #123@156"),
                suffixPasswordVisibleWidget: const Icon(
                    Icons.remove_red_eye_outlined,
                    color: borderColor),
                suffixPasswordInvisibleWidget: commonLeadingWid(
                        imgPath: Assets.iconsIcEyeSlash,
                        icon: Icons.password_outlined,
                        color: borderColor)
                    .paddingAll(12),
              ),
              16.height,
              AppTextField(
                title: locale.value.confirmNewPassword,
                textStyle: primaryTextStyle(size: 12),
                controller: controller.confirmPasswordCont, // Optional
                textFieldType: TextFieldType.PASSWORD,
                decoration: inputDecoration(context,
                    fillColor: context.cardColor,
                    filled: true,
                    hintText: "${locale.value.eG}  #123@156"),
                suffixPasswordVisibleWidget: const Icon(
                    Icons.remove_red_eye_outlined,
                    color: borderColor),
                suffixPasswordInvisibleWidget: commonLeadingWid(
                        imgPath: Assets.iconsIcEyeSlash,
                        icon: Icons.password_outlined,
                        color: borderColor)
                    .paddingAll(12),
              ),
              64.height,
              AppButton(
                width: Get.width,
                text: locale.value.submit,
                textStyle: appButtonTextStyleWhite,
                onTap: () async {
                  ifNotTester(() async {
                    if (await isNetworkAvailable()) {
                      if (_changePassformKey.currentState!.validate()) {
                        _changePassformKey.currentState!.save();
                        controller.saveForm();
                      }
                    } else {
                      toast(locale.value.yourInternetIsNotWorking);
                    }
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
