import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import '../../core/services/bill_service.dart';
import '../../utils/app_snackbar.dart';

class BillExportController extends GetxController {
  RxBool isExportingBill = false.obs;
  RxString lastExportedFilePath = ''.obs;

  Future<void> exportBillAsPdf() async {
    isExportingBill.value = true;
    final resp = await BillService().downloadSemesterPdfBill();
    if (resp.isSuccess && resp.data != null) {
      AppSnackbar.info('Opening PDF...');
      String filePath = resp.data;
      final result = await OpenFile.open(filePath);
      if (result.type == ResultType.done) {
        lastExportedFilePath.value = filePath;
      }
    }
    isExportingBill.value = false;
  }

  Future<void> exportBillAsExcel() async {
    isExportingBill.value = true;
    final resp = await BillService().downloadSemesterExcelBill();
    if (resp.isSuccess && resp.data != null) {
      AppSnackbar.info('Opening EXCEL...');
      String filePath = resp.data;
      final result = await OpenFile.open(filePath);
      if (result.type == ResultType.done) {
        lastExportedFilePath.value = filePath;
      }
    }
    isExportingBill.value = false;
  }
}
