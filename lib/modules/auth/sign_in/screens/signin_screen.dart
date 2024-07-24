import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:get/get.dart';
import 'package:pawlly/components/button_default.dart';
import 'package:pawlly/components/input_text_custom.dart';
import 'package:pawlly/components/button_back.dart';
import 'package:pawlly/modules/auth/sign_in/controllers/sign_in_controller.dart';
import 'package:pawlly/routes/app_pages.dart';
import 'package:pawlly/styles/styles.dart';

import '../../../../components/app_scaffold.dart';

import '../../../../utils/colors.dart';

class SignInScreen extends GetView<SignInController> {
  SignInScreen({super.key});
  final GlobalKey<FormState> _signInformKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return AppScaffold(
      hideAppBar: true,
      isLoading: controller.isLoading,
      body: Container(
        padding: Styles.paddingAll,
        width: width,
        height: height,
        child: Stack(
          fit: StackFit.expand,
          children: [
            SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Container(
                  width: 300,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Iniciar Sesión',
                        style: TextStyle(
                            color: Color.fromRGBO(255, 73, 49, 1),
                            fontSize: 34,
                            fontWeight: FontWeight.w800,
                            fontFamily: "elvetica"),
                      ).paddingTop(80),
                      Form(
                        key: _signInformKey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              child: CustomTextFormField(
                                controller: controller.emailCont,
                                pleholder: 'Email',
                                icon: 'assets/icons/email.png',
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 20),
                              child: CustomTextFormField(
                                controller: controller.passwordCont,
                                pleholder: 'Contraseña',
                                icon: 'assets/icons/key.png',
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 20),
                              child: ButtonDefault(
                                title: 'Iniciar Sessión',
                                callback: () {
                                  // Get.to(Inicio());
                                  print('object');
                                  if (_signInformKey.currentState!.validate()) {
                                    _signInformKey.currentState!.save();
                                    controller.saveForm();
                                    print(controller);
                                    Get.toNamed(Routes.HOME);
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
                                  child: const Text(
                                    "Reestablecer contraseña",
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
                          Text('O',
                                  style: primaryTextStyle(
                                      color: secondaryTextColor, size: 14))
                              .paddingSymmetric(horizontal: 20),
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
                            margin: EdgeInsets.only(bottom: 20, top: 20),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Color.fromRGBO(255, 73, 49, 1)),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: TextButton.icon(
                                onPressed: () {
                                  print('google');
                                },
                                icon: const Icon(
                                  Icons.person,
                                  color: Color.fromARGB(255, 146, 160, 172),
                                ),
                                label: const Text(
                                  'Iniciar con Google',
                                  style: TextStyle(color: Colors.black),
                                )),
                          ),
                          Container(
                            width: 300,
                            height: 54,
                            margin: EdgeInsets.only(bottom: 20),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Color.fromRGBO(255, 73, 49, 1)),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: TextButton.icon(
                                onPressed: () {
                                  print('apple');
                                },
                                icon: const Icon(
                                  Icons.apple,
                                  color: Color.fromARGB(255, 146, 160, 172),
                                ),
                                label: const Text(
                                  'Iniciar con Apple',
                                  style: TextStyle(color: Colors.black),
                                )),
                          ),
                          Container(
                            width: 300,
                            height: 54,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Color.fromRGBO(255, 73, 49, 1)),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: TextButton.icon(
                                onPressed: () {
                                  print('Google');
                                },
                                icon: const Icon(
                                  Icons.facebook,
                                  color: Colors.blue,
                                ),
                                label: const Text(
                                  'Iniciar con facebook',
                                  style: TextStyle(color: Colors.black),
                                )),
                          )
                        ],
                      ),
                      8.height,
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 20.0),
                            child: const Text(
                              '¿No tienes una cuenta aún? ',
                              style: TextStyle(
                                fontSize: 14,
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
                              child: const Text(
                                'Regístrate',
                                style: TextStyle(
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
                              text: "Inicio",
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
