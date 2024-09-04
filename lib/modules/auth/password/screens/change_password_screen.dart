import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:pawlly/components/button_default_widget.dart';
import 'package:pawlly/components/custom_text_form_field_widget.dart';
import 'package:pawlly/main.dart';
import 'package:pawlly/styles/styles.dart';
import 'package:pawlly/utils/common_base.dart';
import '../../../../../components/app_scaffold.dart';
import '../controllers/change_password_controller.dart';

class ChangePasswordScreen extends StatelessWidget {
  ChangePasswordScreen({super.key});
  final GlobalKey<FormState> _changePassformKey = GlobalKey();
  final ChangePasswordController controller =
      Get.put(ChangePasswordController());

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
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Form(
            key: _changePassformKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  locale.value.changePassword,
                  style: Styles.joinTitle,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 26),

                // Campo de contraseña actual
                Container(
                  margin: EdgeInsets.only(top: 20, bottom: 20),
                  child: CustomTextFormFieldWidget(
                    controller: controller.oldPasswordCont,
                    enabled: true,
                    obscureText: true,
                    placeholder: locale.value.currentPassword,
                    icon: 'assets/icons/key.png',
                    validators: [
                      (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ingrea tu contraseña';
                          // return locale.value.enterYourCurrentPassword;
                        }
                        return null;
                      }
                    ],
                  ),
                ),

                // Campo de nueva contraseña
                Container(
                  margin: EdgeInsets.only(top: 20, bottom: 20),
                  child: CustomTextFormFieldWidget(
                    controller: controller.newpasswordCont,
                    enabled: true,
                    obscureText: true,
                    placeholder: locale.value.password,
                    icon: 'assets/icons/key.png',
                    validators: [
                      (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ingrea tu nueva contraseña';
                          // return locale.value.enterYourNewPassword;
                        } else if (value.length < 6) {
                          return 'Muy pocos caracteres';
                          // return locale.value.passwordTooShort;
                        }
                        return null;
                      }
                    ],
                  ),
                ),

                // Campo de confirmación de nueva contraseña
                Container(
                  margin: EdgeInsets.only(top: 20, bottom: 20),
                  child: CustomTextFormFieldWidget(
                    controller: controller.confirmPasswordCont,
                    enabled: true,
                    obscureText: true,
                    placeholder: locale.value.confirmPassword,
                    icon: 'assets/icons/key.png',
                    validators: [
                      (value) {
                        if (value == null || value.isEmpty) {
                          return locale.value.confirmPassword;
                        } else if (value !=
                            controller.newpasswordCont.value.text) {
                          return 'Las contraseñas no cinciden';
                          //return locale.value.passwordsDoNotMatch;
                        }
                        return null;
                      }
                    ],
                  ),
                ),

                // Botón para enviar y validar
                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: Obx(() => ButtonDefaultWidget(
                        title: locale.value.send,
                        isLoading: controller
                            .isLoading.value, // Mostrar loader si está cargando
                        callback: () {
                          if (_changePassformKey.currentState!.validate()) {
                            controller
                                .saveForm(); // Llamar al método para cambiar la contraseña
                          } else {
                            toast('por favor checa los campos');
                            // toast(locale.value.pleaseFillAllFields);
                          }
                        },
                      )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
