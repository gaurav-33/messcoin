import '../../core/routes/admin_routes.dart';
import '../../core/routes/hmc_routes.dart';
import '../../core/services/admin_service.dart';
import '../../core/services/student_service.dart';
import '../../core/storage/auth_box_manager.dart';
import '../../core/routes/app_routes.dart';
import '../../core/routes/student_routes.dart';
import 'package:get/get.dart';
import 'dart:convert';

class SplashController extends GetxController {
  @override
  void onInit() {
    _navigateToNextScreen();
    super.onInit();
  }

  void _navigateToNextScreen() async {
    await Future.delayed(const Duration(milliseconds: 2000));
    final isLoggedIn = await isLogin();
    final role = await checkRole();
    if (isLoggedIn && role == 'student') {
      Get.offAllNamed(StudentRoutes.getDashboard());
    } else if (isLoggedIn && role == 'mess_admin') {
      Get.offAllNamed(AdminRoutes.getDashboard());
    } else if (isLoggedIn && role == 'hmc_admin') {
      Get.offAllNamed(HmcRoutes.getDashboard());
    } else {
      Get.offAllNamed(AppRoutes.getLogin());
    }
  }

  Future<bool> isLogin() async {
    final token = await AuthBoxManager.getToken();
    if (token == null) return false;
    // Decode JWT and check expiry
    final parts = token.split('.');
    if (parts.length != 3) return false;
    final payload =
        utf8.decode(base64Url.decode(base64Url.normalize(parts[1])));
    final payloadMap = json.decode(payload);
    if (!payloadMap.containsKey('exp')) return false;
    final exp = payloadMap['exp'];
    final role = payloadMap['role'];

    if (!payloadMap.containsKey('role')) return false;

    final expiry = DateTime.fromMillisecondsSinceEpoch(exp * 1000);
    if (DateTime.now().isAfter(expiry)) {
      final refreshed = await _refreshToken(role);
      if (!refreshed) return false;
    }
    return true;
  }

  Future<bool> _refreshToken(String role) async {
    try {
      final response = role.contains('admin')
          ? await AdminService().refreshToken()
          : await StudentService().refreshToken();

      if (response.isSuccess) {
        await AuthBoxManager.clearToken();
        await AuthBoxManager.saveToken(response.data['data']['accessToken']);
        return true;
      } else {
        await AuthBoxManager.clearToken();
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<String> checkRole() async {
    final token = await AuthBoxManager.getToken();
    if (token == null) return 'guest';
    final parts = token.split('.');
    if (parts.length != 3) return 'guest';
    final payload =
        utf8.decode(base64Url.decode(base64Url.normalize(parts[1])));
    final payloadMap = json.decode(payload);
    if (!payloadMap.containsKey('role')) return 'guest';
    return payloadMap['role'];
  }
}
