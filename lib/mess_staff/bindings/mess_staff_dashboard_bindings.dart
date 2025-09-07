import 'package:get/get.dart';
import 'package:messcoin/core/sockets/socket_manager.dart';
import 'package:messcoin/mess_staff/controllers/mess_staff_dashboard_controller.dart';
import 'package:messcoin/mess_staff/controllers/mess_staff_transactions_controller.dart';

class MessStaffDashboardBindings extends Bindings {
  @override
  void dependencies() async {
    Get.put(MessStaffDashboardController());
    Get.put(MessStaffTransactionsController());
    await SocketManager().init();
  }
}
