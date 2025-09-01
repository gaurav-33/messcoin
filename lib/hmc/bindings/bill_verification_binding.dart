import 'package:get/get.dart';
import 'package:messcoin/hmc/controllers/hmc_bill_export_controller.dart';

class BillVerificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BillExportController>(() => BillExportController());
  }
}
