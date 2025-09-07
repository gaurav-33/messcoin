import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../config/app_colors.dart';
import '../../core/routes/student_routes.dart';
import '../../core/widgets/app_bar.dart';
import '../../core/widgets/input_field.dart';
import '../../core/widgets/neu_button.dart';
import '../../core/widgets/neu_container.dart';
import '../../core/widgets/neu_loader.dart';
import '../../student/controllers/write_feedback_controller.dart';
import '../../../../utils/responsive.dart';

class WriteFeedbackView extends StatelessWidget {
  const WriteFeedbackView({super.key});

  @override
  Widget build(BuildContext context) {
    final WriteFeedbackController controller =
        Get.put(WriteFeedbackController());
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                const SizedBox(height: 10),
                const NeuAppBar(toBack: true),
                const SizedBox(height: 16),
                _buildHeader(context),
                const SizedBox(height: 16),
                NeuContainer(
                  width: Responsive.contentWidth(context),
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Text('Give Feedback', style: textTheme.headlineMedium),
                      const SizedBox(height: 24),
                      Text('How was your food today?',
                          style: textTheme.bodyMedium),
                      const SizedBox(height: 16),
                      _buildRatingSection(context, controller),
                      const SizedBox(height: 24),
                      _buildFeedbackInput(controller),
                      const SizedBox(height: 24),
                      Text('Add a photo (optional)',
                          style: textTheme.bodyMedium),
                      const SizedBox(height: 16),
                      _buildImagePicker(controller),
                      const SizedBox(height: 20),
                      _buildImagePreview(context, controller),
                      const SizedBox(height: 24),
                      Obx(
                        () => NeuButton(
                          width: Responsive.contentWidth(context) * 0.5,
                          onTap: () => controller.submitFeedback(),
                          child: controller.isLoading.value
                              ? const NeuLoader()
                              : const Text('Submit',
                                  style: TextStyle(fontSize: 16)),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Header section with the "View All" button.
  Widget _buildHeader(BuildContext context) {
    return SizedBox(
      width: Responsive.contentWidth(context),
      child: Align(
        alignment: Alignment.centerRight,
        child: NeuButton(
          shape: BoxShape.circle,
          height: 48,
          width: 48,
          onTap: () => Get.toNamed(StudentRoutes.getFeedbackView()),
          child: Image.asset(
            'assets/images/view_all.png',
            color: Theme.of(context).colorScheme.primary,
            height: 24,
          ),
        ),
      ),
    );
  }

  // Section for the star rating with responsive, static buttons.
  Widget _buildRatingSection(
      BuildContext context, WriteFeedbackController controller) {
    // Determine the size of the buttons based on the screen size.
    final double buttonSize;
    final double starIconSize;

    if (Responsive.isMobile(context)) {
      buttonSize = Responsive.contentWidth(context) > 380 ? 45 : 35;
      starIconSize = buttonSize * 0.6;
    } else {
      buttonSize = 52;
      starIconSize = 32;
    }

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 12.0,
      runSpacing: 12.0,
      children: List.generate(5, (index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6.0),
          child: Obx(() {
            final isSelected = index < controller.rating.value;
            return NeuButton(
              shape: BoxShape.circle,
              height: buttonSize,
              width: buttonSize,
              onTap: () => controller.rating.value = index + 1,
              child: Image.asset(
                isSelected
                    ? 'assets/images/star-filled.png'
                    : 'assets/images/star.png',
                height: starIconSize,
                color:
                    isSelected ? AppColors.primaryColor : AppColors.lightDark,
              ),
            );
          }),
        );
      }),
    );
  }

  // Section for the feedback text input field.
  Widget _buildFeedbackInput(WriteFeedbackController controller) {
    // The width is removed so it properly fills its parent container.
    return InputField(
      width: Responsive.contentWidth(Get.context!) * 0.8,
      height: 100,
      label: 'Feedback',
      hintText: 'Write here...',
      maxLines: 5,
      controller: controller.feedbackTextController,
      keyboardType: TextInputType.multiline,
    );
  }

  // Section for the image picker buttons.
  Widget _buildImagePicker(WriteFeedbackController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        NeuButton(
          shape: BoxShape.circle,
          height: 64,
          width: 64,
          onTap: () async => await controller.pickImageFromCamera(),
          child: Image.asset('assets/images/camera.png',
              color: AppColors.lightDark, height: 32),
        ),
        const SizedBox(width: 24),
        NeuButton(
          shape: BoxShape.circle,
          height: 64,
          width: 64,
          onTap: () async => await controller.pickImageFromGallery(),
          child: Image.asset('assets/images/gallery.png',
              color: AppColors.lightDark, height: 32),
        ),
      ],
    );
  }

  // Section to display the preview of the picked image.
  Widget _buildImagePreview(
      BuildContext context, WriteFeedbackController controller) {
    return Obx(() {
      final imageFile = controller.pickedImage.value;
      return AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) {
          return FadeTransition(opacity: animation, child: child);
        },
        child: imageFile != null
            ? _buildImageContainer(
                context, Image.file(imageFile, fit: BoxFit.cover))
            : _buildImageContainer(
                context,
                Icon(Icons.photo_size_select_actual_rounded,
                    color: AppColors.primaryColor, size: 40)),
      );
    });
  }

  // Helper to create the container for the image preview.
  Widget _buildImageContainer(BuildContext context, Widget child) {
    final containerWidth = Responsive.contentWidth(context) * 0.6;
    return NeuContainer(
      key: ValueKey(child.runtimeType), // Key for AnimatedSwitcher
      width: containerWidth,
      height: containerWidth * 0.75, // Maintain aspect ratio
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: child,
      ),
    );
  }
}
