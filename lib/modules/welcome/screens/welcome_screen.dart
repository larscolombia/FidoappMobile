import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pawlly/components/app_scaffold.dart';
import 'package:pawlly/components/button_default_widget.dart';
import 'package:pawlly/main.dart';
import 'package:pawlly/modules/welcome/controllers/welcome_controller.dart';
import 'package:pawlly/modules/welcome/screens/widgets/slide.dart';
import 'package:pawlly/styles/styles.dart';

class WelcomeScreen extends GetView<WelcomeController> {
  WelcomeScreen({super.key});
  // late WelcomeController _con;

  final int _current = 0;

  final List<Widget> _slides = [
    Slide(),
    Slide(
      img4: "assets/images/arco2.png",
      img5: "assets/images/welcome2.png",
      title1: locale.value.yourPetLifeRegister,
      title2: locale.value.forYourPet,
      subtitle: locale.value.registerAllPetInfo,
    ),
    Slide(
      img4: "assets/images/arco3.png",
      img5: "assets/images/welcome3.png",
      title1: locale.value.findUse,
      title2: locale.value.usefulInformation,
      subtitle: locale.value.findInformationForYourPet,
    ),
  ];

  final RxBool _isNavigating = false.obs;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;
    return AppScaffold(
      hideAppBar: true,
      body: Container(
        margin: const EdgeInsets.only(top: 50),
        padding: Styles.paddingAll,
        height: height,
        width: width,
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        Container(
                          child: CarouselSlider(
                            carouselController: controller.carouselController,
                            options: CarouselOptions(
                              height: height - 300,
                              enlargeCenterPage: true,
                              autoPlay: true,
                              viewportFraction: 1,
                              onPageChanged: controller.onPageChanged,
                            ),
                            items: _slides.map((widget) {
                              return Builder(
                                builder: (BuildContext context) {
                                  return Container(
                                    width: width - 20,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 5.0),
                                    child: widget,
                                  );
                                },
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Obx(
                          () => ButtonDefaultWidget(
                            title: "Inicia Sesión",
                            isLoading: _isNavigating.value,
                            callback: () async {
                              if (_isNavigating.value) return;
                              _isNavigating.value = true;
                              await Get.toNamed('signin');
                              _isNavigating.value = false;
                            },
                            showDecoration: true,
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        ButtonDefaultWidget(
                          title: 'Regístrate',
                          defaultColor:
                              const Color.fromARGB(255, 255, 255, 255),
                          border: const BorderSide(
                            color: Styles.primaryColor,
                          ),
                          textColor: Styles.blackColor,
                          callback: () {
                            Get.toNamed(
                              '/signup',
                            );
                          },
                          showDecoration: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
