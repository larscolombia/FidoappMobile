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
import 'package:pawlly/modules/integracion/controller/notificaciones/notificaciones_controller.dart';
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
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  // Configurar manejo de errores global ANTES de inicializar Firebase
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    debugPrint('Flutter Error: ${details.exception}');
  };

  // Inicializar nb_utils primero
  await initialize(aLocaleLanguageList: languageList());
  
  // Cargar datos de sesión ANTES de Firebase
  await AuthServiceApis.loadLoginData();
  
  // Configurar idioma
  selectedLanguageCode(getValueFromLocal(SELECTED_LANGUAGE_CODE) ?? DEFAULT_LANGUAGE);
  BaseLanguage temp = await const AppLocalizations().load(Locale(selectedLanguageCode.value));
  locale = temp.obs;

  // Inicializar Firebase al final, de forma opcional
  try {
    debugPrint('🔄 Intentando inicializar Firebase...');
    await Firebase.initializeApp();
    // Verificar que Firebase realmente se inicializó
    await Future.delayed(const Duration(milliseconds: 100));
    debugPrint('✅ Firebase inicializado correctamente');
    AuthServiceApis.isFirebaseInitialized = true;
  } catch (e) {
    debugPrint('❌ Error inicializando Firebase: $e');
    debugPrint('🔄 Continuando sin Firebase...');
    AuthServiceApis.isFirebaseInitialized = false;
  }

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    // Configurar FCM después de que la app esté inicializada
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeNotifications();
    });
  }
  
  Future<void> _initializeNotifications() async {
    try {
      if (AuthServiceApis.isFirebaseInitialized && isLoggedIn.value) {
        debugPrint('🔔 Configurando notificaciones...');
        final pushProvider = PushProvider();
        await pushProvider.initNorification();
        await pushProvider.setupFCM();
      } else {
        debugPrint('⚠️  No se configuran notificaciones: Firebase=${AuthServiceApis.isFirebaseInitialized}, LoggedIn=${isLoggedIn.value}');
      }
    } catch (e) {
      debugPrint('❌ Error configurando notificaciones: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: isLoggedIn.value ? Routes.HOME : Routes.WELCOME,
        getPages: AppPages.routes,
        supportedLocales: LanguageDataModel.languageLocales(),
        color: Colors.white,
        localizationsDelegates: const [
          AppLocalizations(),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        localeResolutionCallback: (locale, supportedLocales) => Locale(selectedLanguageCode.value),
        fallbackLocale: const Locale(DEFAULT_LANGUAGE),
        locale: Locale(selectedLanguageCode.value),
        title: APP_NAME,
        theme: AppTheme.lightTheme,
        initialBinding: BindingsBuilder(() {
          Get.put(AuthServiceApis(), permanent: true);
          // Registrar NotificationController para evitar errores
          Get.put(NotificationController(), permanent: true);
          if (isLoggedIn.value) {
            Get.put<WelcomeController>(WelcomeController());
          }
        }),
      );
    });
  }
}
