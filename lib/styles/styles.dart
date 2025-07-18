import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Styles {
  static const primaryColor = Color(0xFFFF4931);
  static const secondColor = Color.fromRGBO(255, 182, 173, 1);
  static const tertiaryColor = Color.fromRGBO(130, 56, 0, 1);
  static const fourColor = Color.fromRGBO(255, 219, 214, 1);
  static const fiveColor = Color(0xFFFEF7E5);
  static const fiveColor08 = Color.fromRGBO(252, 247, 229, 0.8);
  static const greyColor = Colors.grey;
  static const fuente1 = 'Lato';
  static const fuente2 = 'PoetsenOne';
  static const greyTextColor = Color.fromRGBO(85, 85, 85, 1);
  static const greyDivider = Color.fromRGBO(234, 234, 234, 1);
  static const iconColorBack = Color(0xFFFC9214);
  static const whiteColor = Colors.white;
  static const blackColor = Colors.black;
  static const colorError = Colors.red;

  static const widh_pantalla = 380.00;
  static double tamano(context) {
    return MediaQuery.sizeOf(context).width - 100;
  }

  static const paddingAll = EdgeInsets.only(left: 26, right: 26);
  static const paddingT10B10 = EdgeInsets.only(left: 10, right: 10);

  static final joinLogin = GoogleFonts.poppins(
    fontWeight: FontWeight.w800,
    fontSize: 15,
    color: whiteColor,
  );

  static final textTitleHome = TextStyle(
    fontWeight: FontWeight.w800,
    fontSize: 16,
    color: blackColor,
    fontFamily: 'Lato',
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

  static final textProfile13w800 = GoogleFonts.lato(
    fontWeight: FontWeight.w800,
    fontSize: 13,
    color: blackColor,
  );

  static final textProfile12w400 = GoogleFonts.lato(
    fontWeight: FontWeight.w400,
    fontSize: 12,
    color: primaryColor,
  );

  static final textSubTitleHome = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 12,
    color: greyTextColor,
    fontFamily: 'Lato',
  );

  static final secondTextTitle = GoogleFonts.lato(
    fontWeight: FontWeight.w400,
    fontSize: 14,
    color: Color(0XFF383838),
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

  static final homeBoxTextSubTitle = TextStyle(
    fontFamily: 'Lato',
    fontSize: 14,
    color: Color(0xFF383838),
    fontWeight: FontWeight.w500,
  );

  static final boxTitleDashboard = GoogleFonts.lato(
    fontWeight: FontWeight.w700,
    fontSize: 14,
    color: const Color(0xFF383838),
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
    height: 1.2,
  );
  static const dashboardTitle20 = TextStyle(
    fontFamily: 'PoetsenOne',
    fontSize: 20,
    fontWeight: FontWeight.w400,
    color: primaryColor,
  );
  static TextStyle titulorecursos = const TextStyle(
    fontFamily: 'PoetsenOne',
    fontSize: 20,
    fontWeight: FontWeight.w400,
    color: Color(0xFFFF4931),
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

  static const chiptitle = TextStyle(
    fontFamily: 'Lato',
    fontSize: 15,
    fontWeight: FontWeight.bold,
    color: iconColorBack,
  );

  static final TextClaro = TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 14,
    height: 1.6,
    color: Color(0xFF959595),
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