// ignore_for_file: body_might_complete_normally_catch_error

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:pawlly/modules/auth/sign_in/screens/signin_screen.dart';
import 'package:pawlly/utils/app_common.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';
import '../configs.dart';
import '../generated/assets.dart';
import '../main.dart';
import 'colors.dart';
import 'constants.dart';
import 'local_storage.dart';

String? get fontFamilyFontWeight600 =>
    GoogleFonts.beVietnamPro(fontWeight: FontWeight.w600).fontFamily;
String? get fontFamilyFontBold =>
    GoogleFonts.beVietnamPro(fontWeight: FontWeight.bold).fontFamily;
String? get fontFamilyFontWeight300 =>
    GoogleFonts.beVietnamPro(fontWeight: FontWeight.w300).fontFamily;
String? get fontFamilyFontWeight400 =>
    GoogleFonts.beVietnamPro(fontWeight: FontWeight.w400).fontFamily;

Widget get commonDivider => Column(
      children: [
        //4.height,
        Divider(
          indent: 3,
          height: 1,
          color: isDarkMode.value
              ? borderColor.withOpacity(0.1)
              : borderColor.withOpacity(0.5),
        ).paddingSymmetric(horizontal: 16),
        // 12.height,
      ],
    );

Widget get bottomSheetDivider => Column(
      children: [
        20.height,
        Divider(
          indent: 3,
          height: 0,
          color: isDarkMode.value
              ? borderColor.withOpacity(0.2)
              : borderColor.withOpacity(0.5),
        ),
        20.height,
      ],
    );

void handleRate() async {
  if (isAndroid) {
    if (getStringAsync(APP_PLAY_STORE_URL).isNotEmpty) {
      commonLaunchUrl(getStringAsync(APP_PLAY_STORE_URL),
          launchMode: LaunchMode.externalApplication);
    } else {
      commonLaunchUrl(
          '${getSocialMediaLink(LinkProvider.PLAY_STORE)}${await getPackageName()}',
          launchMode: LaunchMode.externalApplication);
    }
  } else if (isIOS) {
    if (getStringAsync(APP_APPSTORE_URL).isNotEmpty) {
      commonLaunchUrl(getStringAsync(APP_APPSTORE_URL),
          launchMode: LaunchMode.externalApplication);
    }
  }
}

void hideKeyBoardWithoutContext() {
  SystemChannels.textInput.invokeMethod('TextInput.hide');
}

void toggleThemeMode({required int themeId}) {
  if (themeId == THEME_MODE_SYSTEM) {
    Get.changeThemeMode(ThemeMode.system);
    isDarkMode(Get.isPlatformDarkMode);
  } else if (themeId == THEME_MODE_LIGHT) {
    Get.changeThemeMode(ThemeMode.light);
    isDarkMode(false);
  } else if (themeId == THEME_MODE_DARK) {
    Get.changeThemeMode(ThemeMode.dark);
    isDarkMode(true);
  }
  setValueToLocal(SettingsLocalConst.THEME_MODE, themeId);
  log('ISDARKMODE toggleDarkLightSwitch: $themeId');
  log('ISDARKMODE.VALUE: ${isDarkMode.value}');
  chnageSystemNavigationTheme();
  updateUi(true);
  updateUi(false);
}

void chnageSystemNavigationTheme() {
  if (isDarkMode.value) {
    textPrimaryColorGlobal = Colors.white;
    textSecondaryColorGlobal = Colors.white70;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor:
          Get.context != null ? scaffoldDarkColor : transparentColor,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
  } else {
    textPrimaryColorGlobal = primaryTextColor;
    textSecondaryColorGlobal = secondaryTextColor;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Get.context != null ? white : transparentColor,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
    ));
  }
}

