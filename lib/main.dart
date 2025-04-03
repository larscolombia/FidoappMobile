import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:pawlly/app_theme.dart';
import 'package:pawlly/configs.dart';
import 'package:pawlly/locale/app_localizations.dart';
import 'package:pawlly/locale/language_en.dart';
import 'package:pawlly/locale/languages.dart';
import 'package:pawlly/modules/provider/push_provider.dart';
import 'package:pawlly/modules/splash/splash_screen.dart';
import 'package:pawlly/modules/welcome/controllers/welcome_controller.dart';
import 'package:pawlly/routes/app_pages.dart';
import 'package:pawlly/utils/app_common.dart';
import 'package:pawlly/utils/common_base.dart';
import 'package:pawlly/utils/local_storage.dart';

import 'services/auth_service_apis.dart';

Rx<BaseLanguage> locale = LanguageEn().obs;

Future<void> main() async {
  // Registra el controller de notificaciones
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  // Inicializar servicios básicos
  await initialize(aLocaleLanguageList: languageList());
  await Firebase.initializeApp();

  // Inicializar Push Notifications
  final pushNotificaciones = PushProvider();
  await pushNotificaciones.setupFCM();
  await pushNotificaciones.initNorification();

  // Cargar datos de sesión antes de iniciar la app
  await AuthServiceApis.loadLoginData();

  // Configurar idioma
  selectedLanguageCode(
      getValueFromLocal(SELECTED_LANGUAGE_CODE) ?? DEFAULT_LANGUAGE);
  BaseLanguage temp =
      await const AppLocalizations().load(Locale(selectedLanguageCode.value));
  locale = temp.obs;

  // Manejo de errores global
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    debugPrint('Flutter Error: ${details.exception}');
  };

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: AuthServiceApis.currentUser.value != null
            ? Routes.HOME
            : Routes.WELCOME,
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
        title: APP_NAME,
        theme: AppTheme.lightTheme,

        // Binding global para manejar la sesión
        initialBinding: BindingsBuilder(() {
          Get.put(AuthServiceApis(), permanent: true);
          if (isLoggedIn.value) {
            Get.put<WelcomeController>(WelcomeController());
          }
        }),

        // Usar SplashScreen como punto de entrada
        home: SplashScreen(),
      );
    });
  }
}
