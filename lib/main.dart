import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:pawlly/app_theme.dart';
import 'package:pawlly/configs.dart';
import 'package:pawlly/locale/language_en.dart';
import 'package:pawlly/locale/languages.dart';
import 'package:pawlly/modules/splash/splash_screen.dart';
import 'package:pawlly/modules/welcome/bindings/welcome_binding.dart';
import 'package:pawlly/modules/welcome/controllers/welcome_controller.dart';
import 'package:pawlly/modules/welcome/screens/welcome_screen.dart';
import 'package:pawlly/routes/app_pages.dart';
import 'package:pawlly/utils/app_common.dart';

Rx<BaseLanguage> locale = LanguageEn().obs;
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: Routes.WELCOME,
      getPages: AppPages.routes,
      initialBinding: BindingsBuilder(() {
        // isDarkMode.value
        //     ? setStatusBarColor(scaffoldDarkColor,
        //         statusBarIconBrightness: Brightness.light,
        //         statusBarBrightness: Brightness.light)
        //     : setStatusBarColor(context.scaffoldBackgroundColor,
        //         statusBarIconBrightness: Brightness.dark,
        //         statusBarBrightness: Brightness.light);
        if (isLoggedIn.value) {
          log('INITIALBINDING: called');
          Get.put<WelcomeController>(WelcomeController());
        }
      }),
      title: APP_NAME,
      theme: AppTheme.lightTheme,
      // darkTheme: AppTheme.darkTheme,
      // themeMode: ThemeMode.system,
      themeMode: isDarkMode.value ? ThemeMode.dark : ThemeMode.light,
      /*
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      */
      home: SplashScreen(),
    );
  }
}
