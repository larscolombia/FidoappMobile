import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Styles {
  static const primaryColor = Color.fromRGBO(255, 73, 49, 1);
  static const secondColor = Color.fromRGBO(255, 182, 173, 1);
  static const tertiaryColor = Color.fromRGBO(130, 56, 0, 1);
  static const fourColor = Color.fromRGBO(255, 219, 214, 1);
  static const fiveColor = Color.fromRGBO(252, 247, 229, 1);
  static const fiveColor08 = Color.fromRGBO(252, 247, 229, 0.8);
  static const greyColor = Colors.grey;

  static const greyTextColor = Color.fromRGBO(85, 85, 85, 1);
  static const greyDivider = Color.fromRGBO(234, 234, 234, 1);
  static const iconColorBack = Color.fromRGBO(252, 146, 20, 1);
  static const whiteColor = Colors.white;
  static const blackColor = Colors.black;

  static const paddingAll = EdgeInsets.only(left: 25, right: 25);
  static const paddingT10B10 = EdgeInsets.only(left: 10, right: 10);

  static final joinLogin = GoogleFonts.poppins(
    fontWeight: FontWeight.w800,
    fontSize: 15,
    color: whiteColor,
  );

  static final textTitleHome = GoogleFonts.lato(
    fontWeight: FontWeight.w800,
    fontSize: 16,
    color: blackColor,
  );

  static final textProfile15w700 = GoogleFonts.lato(
    fontWeight: FontWeight.w700,
    fontSize: 15,
    color: blackColor,
  );

  static final textProfile15w400 = GoogleFonts.lato(
    fontWeight: FontWeight.w400,
    fontSize: 15,
    color: blackColor,
  );

  static final textProfile14w800 = GoogleFonts.lato(
    fontWeight: FontWeight.w800,
    fontSize: 14,
    color: blackColor,
  );

  static final textProfile14w700 = GoogleFonts.lato(
    fontWeight: FontWeight.w700,
    fontSize: 14,
    color: blackColor,
  );

  static final textProfile14w400 = GoogleFonts.lato(
    fontWeight: FontWeight.w400,
    fontSize: 14,
    color: blackColor,
  );

  static final textProfile12w400 = GoogleFonts.lato(
    fontWeight: FontWeight.w400,
    fontSize: 12,
    color: primaryColor,
  );

  static final textSubTitleHome = GoogleFonts.lato(
    fontWeight: FontWeight.w500,
    fontSize: 12,
    color: greyTextColor,
  );

  static final secondTextTitle = GoogleFonts.lato(
    fontWeight: FontWeight.w400,
    fontSize: 14,
    color: greyTextColor,
  );

  static final boxTextTitleHome = GoogleFonts.lato(
    fontWeight: FontWeight.w700,
    fontSize: 16,
    color: whiteColor,
  );

  static final boxTextSubTitleHome = GoogleFonts.lato(
    fontWeight: FontWeight.w600,
    fontSize: 12,
    color: whiteColor,
  );

  static final boxTitleDashboard = GoogleFonts.lato(
    fontWeight: FontWeight.w700,
    fontSize: 14,
    color: greyTextColor,
  );

  static final textRed = GoogleFonts.poppins(
    fontWeight: FontWeight.w500,
    fontSize: 15,
    color: tertiaryColor,
  );

  static const dashboardTitle24 = TextStyle(
    fontFamily: 'PoetsenOne',
    fontSize: 24,
    fontWeight: FontWeight.w400,
    color: primaryColor,
  );
  static const dashboardTitle20 = TextStyle(
    fontFamily: 'PoetsenOne',
    fontSize: 20,
    fontWeight: FontWeight.w400,
    color: primaryColor,
  );

  static const welcomeTitle = TextStyle(
    fontFamily: 'PoetsenOne',
    fontSize: 29,
    fontWeight: FontWeight.w400,
    color: primaryColor,
  );

  static const joinTitle = TextStyle(
    fontFamily: 'PoetsenOne',
    fontSize: 32,
    fontWeight: FontWeight.w400,
    color: primaryColor,
  );

/*
  static final inputText = GoogleFonts.poppins(
    color: Styles.blackColor,
  );
  */
}

/*
class StylesIcons {
  static SvgPicture iconAyuda(double width, double height) {
    var _icon = SvgPicture.asset(
      'assets/icons/Icon_Ayuda.svg', // Ruta del archivo SVG en tu proyecto
      width: width,
      height: height,
    );
    return _icon;
  }

  static SvgPicture iconMenuScale(double width, double height) {
    var _icon = SvgPicture.asset(
      'assets/icons/Icon_Menu_Scale.svg', // Ruta del archivo SVG en tu proyecto
      width: width,
      height: height,
    );
    return _icon;
  }

  static SvgPicture iconPerfilDefined(double width, double height) {
    var _icon = SvgPicture.asset(
      'assets/icons/Perfil_Definido.svg', // Ruta del archivo SVG en tu proyecto
      width: width,
      height: height,
    );
    return _icon;
  }

  static SvgPicture iconChec(double width, double height) {
    var _icon = SvgPicture.asset(
      'assets/icons/Icon_Chec.svg', // Ruta del archivo SVG en tu proyecto
      width: width,
      height: height,
    );
    return _icon;
  }

  static SvgPicture iconConfiguracion(double width, double height) {
    var _icon = SvgPicture.asset(
      'assets/icons/Icon_Configuración.svg', // Ruta del archivo SVG en tu proyecto
      width: width,
      height: height,
    );
    return _icon;
  }

  static SvgPicture iconFormulario(double width, double height) {
    var _icon = SvgPicture.asset(
      'assets/icons/Icon_Formulario.svg', // Ruta del archivo SVG en tu proyecto
      width: width,
      height: height,
    );
    return _icon;
  }

  static SvgPicture iconUbicacion(double width, double height) {
    var _icon = SvgPicture.asset(
      'assets/icons/Icon_Ubicacion.svg', // Ruta del archivo SVG en tu proyecto
      width: width,
      height: height,
    );
    return _icon;
  }
}
*/