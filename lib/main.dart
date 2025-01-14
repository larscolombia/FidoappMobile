import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
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
import 'package:webview_flutter/webview_flutter.dart';

Rx<BaseLanguage> locale = LanguageEn().obs;

/// Handler para mensajes en background
/// DEBE estar definido fuera de cualquier clase
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('aqui se ejecuta la accion : ${message.messageId}');
}

Future<void> main() async {
  // Registra el controller de notificaciones
  WidgetsFlutterBinding.ensureInitialized();
  // Si usas funciones específicas de Android, por ejemplo:
  if (Platform.isAndroid) {
    // Opcional: habilitar debugging para el contenido web de Android (solo para pruebas)
    await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);
  }
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa Firebase y espera a que termine
  await Firebase.initializeApp();
  // Registra el handler de background para Firebase Messaging

  // Inicializa PushProvider: se solicita permisos, se obtiene el token
  // y se deben registrar los listeners para los callbacks
  final pushNotificaciones = PushProvider();
  await pushNotificaciones.setupFCM();
  await pushNotificaciones
      .initNorification(); // IMPORTANTE: registra los listeners de mensajes
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  // Inicializa otros servicios necesarios después de Firebase
  await initialize(aLocaleLanguageList: languageList());
  selectedLanguageCode(
      getValueFromLocal(SELECTED_LANGUAGE_CODE) ?? DEFAULT_LANGUAGE);

  BaseLanguage temp =
      await const AppLocalizations().load(Locale(selectedLanguageCode.value));
  locale = temp.obs;
  locale.value =
      await const AppLocalizations().load(Locale(selectedLanguageCode.value));

  // Ejecuta la app
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return GetMaterialApp(
        debugShowCheckedModeBanner: false,
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
          // Si el usuario está logueado, se inicializa el WelcomeController.
          if (isLoggedIn.value) {
            log('INITIALBINDING: called');
            Get.put<WelcomeController>(WelcomeController());
          }
        }),

        title: APP_NAME,
        theme: AppTheme.lightTheme,
        home: SplashScreen(),
      );
    });
  }
}
