import 'package:get/get.dart';
import 'package:messcoin/core/models/admin_model.dart';

import '../../core/routes/app_routes.dart';
import '../../core/storage/admin_box_manager.dart';
import '../../core/storage/auth_box_manager.dart';
import '../../core/storage/role_box_manager.dart';
import '../../utils/app_snackbar.dart';

class HmcDashboardController extends GetxController {
  RxBool isLoading = false.obs;
  Rx<AdminModel?> admin = Rx<AdminModel?>(null);

  Future<void> logout() async {
    try {
      isLoading.value = true;
      await AuthBoxManager.clearToken();
      await AdminBoxManager.clearAdmin();
      await RoleBoxManager.clearRole();
      admin.value = null;
      AppSnackbar.success("Logout successfully");
      Get.offAllNamed(AppRoutes.getSplash());
    } catch (e) {
      AppSnackbar.error('Failed to logout: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
