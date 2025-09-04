import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:messcoin/core/widgets/input_field.dart';
import 'package:messcoin/mess_admin/controllers/counter_controller.dart';
import 'package:messcoin/mess_admin/controllers/dashboard_controller.dart';
import 'package:messcoin/core/widgets/neu_button.dart';
import 'package:messcoin/core/widgets/neu_loader.dart';

import '../../config/app_colors.dart';
import '../../utils/responsive.dart';

class CounterView extends StatelessWidget {
  const CounterView({super.key});

  @override
  Widget build(BuildContext context) {
    final CounterController controller = Get.put(CounterController());
    final DashboardController dashboardController =
        Get.find<DashboardController>();
    final bool isDesktop = Responsive.isDesktop(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              if (!isDesktop)
                Padding(
                  padding: const EdgeInsets.all(4),
                  child: NeuButton(
                      onTap: () => Scaffold.of(context).openDrawer(),
                      width: 45,
                      child: Icon(Icons.menu, color: AppColors.dark, size: 24)),
                ),
              if (!isDesktop) const SizedBox(width: 16),
              Text('Counters',
                  style: Theme.of(context).textTheme.headlineMedium),
            ],
          ),
          const SizedBox(height: 16),
          Obx(() => Text(
                'Current Number of Counters: '
                '${dashboardController.messDetail.value?.counters ?? 0}',
                style: Theme.of(context).textTheme.headlineSmall,
              )),
          const SizedBox(height: 20),
          InputField(
            width: Responsive.contentWidth(context) * 0.6,
            controller: controller.counterTextController,
            label: 'Number of Counters',
            hintText: 'Enter No. of Counters',
            keyboardType: TextInputType.number,
          ),
          const SizedBox(
            height: 16,
          ),
          Obx(
            () => controller.isLoading.value
                ? const Center(child: NeuLoader())
                : NeuButton(
                    width: Responsive.contentWidth(context) * 0.3,
                    onTap: () => controller.updateCounter(),
                    child: Text('Update'),
                  ),
          ),
        ],
      ),
    );
  }
}
