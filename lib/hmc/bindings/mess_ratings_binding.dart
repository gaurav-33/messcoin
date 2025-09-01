import 'package:get/get.dart';
import 'package:messcoin/hmc/controllers/hmc_mess_ratings_controller.dart';

class MessRatingsBinding extends Bindings {
  @override
  void dependencies() {
    // Get.lazyPut<MessRatingsController>(() => MessRatingsController());
    Get.put(MessRatingsController(), permanent: true);
  }
}
