import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:messcoin/config/app_colors.dart';
import 'package:messcoin/core/widgets/neu_container.dart';
import 'package:messcoin/core/widgets/neu_loader.dart';
import 'package:messcoin/hmc/controllers/hmc_mess_ratings_controller.dart';
import 'package:messcoin/utils/extensions.dart';
import '../../core/models/weekly_rating_model.dart';
import '../../core/widgets/app_bar.dart';
import '../../core/widgets/neu_button.dart';
import '../../utils/responsive.dart';

class MessRatingsView extends StatelessWidget {
  const MessRatingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final MessRatingsController controller = Get.find<MessRatingsController>();
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              const SizedBox(height: 10),
              const NeuAppBar(toBack: true),
              const SizedBox(height: 24),
              Center(
                child: SizedBox(
                  width: Responsive.contentWidth(context),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Center(
                          child: Text(
                            'Mess Ratings',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                        ),
                      ),
                      NeuButton(
                        width: 40,
                        height: 40,
                        shape: BoxShape.circle,
                        onTap: () => controller.fetchWeeklyRatings(),
                        child:
                            Icon(Icons.refresh, color: AppColors.primaryColor),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: Center(
                  child: SizedBox(
                    width: Responsive.contentWidth(context),
                    child: Obx(() {
                      if (controller.isLoading.value) {
                        return const Center(child: NeuLoader());
                      }
                      if (controller.error.value.isNotEmpty) {
                        return Center(child: Text(controller.error.value));
                      }
                      return ListView.builder(
                        itemCount: controller.weeklyRatingsByWeek.keys.length,
                        itemBuilder: (context, index) {
                          final week = controller.weeklyRatingsByWeek.keys
                              .elementAt(index);
                          final ratings = controller.weeklyRatingsByWeek[week]!;
                          return Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: NeuContainer(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Week of $week',
                                    style: Get.textTheme.titleLarge,
                                  ),
                                  const SizedBox(height: 16),
                                  ...ratings.map(
                                      (rating) => _buildRatingCard(rating)),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRatingCard(WeeklyRatingModel rating) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Container(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              rating.mess.name.toCamelCase(),
              style: Get.textTheme.titleMedium,
              overflow: TextOverflow.visible,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Feedbacks: ${rating.feedbackCount}',
                    style: Get.textTheme.bodyMedium),
                Row(
                  children: [
                    Icon(Icons.star, color: AppColors.primaryColor),
                    const SizedBox(width: 4),
                    Text(rating.feedbackAvgRating.toStringAsFixed(1),
                        style: Get.textTheme.bodyMedium),
                  ],
                ),
              ],
            ),
            Divider(
              height: 10,
            )
          ],
        ),
      ),
    );
  }
}
