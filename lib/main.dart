import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:pawlly/locale/language_en.dart';
import 'package:pawlly/locale/languages.dart';
import 'package:pawlly/modules/home/bindings/home_binding.dart';
import 'package:pawlly/modules/welcome/bindings/welcome_binding.dart';
import 'package:pawlly/modules/welcome/screens/welcome_screen.dart';
import 'package:pawlly/routes/app_pages.dart';

Rx<BaseLanguage> locale = LanguageEn().obs;
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: Routes.WELCOME,
      getPages: AppPages.routes,
      initialBinding: WelcomeBinding(),
      title: 'Fido App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // home: WelcomeScreen(),
    );
  }
}
