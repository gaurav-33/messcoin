import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:messcoin/core/models/mess_model.dart';
import 'package:messcoin/hmc/controllers/hmc_live_feedback_controller.dart';
import 'package:messcoin/utils/extensions.dart';
import '../../config/app_colors.dart';
import '../../core/models/feedback_model.dart';
import '../../core/widgets/app_bar.dart';
import '../../core/widgets/neu_button.dart';
import '../../core/widgets/neu_container.dart';
import '../../core/widgets/neu_loader.dart';
import '../../utils/responsive.dart';
import '../../utils/show_image_dialog.dart';

class LiveFeedbackView extends StatelessWidget {
  const LiveFeedbackView({super.key});

  @override
  Widget build(BuildContext context) {
    final LiveFeedbackController controller =
        Get.find<LiveFeedbackController>();
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              const SizedBox(height: 10),
              const NeuAppBar(toBack: true),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Feedback',
                      style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(width: 12),
                  Obx(() => Row(
                        children: [
                          Icon(Icons.circle,
                              color: controller.isLive.value
                                  ? Colors.green
                                  : Colors.red,
                              size: 12),
                          const SizedBox(width: 4),
                          Text(
                            controller.isLive.value ? 'Live' : 'Offline',
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: controller.isLive.value
                                          ? Colors.green
                                          : Colors.red,
                                      fontWeight: FontWeight.bold,
                                    ),
                          ),
                        ],
                      )),
                ],
              ),
              const SizedBox(height: 24),
              Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    NeuButton(
                      width: Responsive.isMobile(context)
                          ? Responsive.contentWidth(context) * 0.4
                          : Responsive.contentWidth(context) * 0.35,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      onTap: () async {
                        await controller.pickDate(context);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.calendar_today,
                              size: 20, color: AppColors.primaryColor),
                          const SizedBox(width: 8),
                          Text(
                            controller.selectedDate,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                    NeuButton(
                        width: 50,
                        height: 50,
                        shape: BoxShape.circle,
                        child: const Icon(Icons.refresh),
                        onTap: () {
                          controller.fetchFeedbackList();
                        }),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(child: NeuLoader());
                  }
                  if (controller.error.value.isNotEmpty) {
                    return Center(child: Text(controller.error.value));
                  }
                  if (controller.feedbackList.isEmpty) {
                    return const Center(child: Text('No Feedbacks Found'));
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
                                RxBool isImageExpanded = false.obs;
                                return _buildFeedbackCard(
                                    context, feedback, isImageExpanded);
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
      ),
    );
  }

  Widget _buildFeedbackCard(
      BuildContext context, FeedbackModel feedback, RxBool isImageExpanded) {
    final textTheme = Theme.of(context).textTheme;
    final LiveFeedbackController controller = Get.find();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: NeuContainer(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStudentAndMessInfo(
                context, feedback.studentData, feedback.messData),
            const SizedBox(height: 16),
            _buildRatingDisplay(context, feedback.rating, () {
              if (controller.replyToFeedbackId.value == feedback.id) {
                controller.setReplyTo(null);
              } else {
                controller.setReplyTo(feedback.id);
              }
            }),
            const SizedBox(height: 16),
            if (feedback.feedback.isNotEmpty) ...[
              Text(
                feedback.feedback,
                style: textTheme.bodyMedium,
                textAlign: TextAlign.start,
              ),
              const SizedBox(height: 16),
            ],
            Obx(
              () => Column(
                children: [
                  Row(
                    children: [
                      if (!isImageExpanded.value &&
                          feedback.imageUrl != null &&
                          feedback.imageUrl!.isNotEmpty)
                        NeuButton(
                          shape: BoxShape.circle,
                          width: 50,
                          height: 50,
                          child:
                              Icon(Icons.image, color: AppColors.primaryColor),
                          onTap: () {
                            isImageExpanded.value = !isImageExpanded.value;
                          },
                        ),
                      if (isImageExpanded.value)
                        if (feedback.imageUrl != null &&
                            feedback.imageUrl!.isNotEmpty) ...[
                          Center(
                            child: GestureDetector(
                              onTap: () =>
                                  showImageDialog(context, feedback.imageUrl!),
                              child: NeuContainer(
                                width: Responsive.contentWidth(context) * 0.6,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    feedback.imageUrl!,
                                    fit: BoxFit.cover,
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
                          const SizedBox(width: 16),
                          NeuButton(
                            width: 40,
                            shape: BoxShape.circle,
                            child: Icon(Icons.close),
                            onTap: () {
                              isImageExpanded.value = !isImageExpanded.value;
                            },
                          ),
                        ],
                    ],
                  ),
                  if (isImageExpanded.value) const SizedBox(height: 16),
                ],
              ),
            ),
            if (feedback.reply != null && feedback.reply!.isNotEmpty) ...[
              const SizedBox(height: 16),
              NeuContainer(
                width: Responsive.contentWidth(context) * 0.8,
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Reply from HMC:',
                      style: textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      feedback.reply!,
                      style: textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
            Obx(() {
              if (controller.replyToFeedbackId.value == feedback.id) {
                return Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: NeuContainer(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: TextField(
                            controller: controller.replyController,
                            autofocus: true,
                            decoration: const InputDecoration(
                              hintText: 'Type your reply...',
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      NeuButton(
                        onTap: () {
                          controller.createReply();
                        },
                        child: const Icon(Icons.send,
                            color: AppColors.primaryColor),
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            }),
            const SizedBox(height: 16),
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

  Widget _buildStudentAndMessInfo(
      BuildContext context, StudentModel? student, MessModel? mess) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          student?.fullName.toCamelCase() ?? 'N/A',
          style: Theme.of(context).textTheme.titleLarge,
          overflow: TextOverflow.visible,
        ),
        Text(student?.rollNo ?? 'N/A'),
        Text(
          mess?.name.toCamelCase() ?? 'N/A',
          overflow: TextOverflow.visible,
        ),
      ],
    );
  }

  Widget _buildRatingDisplay(
      BuildContext context, int rating, VoidCallback onReply) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
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
        ),
        NeuButton(
          width: 40,
          height: 40,
          onTap: onReply,
          shape: BoxShape.circle,
          child: Icon(Icons.reply, color: AppColors.dark),
        )
      ],
    );
  }

  Widget _buildPaginationControls(
      BuildContext context, LiveFeedbackController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          NeuButton(
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
}
