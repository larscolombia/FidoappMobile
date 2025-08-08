import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pawlly/components/app_scaffold.dart';
import 'package:pawlly/components/button_back.dart';
import 'package:pawlly/components/button_default_widget.dart';
import 'package:pawlly/components/custom_text_form_field_widget.dart';
import 'package:pawlly/main.dart';
import 'package:pawlly/modules/auth/password/controllers/change_password_controller.dart';
import 'package:pawlly/modules/auth/sign_up/screens/signup_screen.dart';
import 'package:pawlly/styles/styles.dart';

class ChangeSuccessPassword extends GetView<ChangePasswordController> {
  const ChangeSuccessPassword({super.key});
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;
    return AppScaffold(
      body: SingleChildScrollView(
        padding: Styles.paddingAll,
        child: Container(
          margin: EdgeInsets.only(top: height / 9),
          width: width,
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    child: Column(
                      children: [
                  Text(
                    locale.value.changePassword,
                    style: Styles.joinTitle,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 26,
                  ),
                  Text(
                    locale.value.enterNewPassword,
                    style: Styles.secondTextTitle,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Divider(
                    height: 16,
                    color: Styles.greyDivider,
                    thickness: 1,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Container(
                    child: CustomTextFormFieldWidget(
                        controller: null,
                        placeholder: locale.value.password,
                        icon: 'assets/icons/key.png'),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    child: CustomTextFormFieldWidget(
                        controller: null,
                        placeholder: locale.value.confirmPassword,
                        icon: 'assets/icons/key.png'),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ButtonDefaultWidget(
                    title: locale.value.sendLink,
                    callback: calbak,
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
                                fontFamily: 'Pou',
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
                            Get.to(() => SignUpScreen());
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
                  const ButtonBack(text: 'Regresar')
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void calbak() {}
