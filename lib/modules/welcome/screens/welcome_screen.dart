import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import 'package:get/get.dart';
import 'package:pawlly/components/button_default_widget.dart';
import 'package:pawlly/components/app_scaffold.dart';
import 'package:pawlly/main.dart';
import 'package:pawlly/modules/auth/sign_in/screens/signin_screen.dart';
import 'package:pawlly/modules/auth/sign_up/screens/signup_screen.dart';
import 'package:pawlly/modules/welcome/controllers/welcome_controller.dart';
import 'package:pawlly/modules/welcome/screens/widgets/slide.dart';
import 'package:pawlly/routes/app_pages.dart';
import 'package:pawlly/styles/styles.dart';

class WelcomeScreen extends GetView<WelcomeController> {
  WelcomeScreen({super.key});
  // late WelcomeController _con;

  int _current = 0;

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

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return AppScaffold(
      hideAppBar: true,
      body: Container(
        margin: EdgeInsets.only(top: 50),
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
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 5.0),
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
                        ButtonDefaultWidget(
                            title: locale.value.signIn,
                            callback: () {
                              Get.toNamed(
                                'signin',
                              );
                            }),
                        SizedBox(
                          height: 16,
                        ),
                        ButtonDefaultWidget(
                            title: locale.value.signUp,
                            defaultColor: Color.fromARGB(255, 255, 255, 255),
                            border: BorderSide(
                              color: Styles.primaryColor,
                            ),
                            textColor: Styles.blackColor,
                            callback: () {
                              Get.toNamed(
                                '/signup',
                              );
                            }),
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
