import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pawlly/components/button_default_widget.dart';
import 'package:pawlly/components/app_scaffold.dart';
import 'package:pawlly/main.dart';
import 'package:pawlly/modules/privacy_termns/controllers/privacy_terms_controller.dart';
import 'package:pawlly/styles/styles.dart';

class PrivacyTermsScreen extends StatelessWidget {
  final PrivacyTermsController controller = Get.find();

  PrivacyTermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return AppScaffold(
      body: Container(
        padding: Styles.paddingAll,
        width: width,
        height: height,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Obx(() => Text(
                    controller.title.value,
                    style: Styles.joinTitle,
                    textAlign: TextAlign.center,
                  )),
              const SizedBox(height: 20),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Obx(
                    () => Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      child: ButtonDefaultWidget(
                        title: locale.value.privacyPolicy,
                        callback: () => controller.changeTab(0),
                        widthButtom:
                            width - 40, // Ajusta el ancho según sea necesario
                        defaultColor: controller.selectedTab.value == 0
                            ? const Color.fromARGB(255, 252, 146,
                                20) // Color para la pestaña seleccionada
                            : const Color.fromARGB(255, 255, 255,
                                255), // Color para la pestaña no seleccionada
                        border: controller.selectedTab.value == 0
                            ? null
                            : const BorderSide(
                                color: Color.fromARGB(255, 247, 133,
                                    28)), // Borde para la pestaña no seleccionada
                        textColor: controller.selectedTab.value == 0
                            ? Colors.white
                            : Styles
                                .blackColor, // Color del texto para la pestaña no seleccionada
                        textSize: 14,
                      ),
                    ),
                  ),
                  Obx(
                    () => Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      child: ButtonDefaultWidget(
                        title: locale.value.termsAndConditionsTitle,
                        callback: () => controller.changeTab(1),
                        widthButtom:
                            width - 40, // Ajusta el ancho según sea necesario
                        defaultColor: controller.selectedTab.value == 1
                            ? const Color.fromARGB(255, 252, 146, 20)
                            : const Color.fromARGB(255, 255, 255,
                                255) // Color para la pestaña seleccionada
                        , // Color para la pestaña no seleccionada
                        border: controller.selectedTab.value == 1
                            ? null
                            : const BorderSide(
                                color: Color.fromARGB(255, 247, 133,
                                    28)) // Borde para la pestaña seleccionada
                        ,
                        textColor: controller.selectedTab.value == 1
                            ? Colors.white
                            : Styles.blackColor,
                        // Color del texto para la pestaña no seleccionada
                        textSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                child: const Divider(
                  thickness: 0.5,
                  color: Color.fromARGB(255, 182, 164, 137),
                ),
              ),
              Obx(() {
                return Column(
                  children: controller.content.map((data) {
                    return NumTitle(
                      Title: data.title,
                      Descripcion: data.description,
                    );
                  }).toList(),
                );
              }),
              const SizedBox(height: 30),
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                child: ButtonDefaultWidget(
                  title: 'Regresar',
                  callback: () => Get.back(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NumTitle extends StatelessWidget {
  final String Title;
  final String Descripcion;
  const NumTitle({super.key, required this.Title, required this.Descripcion});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Column(children: [
      Container(
        width: width,
        margin: const EdgeInsets.only(top: 20),
        child: Text(
          Title,
          textAlign: TextAlign.start,
          style: const TextStyle(
              fontFamily: 'Lato',
              color: Color.fromRGBO(83, 82, 81, 1),
              fontSize: 14.00,
              fontWeight: FontWeight.w800),
        ),
      ),
      SizedBox(
          width: width,
          child: Text(
            Descripcion,
            textAlign: TextAlign.start,
            style: const TextStyle(
              fontFamily: 'Lato',
              color: Color.fromRGBO(83, 82, 81, 1),
              fontSize: 13.00,
              fontWeight: FontWeight.w500,
            ),
          ))
    ]);
  }
}
