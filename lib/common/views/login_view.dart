import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:messcoin/common/controllers/login_controller.dart';
import 'package:messcoin/core/routes/app_routes.dart';
import 'package:messcoin/core/routes/mess_staff_routes.dart';
import 'package:messcoin/core/widgets/app_bar.dart';
import 'package:messcoin/core/widgets/input_field.dart';
import 'package:messcoin/core/widgets/neu_button.dart';
import 'package:messcoin/core/widgets/neu_container.dart';
import 'package:messcoin/core/widgets/neu_loader.dart';
import 'package:messcoin/utils/responsive.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final LoginController controller = Get.put(LoginController());
    final screenHeight = MediaQuery.of(context).size.height;
    final containerWidth = Responsive.contentWidth(context);
    final theme = Theme.of(context);
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
                    child: Column(
                      children: [
                        Text(
                          "Login",
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        SizedBox(height: screenHeight * 0.03),
                        InputField(
                          label: 'Email',
                          hintText: 'Enter Email',
                          keyboardType: TextInputType.emailAddress,
                          controller: controller.emailController,
                          width: Responsive.contentWidth(context),
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        InputField(
                          label: 'Password',
                          hintText: 'Enter Password',
                          obscure: true,
                          controller: controller.passwordController,
                          keyboardType: TextInputType.visiblePassword,
                          width: Responsive.contentWidth(context),
                        ),
                        SizedBox(height: screenHeight * 0.01),
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
                        SizedBox(height: screenHeight * 0.03),
                        Obx(
                          () => NeuButton(
                            onTap: controller.login,
                            child: controller.isLoading.value
                                ? const NeuLoader(
                                    size: 40,
                                  )
                                : const Text(
                                    "Login",
                                    style: TextStyle(fontSize: 18),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        Get.toNamed(AppRoutes.getResetPassword());
                      },
                      child: const Text('Reset Password'),
                    ),
                    const Text('|'),
                    TextButton(
                      onPressed: () {
                        Get.offAllNamed(AppRoutes.getRegister());
                      },
                      child: const Text("Register"),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () {
                    Get.toNamed(MessStaffRoutes.getEmployeeLogin());
                  },
                  child: const Text("Employee Login"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
