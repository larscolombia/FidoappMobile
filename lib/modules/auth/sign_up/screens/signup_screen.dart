import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:pawlly/components/button_default.dart';
import 'package:pawlly/components/app_scaffold.dart';
import 'package:pawlly/components/input_text_custom.dart';
import 'package:pawlly/components/button_back.dart';
import 'package:pawlly/components/select_input_text.dart';
import 'package:pawlly/modules/auth/sign_up/controllers/sign_up_controller.dart';
import 'package:pawlly/routes/app_pages.dart';
import 'package:pawlly/screens_demo/terms_conditions.dart';
import 'package:pawlly/styles/styles.dart';
import 'package:pawlly/utils/colors.dart';

class SignUpScreen extends GetView<SignUpController> {
  SignUpScreen({super.key});
  final GlobalKey<FormState> _signUpformKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return AppScaffold(
      // hideAppBar: true,
      // isLoading: controller.isLoading,
      body: Container(
        padding: Styles.paddingAll,
        child: SizedBox(
          width: width,
          height: height,
          child: Stack(
            fit: StackFit.expand,
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Container(
                  width: width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Registro',
                        style: TextStyle(
                          color: Color.fromRGBO(255, 73, 49, 1),
                          fontSize: 34,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Form(
                        key: _signUpformKey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 20),
                              child: CustomTextFormField(
                                controller: controller.fisrtNameCont,
                                pleholder: 'Nombre',
                                icon: 'assets/icons/profile.png',
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 20),
                              child: CustomTextFormField(
                                controller: controller.lastNameCont,
                                pleholder: 'Apellido',
                                icon: 'assets/icons/profile.png',
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 20),
                              child: CustomTextFormField(
                                controller: controller.emailCont,
                                pleholder: 'Correo Electrónico',
                                icon: 'assets/icons/email.png',
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 20),
                              child: SelecInputText(
                                controller: null,
                                placeholder: 'Género',
                                icon: 'assets/icons/tag-user.png',
                                items: [
                                  'Mujer',
                                  'Hombre',
                                  'Prefiero no decirlo'
                                ],
                                isDropdown: true,
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
                              child: CustomTextFormField(
                                controller: controller.passwordCont,
                                pleholder: 'Confirmar contraseña',
                                icon: 'assets/icons/key.png',
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 20),
                              child: SelecInputText(
                                controller: null,
                                placeholder: 'Tipo de Usuarios',
                                icon: 'assets/icons/tag-user.png',
                                items: ['Entrenador', 'Dueño de Mascota'],
                                isDropdown: true,
                              ),
                            ),
                            Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Obx(
                                      () => Container(
                                        width: width - 50,
                                        alignment: Alignment.center,
                                        padding: EdgeInsets.only(
                                            bottom: 10, top: 10),
                                        child: CheckboxListTile(
                                          checkColor: Colors.amber,
                                          value: controller.isAcceptedTc.value,
                                          activeColor: const Color.fromARGB(
                                              255, 253, 252, 250),
                                          visualDensity: VisualDensity.compact,
                                          dense: true,
                                          controlAffinity:
                                              ListTileControlAffinity.leading,
                                          contentPadding: EdgeInsets.zero,
                                          onChanged: (val) async {
                                            controller.isAcceptedTc.value =
                                                !controller.isAcceptedTc.value;
                                          },
                                          checkboxShape:
                                              const RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(5))),
                                          side: const BorderSide(
                                              color: secondaryTextColor,
                                              width: 1.5),
                                          title: RichTextWidget(
                                            list: [
                                              const TextSpan(
                                                text: 'Acepto los ',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontFamily: "Lato",
                                                    fontWeight: FontWeight.w400,
                                                    color: Color.fromRGBO(
                                                        83, 82, 81, 1)),
                                              ), //TODO: string
                                              TextSpan(
                                                text: 'términos y condiciones',
                                                style: const TextStyle(
                                                  fontFamily: 'Lato',
                                                  fontWeight: FontWeight.w700,
                                                  color: Color.fromRGBO(
                                                      255, 73, 49, 1),
                                                ),
                                                recognizer:
                                                    TapGestureRecognizer()
                                                      ..onTap = () {
                                                        Get.toNamed(Routes
                                                            .TERMSCONDITIONS);
                                                      },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            ButtonDefault(
                                title: "Registrarse",
                                callback: () {
                                  Get.toNamed(Routes.SIGNUP);
                                  /*
                                    if (_signUpformKey.currentState!.validate()) {
                                      _signUpformKey.currentState!.save();
                                      controller.saveForm();
                                    }
                                    */
                                }),
                            SizedBox(
                              height: 20,
                            ),
                            const Divider(
                              height: 16,
                              color: Styles.greyDivider,
                              thickness: 1,
                            ),
                            Container(
                              padding: Styles.paddingT10B10,
                              child: ButtonBack(
                                text: "Iniciar sesión",
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
