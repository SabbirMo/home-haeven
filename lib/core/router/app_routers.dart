import 'package:get/get.dart';
import 'package:home_haven/features/admin_dashboard/admin_dashboard.dart';
import 'package:home_haven/features/auth/forgot/screen/forgot_password_screen.dart';
import 'package:home_haven/features/auth/login/binding/login_binding.dart';
import 'package:home_haven/features/auth/login/screen/login_screen.dart';
import 'package:home_haven/features/auth/registration/binding/registor_binding.dart';
import 'package:home_haven/features/auth/registration/screen/register_screen.dart';
import 'package:home_haven/features/home/presentation/screen/home_screen.dart';
import 'package:home_haven/features/onboarding/binding/onboarding_binding.dart';
import 'package:home_haven/features/onboarding/view/onboarding_screen.dart';
import 'package:home_haven/features/splash/splash_screen.dart';

class AppRouters {
  static final appRouters = [
    GetPage(name: RouterConstant.splach, page: () => SplashScreen()),
    GetPage(
      name: RouterConstant.onBoarding,
      page: () => OnboardingScreen(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: RouterConstant.loginScreen,
      page: () => LoginScreen(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: RouterConstant.registorScreen,
      page: () => RegisterScreen(),
      binding: RegistorBinding(),
    ),
    GetPage(
      name: RouterConstant.forgotPassword,
      page: () => ForgotPasswordScreen(),
    ),
    GetPage(
      name: RouterConstant.homeScreen,
      page: () => HomeScreen(),
      //binding: HomeBinding(),
    ),
    // GetPage(
    //   name: RouterConstant.mainScreen,
    //   page: () => CustomBottomNavbarScreen(),
    // ),
    GetPage(
      name: RouterConstant.adminDashboard,
      page: () => AdminDashboard(),
    ),
  ];
}

class RouterConstant {
  static final splach = '/';
  static final onBoarding = '/onBoarding';
  static final loginScreen = '/loginScreen';
  static final registorScreen = '/registorScreen';
  static final forgotPassword = '/forgotPassword';
  static final homeScreen = '/homeScreen';
  static final mainScreen = '/mainScreen';
  static final adminDashboard = '/adminDashboard';
}
