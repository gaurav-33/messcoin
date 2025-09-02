import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../config/app_colors.dart';
import '../../core/routes/app_routes.dart';
import '../../core/routes/mess_staff_routes.dart';
import '../../core/widgets/app_bar.dart';
import '../../core/widgets/input_field.dart';
import '../../core/widgets/neu_button.dart';
import '../../core/widgets/neu_container.dart';
import '../../core/widgets/neu_loader.dart';

import '../../utils/responsive.dart';
import '../controllers/login_controller.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final LoginController controller = Get.put(LoginController());

    final double screenHeight = MediaQuery.of(context).size.height;

    final double containerWidth = Responsive.contentWidth(context);

    final double containerHeight = (screenHeight * 0.52).clamp(380.0, 500.0);

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          constraints: BoxConstraints(minHeight: screenHeight),
          padding: EdgeInsets.symmetric(
              horizontal: Responsive.contentPadding(context)),
          child: Center(
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const NeuAppBar(),
                  SizedBox(height: screenHeight * 0.05),
                  GestureDetector(
                    onTap: FocusScope.of(context).unfocus,
                    behavior: HitTestBehavior.translucent,
                    child: NeuContainer(
                      height: containerHeight,
                      width: containerWidth,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text("Login",
                              style: Theme.of(context).textTheme.headlineMedium),
                          InputField(
                            width: containerWidth * 0.8,
                            label: 'Email',
                            hintText: 'Enter Email',
                            keyboardType: TextInputType.emailAddress,
                            controller: controller.emailController,
                          ),
                          InputField(
                            width: containerWidth * 0.8,
                            label: 'Password',
                            hintText: 'Enter Password',
                            obscure: true,
                            controller: controller.passwordController,
                            keyboardType: TextInputType.visiblePassword,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: containerWidth * 0.05),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                NeuButton(
                                  width: containerWidth * 0.4,
                                  height: 40,
                                  onTap: () {
                                    Get.toNamed(AppRoutes.getResetPassword());
                                  },
                                  child: Text('Reset Password',
                                      textAlign: TextAlign.center,
                                      style:
                                          Theme.of(context).textTheme.bodySmall),
                                ),
                                Column(
                                  children: [
                                    Obx(
                                      () => NeuButton(
                                        height: 45,
                                        width: 45,
                                        shape: BoxShape.circle,
                                        invert: controller.isAdmin.value,
                                        onTap: () {
                                          controller.isAdmin.value =
                                              !controller.isAdmin.value;
                                        },
                                        child: Icon(
                                          Icons.person,
                                          color: controller.isAdmin.value
                                              ? AppColors.bgColor
                                              : AppColors.dark,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text('Admin',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium),
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.04),
                  Obx(
                    () => NeuButton(
                      width: containerWidth * 0.5,
                      height: 50,
                      onTap: () {
                        controller.login();
                      },
                      child: controller.isLoading.value
                          ? const NeuLoader()
                          : const Text(
                              "Login",
                              style: TextStyle(fontSize: 18),
                            ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  NeuButton(
                    width: containerWidth * 0.4,
                    height: 45,
                    onTap: () {
                      Get.offAllNamed(AppRoutes.getRegister());
                    },
                    child: const Text(
                      "Register",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  NeuButton(
                    width: containerWidth * 0.4,
                    height: 45,
                    onTap: () {
                      Get.toNamed(MessStaffRoutes.getEmployeeLogin());
                    },
                    child: const Text(
                      "Employee Login",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
