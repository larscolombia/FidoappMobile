import 'package:get/get.dart';
import 'package:pawlly/modules/apprenticeship/bindings/home_binding.dart';
import 'package:pawlly/modules/apprenticeship/screens/Apprenticeship.dart';
import 'package:pawlly/modules/auth/password/bindings/change_password_binding.dart';
import 'package:pawlly/modules/auth/password/bindings/change_success_password_binding.dart';
import 'package:pawlly/modules/auth/password/bindings/forget_password_binding.dart';
import 'package:pawlly/modules/auth/password/screens/change_password_screen.dart';
import 'package:pawlly/modules/auth/password/screens/forget_password_screen.dart';
import 'package:pawlly/modules/auth/password/screens/change_success_password.dart';
import 'package:pawlly/modules/auth/sign_in/screens/signin_screen.dart';
import 'package:pawlly/modules/auth/sign_up/bindings/sign_un_binding.dart';
import 'package:pawlly/modules/auth/sign_up/screens/signup_screen.dart';
import 'package:pawlly/modules/dashboard/bindings/dashboard_binding.dart';
import 'package:pawlly/modules/dashboard/screens/dashboard_screen.dart';
import 'package:pawlly/modules/home/bindings/home_binding.dart';
import 'package:pawlly/modules/home/screens/home_screen.dart';
import 'package:pawlly/modules/auth/sign_in/bindings/sign_in_binding.dart';
import 'package:pawlly/modules/profile/bindings/profile_binding.dart';
import 'package:pawlly/modules/profile/screens/profile_screen.dart';
import 'package:pawlly/modules/profile_pet/bindings/profile_pet_binding.dart';
import 'package:pawlly/modules/profile_pet/screens/profile_pet_screen.dart';
import 'package:pawlly/modules/welcome/bindings/welcome_binding.dart';
import 'package:pawlly/modules/welcome/screens/welcome_screen.dart';
import 'package:pawlly/screens_demo/privacy_policy.dart';
import 'package:pawlly/screens_demo/terms_conditions.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const welcome = Routes.WELCOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeScreen(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.WELCOME,
      page: () => WelcomeScreen(),
      binding: WelcomeBinding(),
    ),
    GetPage(
      name: _Paths.SIGNIN,
      page: () => SignInScreen(),
      binding: SignInBinding(),
    ),
    GetPage(
      name: _Paths.SIGNUP,
      page: () => SignUpScreen(),
      binding: SignUpBinding(),
    ),
    GetPage(
      name: _Paths.CHANGEPASSWORD,
      page: () => ChangePasswordScreen(),
      binding: ChangePasswordBinding(),
    ),
    GetPage(
      name: _Paths.FORGETPASSWORD,
      page: () => ForgetPasswordScreen(),
      binding: ForgetPasswordBinding(),
    ),
    GetPage(
      name: _Paths.CHANGESUCCESSPASSWORD,
      page: () => ChangeSuccessPassword(),
      binding: ChangeSuccessPasswordBinding(),
    ),
    GetPage(
      name: _Paths.TERMSCONDITIONS,
      page: () => TermsConditions(),
    ),
    GetPage(
      name: _Paths.PRIVACYPOLICY,
      page: () => PrivacyPolicy(),
    ),
    GetPage(
      name: _Paths.APPRENTICESHIP,
      page: () => ApprenticeshipScreen(),
      binding: ApprenticeshipBinding(),
    ),
    GetPage(
      name: _Paths.DASHBOARD,
      page: () => DashboardScreen(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => ProfileScreen(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.PROFILEPET,
      page: () => ProfilePetScreen(),
      binding: ProfilePetBinding(),
    ),
  ];
}