List<LanguageDataModel> languageList() {
  return [
    LanguageDataModel(
        id: 1,
        name: 'English',
        languageCode: 'en',
        fullLanguageCode: 'en-US',
        flag: Assets.flagsIcUs),
    LanguageDataModel(
        id: 2,
        name: 'Hindi',
        languageCode: 'hi',
        fullLanguageCode: 'hi-IN',
        flag: Assets.flagsIcIn),
    LanguageDataModel(
        id: 3,
        name: 'Arabic',
        languageCode: 'ar',
        fullLanguageCode: 'ar-AR',
        flag: Assets.flagsIcAr),
    LanguageDataModel(
        id: 4,
        name: 'French',
        languageCode: 'fr',
        fullLanguageCode: 'fr-FR',
        flag: Assets.flagsIcFr),
    LanguageDataModel(
        id: 4,
        name: 'German',
        languageCode: 'de',
        fullLanguageCode: 'de-DE',
        flag: Assets.flagsIcDe),
  ];
}

Widget appCloseIconButton(BuildContext context,
    {required void Function() onPressed, double size = 12}) {
  return IconButton(
    iconSize: size,
    padding: EdgeInsets.zero,
    onPressed: onPressed,
    icon: Container(
      padding: EdgeInsets.all(size - 8),
      decoration: boxDecorationDefault(
          color: context.cardColor,
          borderRadius: BorderRadius.circular(size - 4),
          border: Border.all(color: secondaryTextColor)),
      child: Icon(
        Icons.close_rounded,
        size: size,
      ),
    ),
  );
}

Widget commonLeadingWid(
    {required String imgPath,
    required IconData icon,
    Color? color,
    double size = 20}) {
  return Image.asset(
    imgPath,
    width: size,
    height: size,
    color: color,
    fit: BoxFit.contain,
    errorBuilder: (context, error, stackTrace) => Icon(
      icon,
      size: size,
      color: color ?? secondaryColor,
    ),
  );
}

Future<void> commonLaunchUrl(String address,
    {LaunchMode launchMode = LaunchMode.inAppWebView}) async {
  await launchUrl(Uri.parse(address), mode: launchMode).catchError((e) {
    toast('${locale.value.invalidUrl}: $address');
  });
}

void viewFiles(String url) {
  if (url.isNotEmpty) {
    commonLaunchUrl(url, launchMode: LaunchMode.externalApplication);
  }
}

void launchCall(String? url) {
  if (url.validate().isNotEmpty) {
    if (isIOS) {
      commonLaunchUrl('tel://${url!}',
          launchMode: LaunchMode.externalApplication);
    } else {
      commonLaunchUrl('tel:${url!}',
          launchMode: LaunchMode.externalApplication);
    }
  }
}

void launchMap(String? url) {
  if (url.validate().isNotEmpty) {
    commonLaunchUrl(Constants.googleMapPrefix + url!,
        launchMode: LaunchMode.externalApplication);
  }
}

void launchMail(String url, {List<String>? to}) {
  if (url.validate().isNotEmpty) {
    launchUrl(mailTo(to: to ?? [url]), mode: LaunchMode.externalApplication);
  }
}

/* String formatDate(String? dateTime, {String format = DateFormatConst.yyyy_MM_dd}) {
  return DateFormat(format).format(DateTime.parse(dateTime.validate()));
} */

///
/// Date format extension for format datetime in different formats,
/// e.g. 1) dd-MM-yyyy, 2) yyyy-MM-dd, etc...
///

/// Splits a date string in the format "dd/mm/yyyy" into its constituent parts and returns a [DateTime] object.
///
/// If the input string is not a valid date format, this method returns `null`.
///
/// Example usage:
///
/// ```dart
/// DateTime? myDate = getDateTimeFromAboveFormat('27/04/2023');
/// if (myDate != null) {
///   print(myDate); // Output: 2023-04-27 00:00:00.000
/// }
/// ```
///

TextStyle get appButtonTextStyleGray => secondaryTextStyle(
    color: secondaryColor,
    size: 14,
    fontFamily:
        GoogleFonts.beVietnamPro(fontWeight: FontWeight.w500).fontFamily);
