import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:messcoin/common/controllers/otp_verification_controller.dart';
import 'package:messcoin/core/widgets/app_bar.dart';
import 'package:messcoin/core/widgets/input_field.dart';
import 'package:messcoin/core/widgets/neu_button.dart';
import 'package:messcoin/core/widgets/neu_container.dart';
import 'package:messcoin/core/widgets/neu_loader.dart';
import 'package:messcoin/utils/responsive.dart';

class OtpVerificationView extends StatelessWidget {
  const OtpVerificationView({super.key});

  @override
  Widget build(BuildContext context) {
    final OtpVerificationController controller =
        Get.put(OtpVerificationController());
    final screenHeight = MediaQuery.of(context).size.height;
    final containerWidth = Responsive.contentWidth(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            constraints: BoxConstraints(minHeight: screenHeight),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 10,
                ),
                const NeuAppBar(),
                SizedBox(height: screenHeight * 0.05),
                NeuContainer(
                  width: containerWidth,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Obx(
                      () => Column(
                        children: [
                          Text(
                            controller.isOtpSent.value
                                ? "Verify OTP"
                                : "Request OTP",
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          SizedBox(height: screenHeight * 0.03),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRequestOtpStep(BuildContext context,
      OtpVerificationController controller, double containerWidth) {
    return Column(
      key: const ValueKey('request-otp'),
      children: [
        InputField(
          label: 'Email',
          hintText: 'Enter your email',
          keyboardType: TextInputType.emailAddress,
          controller: controller.emailController,
          width: Responsive.contentWidth(context),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.03),
        Obx(
          () => NeuButton(
            onTap: controller.sendOtp,
            child: controller.isLoading.value
                ? const NeuLoader()
                : const Text("Send OTP"),
          ),
        ),
      ],
    );
  }

  Widget _buildVerifyOtpStep(BuildContext context,
      OtpVerificationController controller, double containerWidth) {
    return Column(
      key: const ValueKey('verify-otp'),
      children: [
        InputField(
          label: 'OTP',
          hintText: 'Enter OTP',
          keyboardType: TextInputType.number,
          controller: controller.otpController,
          width: Responsive.contentWidth(context),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.03),
        Obx(
          () => NeuButton(
            onTap: controller.verifyOtp,
            child: controller.isLoading.value
                ? const NeuLoader()
                : const Text("Verify OTP"),
          ),
        ),
      ],
    );
  }
}
