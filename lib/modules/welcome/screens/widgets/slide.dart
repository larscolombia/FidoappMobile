import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pawlly/generated/config.dart';
import 'package:pawlly/main.dart';
import 'package:pawlly/modules/welcome/controllers/welcome_controller.dart';
import 'package:pawlly/styles/styles.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Slide extends StatelessWidget {
  final WelcomeController welcomeController = Get.put(WelcomeController());

  late final String img1;
  late final String img2;
  late final String img4;
  late final String img5;
  late final String title1;
  late final String title2;
  late final String subtitle;

  Slide({
    super.key,
    String? img1,
    String? img2,
    String? img4,
    String? img5,
    String? title1,
    String? title2,
    String? subtitle,
  })  : img1 = img1 ?? "assets/images/main4.png",
        img2 = img2 ?? "assets/images/main1.png",
        img4 = img4 ?? "assets/images/main2.png",
        img5 = img5 ?? "assets/images/welcome.png",
        title1 = title1 ?? locale.value.welcomeTo,
        title2 = title2 ?? Config.NameApp,
        subtitle = subtitle ?? locale.value.designedToAccompany;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    return SingleChildScrollView(
      child: Column(
        children: [
          // Stack de imágenes
          Center(
            child: SizedBox(
              height: 263,
              width: 210,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.asset(
                      img1,
                      fit: BoxFit.contain,
                    ),
                  ),
                  Positioned.fill(
                    child: Image.asset(
                      img2,
                      fit: BoxFit.contain,
                    ),
                  ),
                  Positioned.fill(
                    child: Image.asset(
                      img4,
                      fit: BoxFit.contain,
                    ),
                  ),
                  Positioned.fill(
                    child: Image.asset(
                      img5,
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Indicador de página
          Container(
            margin: const EdgeInsets.symmetric(vertical: 20),
            child: Obx(() => AnimatedSmoothIndicator(
                  activeIndex: welcomeController.currentIndex.value,
                  count: 3,
                  effect: const ExpandingDotsEffect(
                    activeDotColor: Styles.primaryColor,
                    dotColor: Color.fromARGB(255, 238, 129, 96),
                    dotHeight: 8,
                    dotWidth: 8,
                    spacing: 8,
                  ),
                  onDotClicked: welcomeController.onDotClicked,
                )),
          ),

          // Títulos
          Text(
            title1,
            style: Styles.welcomeTitle,
            textAlign: TextAlign.center,
          ),
          Text(
            title2,
            style: Styles.welcomeTitle,
            textAlign: TextAlign.center,
          ),

          // Subtítulo
          Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.only(top: 10),
            padding: const EdgeInsets.symmetric(
                horizontal: 20), // Ajuste para pantallas pequeñas
            child: Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xff383838),
                fontFamily: 'Lato',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
