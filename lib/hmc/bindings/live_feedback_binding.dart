import 'package:get/get.dart';
import 'package:messcoin/hmc/controllers/hmc_live_feedback_controller.dart';

class LiveFeedbackBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LiveFeedbackController>(() => LiveFeedbackController());
  }
}
