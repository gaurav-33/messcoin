import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:messcoin/core/widgets/neu_loader.dart';
import '../../config/app_colors.dart';
import '../../core/models/feedback_model.dart';
import '../../core/widgets/app_bar.dart';
import '../../core/widgets/neu_container.dart';
import '../../utils/extensions.dart';
import '../../../../core/widgets/neu_button.dart';
import '../../../../utils/responsive.dart';
import '../../utils/show_image_dialog.dart';
import '../controllers/view_feedback_controller.dart';

class ViewFeedbackView extends StatelessWidget {
  const ViewFeedbackView({super.key});

  @override
  Widget build(BuildContext context) {
    final ViewFeedbackController controller = Get.put(ViewFeedbackController());
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                children: [
                  SizedBox(height: 10),
                  NeuAppBar(toBack: true),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text('Feedback History', style: textTheme.headlineMedium),
            const SizedBox(height: 16),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: NeuLoader());
                }
                if (controller.feedbackList.isEmpty) {
                  return const Center(child: Text('No Feedback History Found'));
                }
                return Column(
                  children: [
                    Expanded(
                      child: Center(
                        child: SizedBox(
                          width: Responsive.contentWidth(context),
                          child: ListView.builder(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            itemCount: controller.feedbackList.length,
                            itemBuilder: (context, index) {
                              final feedback = controller.feedbackList[index];
                              return _buildFeedbackCard(context, feedback);
                            },
                          ),
                        ),
                      ),
                    ),
                    if (controller.totalPages.value > 1)
                      _buildPaginationControls(context, controller),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  // A dedicated widget for the feedback card UI.
  Widget _buildFeedbackCard(BuildContext context, FeedbackModel feedback) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: NeuContainer(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildRatingDisplay(context, feedback.rating),
            const SizedBox(height: 16),
            if (feedback.feedback.isNotEmpty) ...[
              Text(
                feedback.feedback,
                style: textTheme.bodyMedium,
                textAlign: TextAlign.start,
              ),
              const SizedBox(height: 16),
            ],
            if (feedback.imageUrl != null && feedback.imageUrl!.isNotEmpty) ...[
              Center(
                child: GestureDetector(
                  onTap: () => showImageDialog(context, feedback.imageUrl!),
                  child: NeuContainer(
                    width: Responsive.contentWidth(context) * 0.6,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        feedback.imageUrl!,
                        fit: BoxFit.cover,
                        // Adding loading and error builders for network images
                        loadingBuilder: (context, child, progress) {
                          return progress == null
                              ? child
                              : const Center(child: NeuLoader());
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.broken_image,
                              color: AppColors.lightDark);
                        },
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _buildReplySection(context, feedback),
              const SizedBox(height: 8),
            ],
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                feedback.createdAt.toString().toKolkataTime(),
                style:
                    textTheme.bodySmall?.copyWith(color: Colors.grey.shade600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper for displaying the star rating.
  Widget _buildRatingDisplay(BuildContext context, int rating) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        final isSelected = index < rating;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Image.asset(
            isSelected
                ? 'assets/images/star-filled.png'
                : 'assets/images/star.png',
            height: 24,
            color: isSelected ? AppColors.primaryColor : AppColors.dark,
          ),
        );
      }),
    );
  }

  // Helper for the pagination controls at the bottom.
  Widget _buildPaginationControls(
      BuildContext context, ViewFeedbackController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          NeuButton(
            width: 50,
            height: 50,
            shape: BoxShape.circle,
            onTap: controller.currentPage.value > 1
                ? () => controller.fetchFeedbackList(
                    page: controller.currentPage.value - 1)
                : null,
            child:
                Icon(Icons.keyboard_arrow_left_rounded, color: AppColors.dark),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Page ${controller.currentPage.value} of ${controller.totalPages.value}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          NeuButton(
            width: 50,
            height: 50,
            shape: BoxShape.circle,
            onTap: controller.currentPage.value < controller.totalPages.value
                ? () => controller.fetchFeedbackList(
                    page: controller.currentPage.value + 1)
                : null,
            child:
                Icon(Icons.keyboard_arrow_right_rounded, color: AppColors.dark),
          ),
        ],
      ),
    );
  }

  Widget _buildReplySection(BuildContext context, FeedbackModel feedback) {
    final textTheme = Theme.of(context).textTheme;
    return NeuContainer(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Reply from HMC:',
            style: textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            feedback.reply!,
            style: textTheme.bodyMedium,
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              feedback.updatedAt.toString().toKolkataTime(),
              style: textTheme.bodySmall?.copyWith(color: Colors.grey.shade600),
            ),
          ),
        ],
      ),
    );
  }
}
