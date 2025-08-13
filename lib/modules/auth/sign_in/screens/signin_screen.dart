import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:pawlly/components/button_back.dart';
import 'package:pawlly/components/button_default_widget.dart';
import 'package:pawlly/components/custom_text_form_field_widget.dart';
import 'package:pawlly/components/safe_elevated_button.dart';
import 'package:pawlly/generated/assets.dart';
import 'package:pawlly/main.dart';
import 'package:pawlly/modules/auth/sign_in/controllers/sign_in_controller.dart';
import 'package:pawlly/routes/app_pages.dart';
import 'package:pawlly/styles/recursos.dart';
import 'package:pawlly/styles/styles.dart';

import '../../../../components/app_scaffold.dart';

class SignInScreen extends StatelessWidget {
  SignInScreen({super.key});
  final SignInController signInController = Get.put(SignInController());
  final GlobalKey<FormState> _signInformKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;
    return AppScaffold(
      hideAppBar: true,
      isLoading: signInController.isLoading,
      body: Container(
        padding: Styles.paddingAll,
        width: width,
        height: height,
        child: Stack(
          fit: StackFit.expand,
          children: [
            SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SizedBox(
                  width: 300,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        locale.value.signIn,
                        style: const TextStyle(
                            color: Color.fromRGBO(255, 73, 49, 1),
                            fontSize: 32,
                            fontWeight: FontWeight.w400,
                            fontFamily: "PoetsenOne"),
                      ).paddingTop(80),
                      Form(
                        key: _signInformKey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              child: CustomTextFormFieldWidget(
                                controller: signInController.emailCont,
                                placeholder:
                                    "Correo Electrónico", //locale.value.email,
                                placeholderSvg: 'assets/icons/svg/sms.svg',
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 16),
                              child: CustomTextFormFieldWidget(
                                controller: signInController.passwordCont,
                                placeholder:
                                    "Contraseña", //locale.value.password,
                                obscureText: true,
                                placeholderSvg: 'assets/icons/svg/key.svg',
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 16),
                              child: ButtonDefaultWidget(
                                title: 'Inicia Sesión',
                                callbackAsync: () async {
                                  // Get.to(Inicio());
                                  print('login');
                                  if (_signInformKey.currentState!.validate()) {
                                    _signInformKey.currentState!.save();
                                    await signInController.saveForm();
                                    // print(signInController);
                                    // Get.toNamed(Routes.HOME);
                                  }
                                },
                                showDecoration: true,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    Get.toNamed(
                                      Routes.FORGETPASSWORD,
                                    );
                                  },
                                  child: Text(
                                    locale.value.resetPassword,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Color(0xff535251),
                                      fontFamily: Recursos.fuente1,
                                      fontWeight: FontWeight.w900,
                                      height: 18 /
                                          14, // Ajusta el lineHeight a 18px manteniendo el fontSize en 14px
                                    ),
                                  ),
                                ),
                              ],
                            ).paddingTop(16),
                          ],
                        ),
                      ).paddingTop(42),
                    // Google Sign-In (Android only)
                    if (Platform.isAndroid) ...[
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: SafeElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            side: const BorderSide(color: Styles.greyDivider),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                          ),
                          onPressedAsync: () async => await signInController.googleSignIn(context),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                Assets.imagesGoogleLogo,
                                width: 24,
                                height: 24,
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Continuar con Google',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 10.0),
                            child: Text(
                              locale.value.dontHaveAnAccount,
                              style: const TextStyle(
                                fontSize: 14,
                                fontFamily: 'Lato',
                                fontWeight: FontWeight.w500,
                                height: 18 /
                                    14, // Ajusta el lineHeight a 18px manteniendo el fontSize en 14px
                                color: Color(0xff383838),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Container(
                            margin:
                                const EdgeInsets.only(top: 4.0, bottom: 15.0),
                            child: GestureDetector(
                              onTap: () {
                                Get.toNamed(
                                  Routes.SIGNUP,
                                );
                              },
                              child: const Text(
                                'Regístrate',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                  fontFamily: Recursos.fuente1,
                                  color: Color(0xff383838),
                                  height: 18 /
                                      14, // Ajusta el lineHeight a 18px manteniendo el fontSize en 14px
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          const Divider(
                            height: 16,
                            color: Styles.greyDivider,
                            thickness: 1,
                          ),
                          Container(
                            padding: const EdgeInsets.only(right: 10),
                            child: ButtonBack(
                              text: locale.value.home,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
