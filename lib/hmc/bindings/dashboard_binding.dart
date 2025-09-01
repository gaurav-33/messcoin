import 'package:get/get.dart';
import 'package:messcoin/hmc/controllers/dashboard_controller.dart';
import '../../core/sockets/socket_manager.dart';
import '../controllers/hmc_live_feedback_controller.dart';

class HmcDashboardBinding extends Bindings {
  @override
  void dependencies() async {
    Get.lazyPut<HmcDashboardController>(() => HmcDashboardController());
    await SocketManager().init();
    Get.put<LiveFeedbackController>(LiveFeedbackController());
  }
}
