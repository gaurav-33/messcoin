import 'package:get/get.dart';
import 'package:messcoin/hmc/controllers/hmc_student_search_controller.dart';

class StudentSearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StudentSearchController>(() => StudentSearchController());
  }
}
