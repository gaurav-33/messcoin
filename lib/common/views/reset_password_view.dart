import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../common/controllers/reset_password_controller.dart';
import '../../config/app_colors.dart';
import '../../core/widgets/app_bar.dart';
import '../../core/widgets/input_field.dart';
import '../../core/widgets/neu_button.dart';
import '../../core/widgets/neu_container.dart';
import '../../core/widgets/neu_loader.dart';
import '../../utils/responsive.dart';

class ResetPasswordView extends StatelessWidget {
  const ResetPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    final ResetPasswordController controller = Get.put(ResetPasswordController());
    final double screenHeight = MediaQuery.of(context).size.height;
    // Use the responsive utility for consistent width
    final double containerWidth = Responsive.contentWidth(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          // Ensure the content can be centered on screen
          child: Container(
            constraints: BoxConstraints(
                minHeight: screenHeight - MediaQuery.of(context).padding.top),
            padding:
                EdgeInsets.symmetric(horizontal: Responsive.contentPadding(context)),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const NeuAppBar(),
                  SizedBox(height: screenHeight * 0.05),
                  NeuContainer(
                    width: containerWidth,
                    padding: const EdgeInsets.symmetric(
                        vertical: 30, horizontal: 20),
                    child: Obx(
                      () => Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Reset Password",
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          const SizedBox(height: 25),
                          // AnimatedSwitcher provides a smooth transition between steps
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            transitionBuilder:
                                (Widget child, Animation<double> animation) {
                              return FadeTransition(
                                opacity: animation,
                                child: SlideTransition(
                                  position: Tween<Offset>(
                                    begin: const Offset(0.0, 0.1),
                                    end: Offset.zero,
                                  ).animate(animation),
                                  child: child,
                                ),
                              );
                            },
                            // Conditionally build the view based on the current step
                            child: controller.step.value == 1
                                ? _buildEmailStep(
                                    context, controller, containerWidth)
                                : _buildOtpStep(
                                    context, controller, containerWidth),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Builds the UI for Step 1: Entering the email address.
  Widget _buildEmailStep(BuildContext context,
      ResetPasswordController controller, double containerWidth) {
    return Column(
      key: const ValueKey(1), // Key for AnimatedSwitcher
      children: [
        InputField(
          controller: controller.emailController,
          width: containerWidth * 0.9,
          label: "Email",
          hintText: "Enter your email",
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            NeuButton(
              width: containerWidth * 0.45,
              height: 50,
              onTap: controller.sendOtp,
              child: controller.isLoading.value
                  ? const NeuLoader()
                  : const Text("Send OTP"),
            ),
            Column(
              children: [
                NeuButton(
                  height: 50, // Fixed size for a consistent circular shape
                  width: 50,
                  shape: BoxShape.circle,
                  invert: controller.isAdmin.value,
                  onTap: () {
                    controller.isAdmin.value = !controller.isAdmin.value;
                  },
                  child: Icon(
                    Icons.person_outline,
                    color: controller.isAdmin.value
                        ? AppColors.bgColor
                        : AppColors.dark,
                  ),
                ),
                const SizedBox(height: 4),
                Text('Admin', style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ],
        ),
      ],
    );
  }

  /// Builds the UI for Step 2: Entering the OTP and new password.
  Widget _buildOtpStep(BuildContext context,
      ResetPasswordController controller, double containerWidth) {
    return Column(
      key: const ValueKey(2), // Key for AnimatedSwitcher
      children: [
        InputField(
          controller: controller.otpController,
          width: containerWidth * 0.9,
          label: "OTP",
          hintText: "Enter the OTP",
          keyboardType: TextInputType.number,
        ),
        InputField(
          controller: controller.newPasswordController,
          width: containerWidth * 0.9,
          label: "New Password",
          hintText: "Enter new password",
          obscure: true,
          keyboardType: TextInputType.visiblePassword,
        ),
        const SizedBox(height: 30),
        NeuButton(
          width: containerWidth * 0.45,
          height: 50,
          onTap: controller.submit,
          child: controller.isLoading.value
              ? const NeuLoader()
              : const Text("Submit"),
        ),
      ],
    );
  }
}
