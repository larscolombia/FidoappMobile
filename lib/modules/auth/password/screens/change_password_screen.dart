import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:pawlly/components/button_default_widget.dart';
import 'package:pawlly/components/custom_text_form_field_widget.dart';
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
                  'Cambiar Contraseña',
                  style: Styles.joinTitle,
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 26,
                ),
                Container(
                  margin: EdgeInsets.only(top: 20, bottom: 20),
                  child: CustomTextFormFieldWidget(
                    controller: controller.passwordController.value,
                    enabled: true,
                    obscureText: true,
                    placeholder: 'Contraseña Actual',
                    icon: 'assets/icons/key.png',
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20, bottom: 20),
                  child: CustomTextFormFieldWidget(
                    controller: controller.newPasswordController.value,
                    enabled: true,
                    obscureText: true,
                    placeholder: 'Contraseña',
                    icon: 'assets/icons/key.png',
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20, bottom: 20),
                  child: CustomTextFormFieldWidget(
                    controller: controller.repeatNewPasswordController.value,
                    enabled: true,
                    obscureText: true,
                    placeholder: 'Confirmar Contraseña',
                    icon: 'assets/icons/key.png',
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: ButtonDefaultWidget(
                    title: 'Enviar',
                    callback: () {
                      // Get.to(Inicio());
                      print('object');
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
