import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:get/get.dart';
import 'package:pawlly/components/button_default_widget.dart';
import 'package:pawlly/components/custom_text_form_field_widget.dart';
import 'package:pawlly/components/button_back.dart';
import 'package:pawlly/main.dart';
import 'package:pawlly/modules/auth/sign_in/controllers/sign_in_controller.dart';
import 'package:pawlly/routes/app_pages.dart';
import 'package:pawlly/styles/styles.dart';

import '../../../../components/app_scaffold.dart';

import '../../../../utils/colors.dart';

class SignInScreen extends StatelessWidget {
  SignInScreen({super.key});
  final SignInController signInController = Get.put(SignInController());
  final GlobalKey<FormState> _signInformKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
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
                            fontWeight: FontWeight.bold,
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
                                icon: 'assets/icons/sms.png',
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 20),
                              child: CustomTextFormFieldWidget(
                                controller: signInController.passwordCont,
                                placeholder:
                                    "Contraseña", //locale.value.password,
                                obscureText: true,
                                icon: 'assets/icons/key.png',
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 20),
                              child: ButtonDefaultWidget(
                                title: locale.value.signIn,
                                callback: () {
                                  // Get.to(Inicio());
                                  print('login');
                                  if (_signInformKey.currentState!.validate()) {
                                    _signInformKey.currentState!.save();
                                    signInController.saveForm();
                                    // print(signInController);
                                    // Get.toNamed(Routes.HOME);
                                  }
                                },
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
                                      color: Color.fromRGBO(83, 82, 81, 1),
                                      fontFamily: 'Lato',
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                              ],
                            ).paddingTop(8),
                          ],
                        ),
                      ).paddingTop(42),
                      Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(left: 10.0),
                            child: const Divider(
                              color: borderColor,
                              indent: .2,
                              thickness: .5,
                            ),
                          ).expand(),
                          const Text('O',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontFamily: 'Lato',
                                fontWeight: FontWeight.w600,
                              )).paddingSymmetric(horizontal: 20),
                          Container(
                            margin: const EdgeInsets.only(right: 10.0),
                            child: const Divider(
                              indent: .2,
                              thickness: .5,
                              color: borderColor,
                            ),
                          ).expand(),
                        ],
                      ),
                      Column(
                        children: [
                          Container(
                            width: 300,
                            height: 54,
                            margin: const EdgeInsets.only(bottom: 20, top: 20),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: const Color.fromRGBO(255, 73, 49, 1)),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: TextButton.icon(
                                onPressed: () {
                                  signInController.googleSignIn(context);
                                },
                                icon: Image.asset('assets/icons/google.png'),
                                label: Text(
                                  locale.value.signInWithGoogle,
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Lato',
                                      fontSize: 14),
                                )),
                          ),
                        ],
                      ),
                      8.height,
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 20.0),
                            child: Text(
                              locale.value.dontHaveAnAccount,
                              style: const TextStyle(
                                fontSize: 14,
                                fontFamily: 'Lato',
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 5.0),
                            child: GestureDetector(
                              onTap: () {
                                Get.toNamed(
                                  Routes.SIGNUP,
                                );
                              },
                              child: Text(
                                locale.value.signUp,
                                style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                    fontFamily: 'Lato',
                                    color: Color.fromRGBO(83, 82, 81, 1)),
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
                            padding: Styles.paddingT10B10,
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
