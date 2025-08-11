import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/widgets/app_bar.dart';
import '../../core/widgets/input_field.dart';
import '../../core/widgets/neu_button.dart';
import '../../core/widgets/neu_container.dart';
import '../controllers/otp_verification_controller.dart';
import '../../core/widgets/neu_loader.dart';
import '../../utils/responsive.dart';

class OtpVerificationView extends StatelessWidget {
  OtpVerificationView({super.key});

  final OtpVerificationController controller =
      Get.put(OtpVerificationController());

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double containerWidth = Responsive.contentWidth(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            // Ensure the content is centered vertically on taller screens
            constraints: BoxConstraints(
                minHeight: screenHeight - MediaQuery.of(context).padding.top),
            padding: EdgeInsets.symmetric(
                horizontal: Responsive.contentPadding(context)),
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
                            controller.isOtpSent.value
                                ? "Verify OTP"
                                : "Request OTP",
                            style: Theme.of(context).textTheme.headlineMedium,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 25),
                          // Use AnimatedSwitcher for a smooth transition between states
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
                            child: !controller.isOtpSent.value
                                ? _buildRequestOtpStep(
                                    context, controller, containerWidth)
                                : _buildVerifyOtpStep(
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

  /// Builds the UI for requesting an OTP.
  Widget _buildRequestOtpStep(BuildContext context,
      OtpVerificationController controller, double containerWidth) {
    return Column(
      key: const ValueKey('request-otp'), // Key for AnimatedSwitcher
      children: [
        InputField(
          width: containerWidth * 0.8,
          label: "Email",
          hintText: "Enter your email",
          controller: controller.emailController,
        ),
        const SizedBox(height: 30),
        NeuButton(
          width: containerWidth * 0.5,
          height: 50,
          onTap: controller.sendOtp,
          child: controller.isLoading.value
              ? const NeuLoader()
              : const Text("Send OTP"),
        ),
      ],
    );
  }

  /// Builds the UI for verifying the OTP.
  Widget _buildVerifyOtpStep(BuildContext context,
      OtpVerificationController controller, double containerWidth) {
    return Column(
      key: const ValueKey('verify-otp'), // Key for AnimatedSwitcher
      children: [
        InputField(
          width: containerWidth * 0.8,
          label: "OTP",
          hintText: "Enter OTP",
          controller: controller.otpController,
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 30),
        NeuButton(
          width: containerWidth * 0.5,
          height: 50,
          onTap: controller.verifyOtp,
          child: controller.isLoading.value
              ? const NeuLoader()
              : const Text("Verify OTP"),
        ),
      ],
    );
  }
}
