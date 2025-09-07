import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:messcoin/common/controllers/reset_password_controller.dart';
import 'package:messcoin/core/widgets/app_bar.dart';
import 'package:messcoin/core/widgets/input_field.dart';
import 'package:messcoin/core/widgets/neu_button.dart';
import 'package:messcoin/core/widgets/neu_container.dart';
import 'package:messcoin/core/widgets/neu_loader.dart';
import 'package:messcoin/utils/responsive.dart';

class ResetPasswordView extends StatelessWidget {
  const ResetPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    final ResetPasswordController controller =
        Get.put(ResetPasswordController());
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
                const NeuAppBar(
                  toBack: true,
                ),
                SizedBox(height: screenHeight * 0.05),
                NeuContainer(
                  width: containerWidth,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Obx(
                      () => Column(
                        children: [
                          Text(
                            "Reset Password",
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          SizedBox(height: screenHeight * 0.03),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
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
                ),
                SizedBox(height: screenHeight * 0.02),
                TextButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: const Text("Back to Login")),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmailStep(BuildContext context,
      ResetPasswordController controller, double containerWidth) {
    final theme = Theme.of(context);
    return Column(
      key: const ValueKey(1),
      children: [
        InputField(
          label: 'Email',
          hintText: 'Enter your email',
          keyboardType: TextInputType.emailAddress,
          controller: controller.emailController,
          width: Responsive.contentWidth(context),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
        Align(
          alignment: Alignment.centerRight,
          child: Obx(
            () => NeuButton(
              onTap: () {
                controller.isAdmin.toggle();
              },
              width: 40,
              height: 40,
              shape: BoxShape.circle,
              invert: controller.isAdmin.value,
              child: Icon(
                  controller.isAdmin.value
                      ? Icons.person
                      : Icons.person_outline,
                  color: controller.isAdmin.value
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurface),
            ),
          ),
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

  Widget _buildOtpStep(BuildContext context, ResetPasswordController controller,
      double containerWidth) {
    return Column(
      key: const ValueKey(2),
      children: [
        InputField(
          label: 'OTP',
          hintText: 'Enter the OTP',
          keyboardType: TextInputType.number,
          controller: controller.otpController,
          width: Responsive.contentWidth(context),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.02),
        InputField(
          label: 'New Password',
          hintText: 'Enter new password',
          obscure: true,
          keyboardType: TextInputType.visiblePassword,
          controller: controller.newPasswordController,
          width: Responsive.contentWidth(context),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.03),
        Obx(
          () => NeuButton(
            onTap: controller.submit,
            child: controller.isLoading.value
                ? const NeuLoader()
                : const Text("Submit"),
          ),
        ),
      ],
    );
  }
}
