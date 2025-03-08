// ignore_for_file: constant_identifier_names

part of 'app_pages.dart';

abstract class Routes {
  Routes._();
  static const HOME = _Paths.HOME;
  static const WELCOME = _Paths.WELCOME;
  static const SIGNIN = _Paths.SIGNIN;
  static const SIGNUP = _Paths.SIGNUP;
  static const CHANGEPASSWORD = _Paths.CHANGEPASSWORD;
  static const FORGETPASSWORD = _Paths.FORGETPASSWORD;
  static const TERMSCONDITIONS = _Paths.TERMSCONDITIONS;
  static const PRIVACYPOLICY = _Paths.PRIVACYPOLICY;
  static const SOBREAPP = _Paths.SOBREAPP;

  static const CHANGESUCCESSPASSWORD = _Paths.CHANGESUCCESSPASSWORD;
  static const APPRENTICESHIP = _Paths.APPRENTICESHIP;
  static const DASHBOARD = _Paths.DASHBOARD;
  static const PROFILE = _Paths.PROFILE;
  static const PROFILEPET = _Paths.PROFILEPET;
  static const ADDPET = _Paths.ADDPET;
  static const PRIVACYTERMS = _Paths.PRIVACYTERMS;
  static const PETOWNERPROFILE = _Paths.PETOWNERPROFILE;
}

abstract class _Paths {
  _Paths._();
  static const HOME = '/home';
  static const WELCOME = '/welcome';
  static const SIGNIN = '/signin';
  static const SIGNUP = '/signup';
  static const CHANGEPASSWORD = '/change-password';
  static const FORGETPASSWORD = '/forget-password';
  static const TERMSCONDITIONS = '/terms-conditions';
  static const PRIVACYPOLICY = '/privacy-policy';
  static const SOBREAPP = '/sobreapp';
  static const CHANGESUCCESSPASSWORD = '/change-success-password';
  static const APPRENTICESHIP = '/apprenticeship';
  static const DASHBOARD = '/dashboard';
  static const PROFILE = '/profile';
  static const PROFILEPET = '/profile-pet';
  static const ADDPET = '/add-pet';
  static const PRIVACYTERMS = '/privacy-terms';
  static const PETOWNERPROFILE = '/pet-owner-profile';
}

/*
      name: _Paths.SIGNUP,
      name: _Paths.CHANGEPASSWORD,
      name: _Paths.FORGETPASSWORD,
// ignore_for_file: constant_identifier_names

part of 'app_pages.dart';

abstract class Routes {
  static const HOME = '/home';
  static const WELCOME = '/welcome';
  static const LOGIN = '/login';
  static const FORM = '/form'; // Agrega esta línea
}

abstract class _Paths {
  static const HOME = Routes.HOME;
  static const WELCOME = Routes.WELCOME;
  static const LOGIN = Routes.LOGIN;
  static const FORM = Routes.FORM; // Agrega esta línea
}


// ignore_for_file: constant_identifier_names

part of 'app_pages.dart';

abstract class Routes {
  Routes._();

  static const HOME = _Paths.HOME;
  static const WELCOME = _Paths.WELCOME;
  static const LOGIN = _Paths.LOGIN;
  
}

abstract class _Paths {
  static const HOME = '/home';
  static const WELCOME = '/welcome';
  static const LOGIN = '/login';
}
*/