import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';

import '../utils/colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      fontFamily: 'PoetsenOne',
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        background: const Color(0xFFF1F3F4),
        secondary: secondaryColor,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: scafoldColor,
      cardColor: cardColor,
      bottomNavigationBarTheme:
          const BottomNavigationBarThemeData(backgroundColor: Colors.white),
      iconTheme: IconThemeData(color: textPrimaryColorGlobal),
      textTheme: TextTheme(
        bodySmall: TextStyle(fontFamily: 'PoetsenOne'),
        bodyLarge: TextStyle(fontFamily: 'PoetsenOne'),
        bodyMedium: TextStyle(fontFamily: 'PoetsenOne'),
        labelSmall: TextStyle(fontFamily: 'PoetsenOne'),
        labelLarge: TextStyle(fontFamily: 'PoetsenOne'),
        labelMedium: TextStyle(fontFamily: 'PoetsenOne'),
        headlineSmall: TextStyle(fontFamily: 'PoetsenOne'),
        headlineMedium: TextStyle(fontFamily: 'PoetsenOne'),
        headlineLarge: TextStyle(fontFamily: 'PoetsenOne'),
        titleSmall: TextStyle(fontFamily: 'PoetsenOne'),
        titleMedium: TextStyle(fontFamily: 'PoetsenOne'),
        titleLarge: TextStyle(fontFamily: 'PoetsenOne'),
        displaySmall: TextStyle(fontFamily: 'PoetsenOne'),
        displayMedium: TextStyle(fontFamily: 'PoetsenOne'),
        displayLarge: TextStyle(fontFamily: 'PoetsenOne'),
        // Agrega otros estilos según sea necesario
      ),
      dialogBackgroundColor: const Color.fromARGB(255, 165, 104, 104),
      unselectedWidgetColor: Colors.black,
      dividerColor: borderColor.withOpacity(0.5),
      switchTheme: SwitchThemeData(
        trackOutlineColor: MaterialStateProperty.all(Colors.transparent),
        trackColor:
            MaterialStateProperty.all(switchActiveTrackColor.withOpacity(0.3)),
        thumbColor: MaterialStateProperty.all(switchActiveTrackColor),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        shape: RoundedRectangleBorder(
            borderRadius:
                radiusOnly(topLeft: defaultRadius, topRight: defaultRadius)),
        backgroundColor: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        surfaceTintColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
          statusBarColor: scafoldColor,
        ),
      ),
      dialogTheme: DialogTheme(shape: dialogShape()),
      pageTransitionsTheme: const PageTransitionsTheme(
          builders: <TargetPlatform, PageTransitionsBuilder>{
            TargetPlatform.android: OpenUpwardsPageTransitionsBuilder(),
            TargetPlatform.linux: OpenUpwardsPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          }),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      primarySwatch: createMaterialColor(primaryColor),
      primaryColor: primaryColor,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: cardColor,
        onPrimary: primaryColor,
        onSurface: cardColor,
        brightness: Brightness.dark,
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryColor, // button text color
        ),
      ),
      appBarTheme: const AppBarTheme(
        surfaceTintColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.light,
          statusBarColor: scaffoldDarkColor,
          statusBarBrightness: Brightness.light,
        ),
      ),
      timePickerTheme: const TimePickerThemeData(
        dayPeriodTextColor: white,
        helpTextStyle: TextStyle(color: white),
      ),
      scaffoldBackgroundColor: scaffoldDarkColor,
      fontFamily: 'PoetsenOne',
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: scaffoldSecondaryDark),
      iconTheme: const IconThemeData(color: Colors.white),
      textTheme: TextTheme(
        bodySmall: TextStyle(fontFamily: 'PoetsenOne'),
        bodyLarge: TextStyle(fontFamily: 'PoetsenOne'),
        bodyMedium: TextStyle(fontFamily: 'PoetsenOne'),
        labelSmall: TextStyle(fontFamily: 'PoetsenOne'),
        labelLarge: TextStyle(fontFamily: 'PoetsenOne'),
        labelMedium: TextStyle(fontFamily: 'PoetsenOne'),
        headlineSmall: TextStyle(fontFamily: 'PoetsenOne'),
        headlineMedium: TextStyle(fontFamily: 'PoetsenOne'),
        headlineLarge: TextStyle(fontFamily: 'PoetsenOne'),
        titleSmall: TextStyle(fontFamily: 'PoetsenOne'),
        titleMedium: TextStyle(fontFamily: 'PoetsenOne'),
        titleLarge: TextStyle(fontFamily: 'PoetsenOne'),
        displaySmall: TextStyle(fontFamily: 'PoetsenOne'),
        displayMedium: TextStyle(fontFamily: 'PoetsenOne'),
        displayLarge: TextStyle(fontFamily: 'PoetsenOne'),
        // Agrega otros estilos según sea necesario
      ),
      dialogBackgroundColor: scaffoldSecondaryDark,
      unselectedWidgetColor: Colors.white60,
      useMaterial3: true,
      bottomSheetTheme: BottomSheetThemeData(
        shape: RoundedRectangleBorder(
            borderRadius:
                radiusOnly(topLeft: defaultRadius, topRight: defaultRadius)),
        backgroundColor: scaffoldDarkColor,
      ),
      dividerColor: borderColor.withOpacity(0.2),
      cardColor: cardDarkColor,
      dialogTheme: DialogTheme(shape: dialogShape()),
      pageTransitionsTheme: const PageTransitionsTheme(
          builders: <TargetPlatform, PageTransitionsBuilder>{
            TargetPlatform.android: OpenUpwardsPageTransitionsBuilder(),
            TargetPlatform.linux: OpenUpwardsPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          }),
    );
  }
}
