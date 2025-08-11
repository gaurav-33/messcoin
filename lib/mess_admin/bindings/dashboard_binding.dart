import 'package:get/get.dart';
import '../../core/sockets/socket_manager.dart';
import '../controllers/dashboard_controller.dart';
import '../controllers/coupon_controller.dart';
import '../controllers/transaction_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() async {
    Get.lazyPut<DashboardController>(() => DashboardController());
    await SocketManager().init();
    Get.put<TransactionController>(TransactionController());
    Get.put<CouponController>(CouponController());
  }
}
