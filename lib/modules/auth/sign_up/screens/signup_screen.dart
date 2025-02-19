import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:pawlly/components/button_default_widget.dart';
import 'package:pawlly/components/app_scaffold.dart';
import 'package:pawlly/components/custom_text_form_field_widget.dart';
import 'package:pawlly/components/button_back.dart';
import 'package:pawlly/components/custom_select_form_field_widget.dart';
import 'package:pawlly/main.dart';
import 'package:pawlly/modules/auth/sign_up/controllers/sign_up_controller.dart';
import 'package:pawlly/routes/app_pages.dart';
import 'package:pawlly/styles/styles.dart';
import 'package:pawlly/utils/colors.dart';

class SignUpScreen extends GetView<SignUpController> {
  SignUpScreen({super.key});
  final GlobalKey<FormState> _signUpformKey = GlobalKey();
  final RxBool _autoValidate =
      false.obs; // Observador para activar auto validación

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return AppScaffold(
      automaticallyImplyLeading: false,
      hideAppBar: true,
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
                child: SizedBox(
                  width: width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 100),
                      Text(
                        locale.value.register,
                        style: const TextStyle(
                          color: Color.fromRGBO(255, 73, 49, 1),
                          fontSize: 34,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Form(
                        key: _signUpformKey,
                        autovalidateMode: _autoValidate.value
                            ? AutovalidateMode.onUserInteraction
                            : AutovalidateMode
                                .disabled, // Modo de auto validación
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Campo de nombre
                            Container(
                              margin: const EdgeInsets.only(top: 20),
                              child: CustomTextFormFieldWidget(
                                controller: controller.fisrtNameCont,
                                placeholder: locale.value.firstName,
                                icon: 'assets/icons/profile.png',
                                validators: [
                                  (value) => (value?.isEmpty ?? true)
                                      ? 'El nombre es requerido'
                                      : null,
                                ],
                              ),
                            ),
                            // Campo de apellido
                            Container(
                              margin: const EdgeInsets.only(top: 16),
                              child: CustomTextFormFieldWidget(
                                controller: controller.lastNameCont,
                                placeholder: locale.value.lastName,
                                icon: 'assets/icons/profile.png',
                                validators: [
                                  (value) => (value?.isEmpty ?? true)
                                      ? 'El apellido es requerido'
                                      : null,
                                ],
                              ),
                            ),
                            // Campo de correo electrónico
                            Container(
                              margin: const EdgeInsets.only(top: 16),
                              child: CustomTextFormFieldWidget(
                                controller: controller.emailCont,
                                placeholder: locale.value.email,
                                placeholderSvg: 'assets/icons/svg/sms.svg',
                                validators: [
                                  (value) => (value?.isEmpty ?? true)
                                      ? 'El correo es requerido'
                                      : null,
                                  (value) => !value!.contains('@')
                                      ? 'Ingrese un correo válido'
                                      : null,
                                ],
                              ),
                            ),
                            // Campo de género
                            Container(
                              height: 54,
                              margin: const EdgeInsets.only(top: 16),
                              child: CustomSelectFormFieldWidget(
                                controller: controller.genCont,
                                placeholder: locale.value.gender,
                                placeholderSvg: 'assets/icons/svg/tag-user.svg',
                                filcolorCustom: Styles.fiveColor,
                                items: const [
                                  'Mujer',
                                  'Hombre',
                                  'Prefiero no decirlo'
                                ],
                                validators: [
                                  (value) => (value?.isEmpty ?? true)
                                      ? 'Seleccione su género'
                                      : null,
                                ],
                              ),
                            ),
                            // Campo de contraseña
                            Container(
                              margin: const EdgeInsets.only(top: 16),
                              child: CustomTextFormFieldWidget(
                                controller: controller.passwordCont,
                                placeholder: locale.value.password,
                                obscureText: true,
                                placeholderSvg: 'assets/icons/svg/key.svg',
                                validators: [
                                  (value) => (value?.isEmpty ?? true)
                                      ? 'La contraseña es requerida'
                                      : null,
                                  (value) => value!.length < 8 ||
                                          value.length > 15
                                      ? 'La contraseña debe tener entre 8 y 15 caracteres'
                                      : null,
                                ],
                              ),
                            ),
                            // Campo de confirmar contraseña
                            Container(
                              margin: const EdgeInsets.only(top: 16),
                              child: CustomTextFormFieldWidget(
                                controller: controller.password2Cont,
                                placeholder: locale.value.confirmPassword,
                                obscureText: true,
                                placeholderSvg: 'assets/icons/svg/key.svg',
                                validators: [
                                  (value) =>
                                      (value != controller.passwordCont.text)
                                          ? 'Las contraseñas no coinciden'
                                          : null,
                                ],
                              ),
                            ),
                            // Campo de tipo de usuario
                            Container(
                              margin: const EdgeInsets.only(top: 16),
                              child: CustomSelectFormFieldWidget(
                                controller: controller.userTypeCont,
                                placeholder: locale.value.userType,
                                filcolorCustom: Styles.fiveColor,
                                placeholderSvg: 'assets/icons/svg/tag-user.svg',
                                items: const [
                                  'Entrenador',
                                  'Veterinario',
                                  'Dueño de Mascota'
                                ],
                                validators: [
                                  (value) => (value?.isEmpty ?? true)
                                      ? 'Seleccione su género'
                                      : null,
                                ],
                              ),
                            ),
                            // Aceptar términos y condiciones
                            Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Obx(
                                      () => Container(
                                        width: 305,
                                        alignment: Alignment.center,
                                        padding: const EdgeInsets.only(
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
                                              TextSpan(
                                                text:
                                                    '${locale.value.iAcceptThe} ',
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    fontFamily: "Lato",
                                                    fontWeight: FontWeight.w400,
                                                    color: Color.fromRGBO(
                                                        83, 82, 81, 1)),
                                              ),
                                              TextSpan(
                                                text: locale
                                                    .value.termsAndConditions,
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
                                                            .PRIVACYTERMS);
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
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Botón de registro
                      Obx(() {
                        if (controller.isLoading.value) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        return Center(
                          child: ButtonDefaultWidget(
                            callback: () {
                              _autoValidate.value = true;

                              if (_signUpformKey.currentState!.validate()) {
                                _signUpformKey.currentState!.save();
                                controller.saveForm();
                              }
                            },
                            title: locale.value.signUp,
                            showDecoration: true,
                          ),
                        );
                      }),

                      const SizedBox(
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
                          text: locale.value.signIn,
                        ),
                      ),
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
