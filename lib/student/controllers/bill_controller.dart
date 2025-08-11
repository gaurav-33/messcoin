import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:messcoin/core/models/bill_model.dart';
import 'package:messcoin/core/services/bill_service.dart';

class BillController extends GetxController {
  final selectedMonth = DateTime.now().obs;
  final Rx<BillModel?> bill = Rx<BillModel?>(null);
  final isLoading = false.obs;
  final error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchBill();
  }

  void changeMonth(DateTime newMonth) {
    selectedMonth.value = newMonth;
    fetchBill();
  }

  Future<void> fetchBill() async {
    try {
      isLoading.value = true;
      error.value = '';
      bill.value = null;
      final month = DateFormat('M').format(selectedMonth.value);
      final year = DateFormat('yyyy').format(selectedMonth.value);
      final response = await BillService().getStudentBill(
        month: int.parse(month),
        year: int.parse(year),
      );
      if (response.statusCode == 200) {
        bill.value = BillModel.fromJson(response.data['data']);
      }
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
