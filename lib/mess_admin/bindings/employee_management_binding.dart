import 'package:get/get.dart';
import 'package:messcoin/mess_admin/controllers/employee_management_controller.dart';

class EmployeeManagementBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EmployeeManagementController>(() => EmployeeManagementController());
  }
}