TextStyle get appButtonTextStyleWhite => secondaryTextStyle(
    color: Colors.white,
    size: 14,
    fontFamily:
        GoogleFonts.beVietnamPro(fontWeight: FontWeight.w600).fontFamily);
TextStyle get appButtonPrimaryColorText => secondaryTextStyle(
    color: primaryColor,
    fontFamily:
        GoogleFonts.beVietnamPro(fontWeight: FontWeight.w500).fontFamily);
TextStyle get appButtonFontColorText => secondaryTextStyle(
    color: Colors.grey,
    size: 14,
    fontFamily:
        GoogleFonts.beVietnamPro(fontWeight: FontWeight.w500).fontFamily);

InputDecoration inputDecoration(BuildContext context,
    {Widget? prefixIcon,
    BoxConstraints? prefixIconConstraints,
    Widget? suffixIcon,
    String? labelText,
    String? hintText,
    double? borderRadius,
    bool? filled,
    Color? fillColor}) {
  return InputDecoration(
    contentPadding:
        const EdgeInsets.only(left: 12, bottom: 10, top: 10, right: 10),
    labelText: labelText,
    hintText: hintText,
    hintStyle:
        secondaryTextStyle(size: 12, fontFamily: fontFamilyFontWeight300),
    labelStyle:
        secondaryTextStyle(size: 12, fontFamily: fontFamilyFontWeight300),
    alignLabelWithHint: true,
    prefixIcon: prefixIcon,
    prefixIconConstraints: prefixIconConstraints,
    suffixIcon: suffixIcon,
    enabledBorder: OutlineInputBorder(
      borderRadius: radius(borderRadius ?? defaultRadius),
      borderSide: const BorderSide(color: borderColor, width: 0.0),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: radius(borderRadius ?? defaultRadius),
      borderSide: const BorderSide(color: Colors.red, width: 0.0),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: radius(borderRadius ?? defaultRadius),
      borderSide: const BorderSide(color: Colors.red, width: 1.0),
    ),
    errorMaxLines: 2,
    border: OutlineInputBorder(
      borderRadius: radius(borderRadius ?? defaultRadius),
      borderSide: const BorderSide(color: borderColor, width: 0.0),
    ),
    disabledBorder: OutlineInputBorder(
      borderRadius: radius(borderRadius ?? defaultRadius),
      borderSide: const BorderSide(color: borderColor, width: 0.0),
    ),
    errorStyle: primaryTextStyle(color: Colors.red, size: 12),
    focusedBorder: OutlineInputBorder(
      borderRadius: radius(borderRadius ?? defaultRadius),
      borderSide: const BorderSide(color: primaryColor, width: 0.0),
    ),
    filled: filled,
    fillColor: fillColor,
  );
}

InputDecoration inputDecorationWithOutBorder(BuildContext context,
    {Widget? prefixIcon,
    Widget? suffixIcon,
    String? labelText,
    String? hintText,
    double? borderRadius,
    bool? filled,
    Color? fillColor}) {
  return InputDecoration(
    contentPadding:
        const EdgeInsets.only(left: 12, bottom: 10, top: 10, right: 10),
    labelText: labelText,
    hintText: hintText,
    hintStyle:
        secondaryTextStyle(size: 12, fontFamily: fontFamilyFontWeight300),
    labelStyle:
        secondaryTextStyle(size: 12, fontFamily: fontFamilyFontWeight300),
    alignLabelWithHint: true,
    prefixIcon: prefixIcon,
    suffixIcon: suffixIcon,
    enabledBorder: OutlineInputBorder(
      borderRadius: radius(borderRadius ?? defaultRadius),
      borderSide: const BorderSide(color: Colors.transparent, width: 0.0),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: radius(borderRadius ?? defaultRadius),
      borderSide: const BorderSide(color: Colors.red, width: 0.0),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: radius(borderRadius ?? defaultRadius),
      borderSide: const BorderSide(color: Colors.red, width: 1.0),
    ),
    errorMaxLines: 2,
    border: OutlineInputBorder(
      borderRadius: radius(borderRadius ?? defaultRadius),
      borderSide: const BorderSide(color: Colors.transparent, width: 0.0),
    ),
    disabledBorder: OutlineInputBorder(
      borderRadius: radius(borderRadius ?? defaultRadius),
      borderSide: const BorderSide(color: Colors.transparent, width: 0.0),
    ),
    errorStyle: primaryTextStyle(color: Colors.red, size: 12),
    focusedBorder: OutlineInputBorder(
      borderRadius: radius(borderRadius ?? defaultRadius),
      borderSide: const BorderSide(color: primaryColor, width: 0.0),
    ),
    filled: filled,
    fillColor: fillColor,
  );
}

