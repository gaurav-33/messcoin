import 'package:get/get.dart';
import 'package:messcoin/core/routes/hmc_routes.dart';
import '../../common/views/login_view.dart';
import '../../common/views/otp_verification_view.dart';
import '../../common/views/register_view.dart';
import '../../common/views/reset_password_view.dart';
import '../../common/views/splash_view.dart';
import '../../core/routes/admin_routes.dart';
import '../../core/routes/student_routes.dart';
import '../../core/routes/mess_staff_routes.dart';

class AppRoutes {
  static const String splash = '/splash';
  static const String login = '/login';
  static const String register = '/register';
  static const String resetPassword = '/reset-password';
  static const String otp = '/otp';

  static String getSplash() => splash;
  static String getLogin() => login;
  static String getRegister() => register;
  static String getResetPassword() => resetPassword;
  static String getOtp() => otp;

  static List<GetPage> routes = [
    ...StudentRoutes.routes,
    ...AdminRoutes.routes,
    ...HmcRoutes.routes,
    ...MessStaffRoutes.routes,
    GetPage(name: splash, page: () => const SplashView()),
    GetPage(name: login, page: () => LoginView()),
    GetPage(name: register, page: () => const RegisterView()),
    GetPage(name: resetPassword, page: () => const ResetPasswordView()),
    GetPage(name: otp, page: () => OtpVerificationView()),
  ];
}
