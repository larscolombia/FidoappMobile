import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:pawlly/app_theme.dart';
import 'package:pawlly/configs.dart';
import 'package:pawlly/locale/app_localizations.dart';
import 'package:pawlly/locale/language_en.dart';
import 'package:pawlly/locale/languages.dart';
import 'package:pawlly/modules/splash/splash_screen.dart';
import 'package:pawlly/modules/welcome/controllers/welcome_controller.dart';
import 'package:pawlly/routes/app_pages.dart';
import 'package:pawlly/utils/app_common.dart';
import 'package:pawlly/utils/common_base.dart';
import 'package:pawlly/utils/local_storage.dart';

Rx<BaseLanguage> locale = LanguageEn().obs;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  Stripe.publishableKey =
      'sk_test_51I3R8hFWfM6dcSbz41CTp614CT2MCUOvFKyaY9XHpdxov8nn34SpTq59hoMOLjeMgiXTsfyi9PxgskQoW7UTItng00KWw2a7Ye'; //credenciales de stripe

  await initialize(aLocaleLanguageList: languageList());
  selectedLanguageCode(
      getValueFromLocal(SELECTED_LANGUAGE_CODE) ?? DEFAULT_LANGUAGE);
  BaseLanguage temp =
      await const AppLocalizations().load(Locale(selectedLanguageCode.value));
  locale = temp.obs;
  locale.value =
      await const AppLocalizations().load(Locale(selectedLanguageCode.value));
  Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    print('Estamos en el inicio');
    return Obx(() {
      return GetMaterialApp(
        initialRoute: Routes.WELCOME,
        getPages: AppPages.routes,
        supportedLocales: LanguageDataModel.languageLocales(),
        color: Colors.white,
        localizationsDelegates: const [
          AppLocalizations(),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        localeResolutionCallback: (locale, supportedLocales) =>
            Locale(selectedLanguageCode.value),
        fallbackLocale: const Locale(DEFAULT_LANGUAGE),
        locale: Locale(selectedLanguageCode.value),

        // Esta es la sección inicial donde se configuran las bindings.
        initialBinding: BindingsBuilder(() {
          // isDarkMode.value
          //     ? setStatusBarColor(scaffoldDarkColor,
          //         statusBarIconBrightness: Brightness.light,
          //         statusBarBrightness: Brightness.light)
          //     : setStatusBarColor(context.scaffoldBackgroundColor,
          //         statusBarIconBrightness: Brightness.dark,
          //         statusBarBrightness: Brightness.light);

          // Si el usuario está logueado, se inicializa el WelcomeController.
          if (isLoggedIn.value) {
            log('INITIALBINDING: called');
            Get.put<WelcomeController>(WelcomeController());
          }
        }),

        title: APP_NAME,

        // Aquí se define el tema claro de la aplicación.
        theme: AppTheme.lightTheme,

        // Se comenta la parte del tema oscuro porque no está definido.
        // darkTheme: AppTheme.darkTheme,
        // themeMode: ThemeMode.system,

        // Aquí se establece el modo del tema dependiendo de si el modo oscuro está activado o no.
        // themeMode: isDarkMode.value ? ThemeMode.dark : ThemeMode.light,

        // Esta es la pantalla de inicio que se muestra cuando la app se carga.
        home: SplashScreen(),
      );
    });
  }
}