Widget backButton({Object? result}) {
  return IconButton(
    onPressed: () {
      Get.back(result: result);
    },
    icon: const Icon(Icons.arrow_back_ios_new_outlined,
        color: Colors.grey, size: 20),
  );
}

class CommonAppBar extends StatelessWidget {
  final String title;
  final Widget? action;
  final bool hasLeadingWidget;
  final Widget? leadingWidget;
  const CommonAppBar({
    super.key,
    required this.title,
    this.hasLeadingWidget = true,
    this.leadingWidget,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        leadingWidget ??
            (hasLeadingWidget
                ? backButton()
                : const SizedBox(
                    height: 48,
                    width: 16,
                  )),
        8.width,
        Text(
          title,
          style: primaryTextStyle(size: 18),
        ),
        const Spacer(),
        action ?? const SizedBox(),
        8.width,
      ],
    );
  }
}

extension WidgetExt on Widget? {
  Container shadow() {
    return Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: this);
  }
}

extension StrEtx on String {
  Widget iconImage({double? size, Color? color, BoxFit? fit}) {
    return Image.asset(
      this,
      height: size ?? 14,
      width: size ?? 14,
      fit: fit ?? BoxFit.cover,
      color: color ?? (isDarkMode.value ? Colors.white : darkGray),
      errorBuilder: (context, error, stackTrace) {
        return Image.asset(Assets.iconsIcNoPhoto,
            height: size ?? 14, width: size ?? 14);
      },
    );
  }

  String get firstLetter => isNotEmpty ? this[0] : '';
}

void ifNotTester(VoidCallback callback) {
  if (loginUserData.value.email != Constants.DEFAULT_EMAIL) {
    callback.call();
  } else {
    toast(locale.value.demoUserCannotBeGrantedForThis);
  }
}

void doIfLoggedIn(BuildContext context, VoidCallback callback) async {
  if (isLoggedIn.value) {
    callback.call();
  } else {
    bool? res = await Get.to(() => SignInScreen());
    log('doIfLoggedIn RES: $res');

    if (res ?? false) {
      callback.call();
    }
  }
}

Color getRatingColor(int rating) {
  if (rating == 1 || rating == 2) {
    return ratingBarColor;
  } else if (rating == 3) {
    return const Color(0xFFff6200);
  } else if (rating == 4 || rating == 5) {
    return const Color(0xFF73CB92);
  } else {
    return ratingBarColor;
  }
}

Widget actionsWidget({required Widget widget, VoidCallback? onTap}) {
  return Container(
    padding: const EdgeInsets.all(8),
    decoration: boxDecorationWithShadow(
        boxShape: BoxShape.circle, backgroundColor: cardColor),
    child: widget,
  ).onTap(() {
    onTap?.call();
  },
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      hoverColor: Colors.transparent);
}

Widget detailWidget(
    {required String title, required String value, Color? textColor}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(title, style: secondaryTextStyle()).expand(),
      Text(value,
              textAlign: TextAlign.right,
              style: primaryTextStyle(size: 12, color: textColor))
          .expand(),
    ],
  ).paddingBottom(10).visible(value.isNotEmpty);
}
