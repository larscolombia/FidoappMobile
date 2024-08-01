import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pawlly/components/button_default_widget.dart';
import 'package:pawlly/components/app_scaffold.dart';
import 'package:pawlly/components/custom_text_form_field_widget.dart';
import 'package:pawlly/components/button_back.dart';
import 'package:pawlly/components/titulo.dart';
import 'package:pawlly/modules/auth/password/controllers/change_password_controller.dart';
import 'package:pawlly/modules/auth/sign_up/screens/signup_screen.dart';
import 'package:pawlly/styles/styles.dart';

class ChangeSuccessPassword extends GetView<ChangePasswordController> {
  const ChangeSuccessPassword({super.key});
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return AppScaffold(
        body: Container(
      padding: Styles.paddingAll,
      margin: EdgeInsets.only(top: height / 9),
      width: width,
      height: height,
      child: Column(children: [
        Stack(
          children: [
            Container(
              child: Column(
                children: [
                  Text(
                    'Cambiar Contraseña',
                    style: Styles.joinTitle,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 26,
                  ),
                  Text(
                    'Ingresa tu nueva contraseña',
                    style: Styles.secondTextTitle,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  const Divider(
                    height: 16,
                    color: Styles.greyDivider,
                    thickness: 1,
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Container(
                    child: CustomTextFormFieldWidget(
                        controller: null,
                        placeholder: 'Contraseña',
                        icon: 'assets/icons/key.png'),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    child: CustomTextFormFieldWidget(
                        controller: null,
                        placeholder: 'Confirmar Contraseña',
                        icon: 'assets/icons/key.png'),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ButtonDefaultWidget(
                    title: 'Enviar enlace',
                    callback: calbak,
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Volver a ",
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
                          child: const Text(
                            "Inicio Sesión",
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
                            Get.to(() => SignUpScreen());
                          },
                          child: const Text(
                            "Registro",
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
                  ButtonBack(text: 'Regresar')
                ],
              ),
            ),
          ],
        ),
      ]),
    ));
  }
}

void calbak() {}
