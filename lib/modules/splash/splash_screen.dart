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
      future: Future.wait([
        AuthServiceApis.loadLoginData(),
        Future.delayed(const Duration(seconds: 2)), // Mínimo tiempo de splash
      ]).then((results) => results[0]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return buildSplashScreen();
        }

        WidgetsBinding.instance.addPostFrameCallback((_) async {
          try {
            if (snapshot.data == true &&
                AuthServiceApis.currentUser.value != null) {
              await Get.offAll(
                () => HomeScreen(),
                binding: BindingsBuilder(() {
                  Get.put(HomeController());
                }),
                transition: Transition.fadeIn,
              );
            } else {
              await Get.offAll(
                () => WelcomeScreen(),
                transition: Transition.fadeIn,
              );
            }
          } catch (e) {
            debugPrint('Error en navegación: $e');
            await Get.offAll(() => WelcomeScreen());
          }
        });

        return buildSplashScreen();
      },
    );
  }

  Widget buildSplashScreen() {
    return AppScaffold(
      hideAppBar: true,
      scaffoldBackgroundColor:
          isDarkMode.value ? const Color(0xFF0C0910) : const Color(0xFFFCFCFC),
      body: SizedBox.expand(
        child: Image.asset(
          isDarkMode.value
              ? Assets.imagesPawllyLoaderDark
              : Assets.imagesPawllyLoaderLight,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => const AppLogoWidget(),
        ),
      ),
    );
  }
}
