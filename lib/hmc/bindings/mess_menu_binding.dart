import 'package:get/get.dart';
import 'package:messcoin/hmc/controllers/hmc_mess_menu_controller.dart';

class MessMenuBinding extends Bindings {
  @override
  void dependencies() {
    // Get.lazyPut<HmcMessMenuController>(() => HmcMessMenuController());
    Get.put<HmcMessMenuController>(HmcMessMenuController(), permanent: true);
  }
}
