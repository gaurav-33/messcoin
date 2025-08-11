import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/services/coupon_service.dart';
import '../../student/controllers/dashboard_controller.dart';
import '../../utils/app_snackbar.dart';
import '../../utils/extensions.dart';
import '../../utils/validators.dart';
import '../../../../config/app_colors.dart';
import '../../../../core/models/student_model.dart';
import '../../../../core/widgets/neu_button.dart';
import '../../core/widgets/receipt_clipper.dart';
import '../../utils/responsive.dart';

class CouponBuyController extends GetxController {
  final amountController = TextEditingController();
  final RxBool isLoading = false.obs;
  StudentModel? get studentModel =>
      Get.find<DashboardController>().student.value;

  @override
  void onClose() {
    amountController.dispose();
    super.onClose();
  }

  void request(BuildContext context) async {
    if (isLoading.value) return;
    isLoading.value = true;

    try {
      final amount = amountController.text.trim();
      final amountError = Validators.validateAmount(amount);

      if (amountError != null) {
        AppSnackbar.error(amountError);
        return;
      }
      if (studentModel == null) {
        AppSnackbar.error('Student data not found');
        return;
      }
      final parsedAmount = double.tryParse(amount) ?? 0;
      final leftCoupon =
          studentModel!.wallet.totalCredit - studentModel!.wallet.loadedCredit;
      if (leftCoupon < parsedAmount) {
        AppSnackbar.error('Insufficient coupon balance');
        return;
      }

      if (leftCoupon > 500 && parsedAmount < 500) {
        AppSnackbar.error(
            'You can only buy a minimum of 500 coupons at a time');
        return;
      }
      final response = await CouponService().createCoupon(parsedAmount);
      if (response.isSuccess) {
        AppSnackbar.success('Request successful: ${response.data['message']}');
        amountController.clear();
        await Get.find<DashboardController>().refreshStudent();
        showPaymentSuccessDialog(
          context,
          amount: amount,
          couponId: response.data['data']['coupon_id'] ?? 'N/A',
          time: response.data['data']['createdAt'],
          name: studentModel?.mess.name ?? "Venom catering Service",
        );
      } else {
        AppSnackbar.error('Coupon Request failed: ${response.message}');
      }
    } catch (e) {
      AppSnackbar.error('Coupon Request failed: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void showPaymentSuccessDialog(
    BuildContext context, {
    required String amount,
    required String couponId,
    required String time,
    required String name,
  }) {
    final textTheme = Theme.of(context).textTheme;
    final screenHeight = MediaQuery.of(context).size.height;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: ClipPath(
          clipper: ReceiptClipper(),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: screenHeight * 0.8,
            ),
            child: Container(
              color: AppColors.bgColor,
              width: Responsive.contentWidth(context),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check_circle_rounded,
                        color: AppColors.primaryColor, size: 70),
                    const SizedBox(height: 16),
                    Text('Request Successful!',
                        style: textTheme.headlineMedium),
                    const SizedBox(height: 24),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        '₹$amount',
                        style: textTheme.displayMedium?.copyWith(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'FiraCode',
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    CustomPaint(
                      painter: DashedLinePainter(),
                      child: const SizedBox(height: 1, width: double.infinity),
                    ),
                    const SizedBox(height: 16),
                    _buildDetailRow(context, 'From:',
                        studentModel?.fullName.toCamelCase() ?? ""),
                    _buildDetailRow(context, 'To:', name.toCamelCase()),
                    const SizedBox(height: 16),
                    _buildDetailRow(context, 'Date:', time.toKolkataTime()),
                    const SizedBox(height: 8),
                    _buildDetailRow(context, 'Cpn. ID:', couponId,
                        isSelectable: true),
                    const SizedBox(height: 32),
                    NeuButton(
                      shape: BoxShape.circle,
                      onTap: () => Navigator.of(context).pop(),
                      child:
                          Icon(Icons.close_rounded, color: AppColors.lightDark),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String title, String value,
      {bool isSelectable = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(width: 16),
          Expanded(
            child: isSelectable
                ? SelectableText(
                    value,
                    textAlign: TextAlign.end,
                    style: Theme.of(context).textTheme.bodyLarge,
                  )
                : Text(
                    value,
                    textAlign: TextAlign.end,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
          ),
        ],
      ),
    );
  }
}
