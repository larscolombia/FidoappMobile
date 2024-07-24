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
  static const CHANGESUCCESSPASSWORD = _Paths.CHANGESUCCESSPASSWORD;
  static const APPRENTICESHIP = _Paths.APPRENTICESHIP;
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
  static const CHANGESUCCESSPASSWORD = '/change-success-password';
  static const APPRENTICESHIP = '/apprenticeship';
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