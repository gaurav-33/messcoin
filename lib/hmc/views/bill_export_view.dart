import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:messcoin/core/widgets/neu_button.dart';
import 'package:messcoin/core/widgets/neu_loader.dart';
import 'package:messcoin/hmc/controllers/hmc_bill_export_controller.dart';
import 'package:messcoin/utils/responsive.dart';
import '../../core/widgets/app_bar.dart';

class BillExportView extends StatelessWidget {
  const BillExportView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final BillExportController controller = Get.find<BillExportController>();
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 10),
              const NeuAppBar(toBack: true),
              const SizedBox(height: 24),
              Text(
                'Export Bills',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 24),
              Obx(
                () => NeuButton(
                  width: Responsive.contentWidth(context) * 0.35,
                  onTap: controller.isExportingBill.value
                      ? null
                      : () {
                          controller.exportBillAsPdf();
                        },
                  child: controller.isExportingBill.value
                      ? const NeuLoader()
                      : const Text('Export as PDF'),
                ),
              ),
              const SizedBox(height: 24),
              Obx(
                () => NeuButton(
                  width: Responsive.contentWidth(context) * 0.35,
                  onTap: controller.isExportingBill.value
                      ? null
                      : () {
                          controller.exportBillAsExcel();
                        },
                  child: controller.isExportingBill.value
                      ? const NeuLoader()
                      : const Text('Export as Excel'),
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
