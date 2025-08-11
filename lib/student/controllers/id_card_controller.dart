import 'package:get/get.dart';
import '../../core/models/student_model.dart';
import '../../student/controllers/dashboard_controller.dart';

class IdCardController extends GetxController {
  StudentModel? get studentModel =>
      Get.find<DashboardController>().student.value;
}
