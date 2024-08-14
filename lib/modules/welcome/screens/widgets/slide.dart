import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pawlly/generated/config.dart';
import 'package:pawlly/main.dart';
import 'package:pawlly/modules/welcome/controllers/welcome_controller.dart';
import 'package:pawlly/styles/styles.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Slide extends StatelessWidget {
  final WelcomeController welcomeController = Get.put(WelcomeController());

  late String img1;
  late String img2;
  late String img4;
  late String img5;
  late String title1;
  late String title2;
  late String subtitle;

  Slide({
    Key? key,
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
        subtitle = subtitle ?? locale.value.designedToAccompany,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Container(
        width: width,
        child: Column(
          children: [
            Center(
              child: Stack(children: [
                Positioned(
                  height: 263,
                  width: 210,
                  child: Image.asset(img1),
                ),
                Container(
                  height: 263,
                  width: 210,
                  child: Image.asset(img2),
                ),
                Container(
                  height: 263,
                  width: 210,
                  child: Image.asset(img4),
                ),
                Positioned(
                  height: 263,
                  width: 210,
                  child: Image.asset(img5),
                ),
              ]),
            ),
            Container(
              margin: EdgeInsets.only(top: 20, bottom: 20),
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
            Text(
              title1,
              style: Styles.welcomeTitle,
            ),
            Text(
              title2,
              style: Styles.welcomeTitle,
            ),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(top: 10),
              child: Center(
                child: Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.lato(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Styles.greyTextColor,
                  ),
                ),
              ),
            )
          ],
        ));
  }
}
