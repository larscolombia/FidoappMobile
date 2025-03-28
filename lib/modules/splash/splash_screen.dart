import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pawlly/components/app_logo_widget.dart';
import 'package:pawlly/modules/home/screens/home_screen.dart';
import 'package:pawlly/modules/welcome/screens/welcome_screen.dart';
import 'package:pawlly/services/auth_service_apis.dart';
import 'package:pawlly/utils/app_common.dart';
import '../../components/app_scaffold.dart';
import '../../generated/assets.dart';
import '../home/controllers/home_controller.dart';
import 'splash_controller.dart';
import '../../utils/constants.dart';

class SplashScreen extends StatelessWidget {
  final SplashScreenController splashController =
      Get.put(SplashScreenController());
  SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: AuthServiceApis.loadLoginData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return buildSplashScreen();
        } else {
          if (snapshot.data == true &&
              AuthServiceApis.currentUser.value != null) {
            // Usar GetX para la navegación
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Get.offAll(() => HomeScreen(), binding: BindingsBuilder(() {
                Get.put(HomeController());
              }));
            });
            return buildSplashScreen();
          } else {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Get.offAll(() => WelcomeScreen());
            });
            return buildSplashScreen();
          }
        }
      },
    );
  }

  Widget buildSplashScreen() {
    return AppScaffold(
      hideAppBar: true,
      scaffoldBackgroundColor:
          isDarkMode.value ? const Color(0xFF0C0910) : const Color(0xFFFCFCFC),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              isDarkMode.value
                  ? Assets.imagesPawllyLoaderDark
                  : Assets.imagesPawllyLoaderLight,
              height: Constants.appLogoSize,
              width: Constants.appLogoSize,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) =>
                  const AppLogoWidget(),
            ),
          ],
        ),
      ),
    );
  }
}
