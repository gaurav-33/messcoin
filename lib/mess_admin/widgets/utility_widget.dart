import 'package:flutter/material.dart';
import 'package:messcoin/utils/responsive.dart';
import '../../config/app_colors.dart';
import '../../core/widgets/neu_container.dart';
import 'package:get/get.dart';
import '../../mess_admin/controllers/transaction_controller.dart';
import '../../utils/extensions.dart';
import '../controllers/coupon_controller.dart';

class UtilityWidget extends StatelessWidget {
  const UtilityWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Controllers available! Safe to use find().
    final controller = Get.find<TransactionController>();
    final cpnController = Get.find<CouponController>();

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(Responsive.isMobile(context) ? 0 : 16),
        child: Column(
          children: [
            // Live Transaction Section
            NeuContainer(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text('Live Transaction',
                          style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(width: 8),
                      Obx(() => Icon(
                            Icons.circle,
                            size: 10,
                            color: controller.isLive.value
                                ? Colors.green
                                : Colors.red,
                          )),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Obx(() {
                    final txns = controller.latestTransactions;
                    if (txns.isEmpty) {
                      return Text('No live transactions',
                          style: Theme.of(context).textTheme.bodySmall);
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: txns
                          .map((txn) => Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 6, horizontal: 2),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          txn.studentData?.rollNo ?? '-',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            (txn.studentData != null)
                                                ? txn.studentData!.fullName
                                                    .toCamelCase()
                                                : txn.student,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text('₹ ${txn.amount}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium),
                                        const SizedBox(width: 8),
                                        Text(
                                            txn.createdAt
                                                .toString()
                                                .toKolkataTime(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall),
                                      ],
                                    ),
                                    Container(
                                      height: 0.5,
                                      decoration: BoxDecoration(
                                          color: AppColors.lightDark,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                    )
                                  ],
                                ),
                              ))
                          .toList(),
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Live Coupon Section
            NeuContainer(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text('Live Coupon',
                          style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(width: 8),
                      Obx(() => Icon(
                            Icons.circle,
                            size: 10,
                            color: cpnController.isLive.value
                                ? Colors.green
                                : Colors.red,
                          )),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Obx(() {
                    final coupons = cpnController.latestCoupons;
                    if (coupons.isEmpty) {
                      return Text('No live coupons',
                          style: Theme.of(context).textTheme.bodySmall);
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: coupons
                          .map((cpn) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text('${cpn.studentData?.rollNo}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium,
                                            overflow: TextOverflow.ellipsis),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            (cpn.studentData?.fullName != null)
                                                ? cpn.studentData!.fullName
                                                    .toCamelCase()
                                                : cpn.student,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text('₹ ${cpn.amount}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium),
                                        const SizedBox(width: 8),
                                        Text(
                                            cpn.createdAt
                                                .toString()
                                                .toKolkataTime(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall),
                                        IconButton(
                                          icon: Icon(Icons.check_circle,
                                              color: Colors.green, size: 22),
                                          tooltip: 'Accept',
                                          onPressed: () => cpnController
                                              .approveCoupon(cpn.id),
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.cancel,
                                              color: Colors.red, size: 22),
                                          tooltip: 'Reject',
                                          onPressed: () => cpnController
                                              .rejectCoupon(cpn.id),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      height: 0.5,
                                      decoration: BoxDecoration(
                                          color: AppColors.lightDark,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                    )
                                  ],
                                ),
                              ))
                          .toList(),
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
