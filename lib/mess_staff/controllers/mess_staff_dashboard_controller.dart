import 'package:get/get.dart';

import '../../core/models/mess_model.dart';
import '../../core/routes/app_routes.dart';
import '../../core/services/mess_service.dart';
import '../../core/storage/auth_box_manager.dart';
import '../../core/storage/role_box_manager.dart';
import '../../utils/app_snackbar.dart';

class MessStaffDashboardController extends GetxController {
  RxBool isLoading = false.obs;
  Rx<MessModel?> messDetail = Rx<MessModel?>(null);
  @override
  void onInit() {
    super.onInit();
    fetchMessDetails();
  }

  Future<void> fetchMessDetails() async {
    final response = await MessService().getMess();
    if (response.isSuccess) {
      messDetail.value = MessModel.fromJson(response.data['data']);
    } else {
      AppSnackbar.error('Failed to fetch mess details');
    }
  }

  Future<void> logout() async {
    try {
      isLoading.value = true;
      await AuthBoxManager.clearToken();
      await RoleBoxManager.clearRole();
      AppSnackbar.success("Logout successfully");
      Get.offAllNamed(AppRoutes.getSplash());
    } catch (e) {
      AppSnackbar.error('Failed to logout: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
