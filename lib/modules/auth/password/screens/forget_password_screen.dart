import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pawlly/components/button_default_widget.dart';
import 'package:pawlly/components/custom_text_form_field_widget.dart';
import 'package:pawlly/components/button_back.dart';
import 'package:pawlly/main.dart';
import 'package:pawlly/modules/auth/sign_in/screens/signin_screen.dart';
import 'package:pawlly/modules/auth/password/screens/change_success_password.dart';
import 'package:pawlly/routes/app_pages.dart';
import 'package:pawlly/styles/styles.dart';

import '../../../../../components/app_scaffold.dart';
import '../../../../../components/loader_widget.dart';
import '../../../../../generated/assets.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../controllers/forget_password_controller.dart';

class ForgetPasswordScreen extends GetView<ForgetPasswordController> {
  ForgetPasswordScreen({super.key});
  final GlobalKey<FormState> _forgotPassFormKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return AppScaffold(
      isCenterTitle: true,
      appBartitleText: locale.value.resetPassword,
      body: Container(
        alignment: Alignment.center,
        padding: Styles.paddingAll,
        margin: EdgeInsets.only(top: height / 9),
        width: width,
        height: height,
        child: Stack(
          alignment: Alignment.center,
          fit: StackFit.expand,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Form(
                  key: _forgotPassFormKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Container(
                    padding: EdgeInsets.zero,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          locale.value.passwordRecovery,
                          style: Styles.joinTitle,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(
                          height: 26,
                        ),
                        SizedBox(
                          width: width * 0.8,
                          child: Text(
                            locale.value.enterEmailYouRegistered,
                            style: Styles.secondTextTitle,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        32.height,
                        const Divider(
                          height: 16,
                          color: Styles.greyDivider,
                          thickness: 1,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          child: CustomTextFormFieldWidget(
                              controller: controller.emailCont,
                              placeholder: locale.value.email,
                              icon: 'assets/icons/email.png'),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ButtonDefaultWidget(
                          title: locale.value.sendLink,
                          callback: () {
                            if (_forgotPassFormKey.currentState!.validate()) {
                              _forgotPassFormKey.currentState!.save();
                              controller.saveForm();
                            }
                            // Get.toNamed(Routes.CHANGESUCCESSPASSWORD);
                            /* Get.to(() => OtpScreen()); */
                          },
                          showDecoration: true,
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${locale.value.returnTo} ',
                                style: const TextStyle(
                                    fontSize: 14,
                                    color: Color.fromRGBO(83, 82, 81, 1),
                                    fontFamily: 'Lato',
                                    fontWeight: FontWeight.w400),
                              ),
                              TextButton(
                                onPressed: () {
                                  Get.back();
                                },
                                child: Text(
                                  locale.value.signIn,
                                  style: const TextStyle(
                                      fontSize: 14,
                                      color: Color.fromRGBO(83, 82, 81, 1),
                                      fontFamily: 'Lato',
                                      fontWeight: FontWeight.w800),
                                ),
                              ),
                              Container(
                                width: 1, // Grosor de la línea
                                height: 10, // Altura de la línea
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 6), // Espacio en los lados
                                color: Styles.greyColor, // Color de la línea
                              ),
                              TextButton(
                                onPressed: () {
                                  Get.toNamed(Routes.SIGNUP);
                                },
                                child: Text(
                                  locale.value.signUp,
                                  style: const TextStyle(
                                      fontSize: 14,
                                      color: Color.fromRGBO(83, 82, 81, 1),
                                      fontFamily: 'Lato',
                                      fontWeight: FontWeight.w800),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(
                          height: 16,
                          color: Styles.greyDivider,
                          thickness: 1,
                        ),
                        Container(
                          padding: Styles.paddingT10B10,
                          child: const ButtonBack(text: 'Regresar'),
                        ),
                      ],
                    ),
                  )),
            ),
            Obx(() => const LoaderWidget()
                .center()
                .visible(controller.isLoading.value)),
          ],
        ),
      ),
    );
  }
}
