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
                          style: const TextStyle(
                            fontFamily: 'PoetsenOne',
                            fontSize: 32,
                            fontWeight: FontWeight.w400,
                            height: 1.2,
                            color: Color(0xFFFF4931),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(
                          height: 22,
                        ),
                        SizedBox(
                          width: width * 0.8,
                          child: Text(
                            locale.value.enterEmailYouRegistered,
                            style: Styles.secondTextTitle,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Divider(
                          height: 16,
                          color: Color(0XFFDFDFDF),
                          thickness: 1,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          child: CustomTextFormFieldWidget(
                            controller: controller.emailCont,
                            placeholder: locale.value.email,
                            placeholderSvg: 'assets/icons/svg/sms.svg',
                            colorSVG: Color(0xFFFCBA67),
                          ),
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
                                locale.value
                                    .returnTo, // Eliminado el espacio extra
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF383838),
                                  fontFamily: 'Lato',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              TextButton(
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.symmetric(horizontal: 5),

                                  tapTargetSize: MaterialTapTargetSize
                                      .shrinkWrap, // Reduce el área táctil
                                ),
                                onPressed: () {
                                  Get.back();
                                },
                                child: Text(
                                  locale.value.signIn,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF383838),
                                    fontFamily: 'Lato',
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 2,
                              ),
                              Container(
                                width: 2, // Grosor de la línea
                                height: 14, // Altura de la línea
                                color: Color(0xFFDFDFDF), // Color de la línea
                              ),
                              TextButton(
                                onPressed: () {
                                  Get.toNamed(Routes.SIGNUP);
                                },
                                child: Text(
                                  'Registrate',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF383838),
                                    fontFamily: 'Lato',
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(
                          height: 18,
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
