import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:messcoin/core/widgets/app_bar.dart';
import 'package:messcoin/core/widgets/input_field.dart';
import 'package:messcoin/core/widgets/neu_container.dart';
import 'package:messcoin/mess_staff/controllers/employee_login_controller.dart';
import 'package:messcoin/utils/responsive.dart';
import '../../core/widgets/neu_button.dart';
import '../../core/widgets/neu_loader.dart';

class EmployeeLoginView extends StatelessWidget {
  const EmployeeLoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final EmployeeLoginController controller =
        Get.put(EmployeeLoginController());
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 10,
              ),
              NeuAppBar(
                toBack: true,
              ),
              SizedBox(height: Get.height * 0.1),
              GestureDetector(
                onTap: FocusScope.of(context).unfocus,
                behavior: HitTestBehavior.translucent,
                child: NeuContainer(
                  width: Responsive.contentWidth(context),
                  child: Column(
                    children: [
                      Text("Employee Login",
                          style: Theme.of(context).textTheme.headlineMedium),
                      const SizedBox(height: 24),
                      InputField(
                        width: Responsive.contentWidth(context) * 0.8,
                        controller: controller.phoneController,
                        label: "Phone",
                        hintText: "Enter Phone No.",
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 20),
                      InputField(
                        width: Responsive.contentWidth(context) * 0.8,
                        controller: controller.passwordController,
                        label: "Password",
                        hintText: "Enter Password",
                        obscure: true,
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
              SizedBox(height: Get.height * 0.04),
              Obx(
                () => NeuButton(
                  width: Responsive.contentWidth(context) * 0.5,
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
            ],
          ),
        ),
      ),
    );
  }
}
