import 'package:get/get.dart';
import 'package:messcoin/hmc/controllers/hmc_profile_controller.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() async {
    Get.lazyPut<HmcProfileController>(() => HmcProfileController());
  }
}
