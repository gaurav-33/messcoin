import 'package:get/get.dart';
import '../controllers/extra_menu_controller.dart';

class ExtraMenuBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ExtraMenuController>(() => ExtraMenuController());
  }
}
