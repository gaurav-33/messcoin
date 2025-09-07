import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:messcoin/core/widgets/app_bar.dart';
import 'package:messcoin/hmc/controllers/hmc_profile_controller.dart';
import '../../utils/extensions.dart';
import '../../core/widgets/input_field.dart';
import '../../core/widgets/neu_button.dart';
import '../../core/widgets/neu_container.dart';
import '../../core/widgets/neu_loader.dart';
import '../../utils/responsive.dart';

class HmcProfileView extends StatelessWidget {
  const HmcProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HmcProfileController>();
    final bool isDesktop = Responsive.isDesktop(context);
    final theme = Theme.of(context);
    double width = MediaQuery.of(context).size.width;
    double containerWidth = width * 0.9;
    if (isDesktop) {
      containerWidth = 700;
    } else if (Responsive.isTablet(context)) {
      containerWidth = 600;
    }
    RxBool showChangePassword = false.obs;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,
              ),
              const NeuAppBar(
                toBack: true,
              ),
              const SizedBox(
                height: 24,
              ),
              Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: NeuLoader());
                }
                if (controller.error.isNotEmpty) {
                  return Center(
                      child: Text(controller.error.value,
                          style: theme.textTheme.bodyLarge));
                }
                final admin = controller.admin.value;
                if (admin == null) {
                  return const Center(child: Text('No profile data'));
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 32),
                    Center(
                      child: NeuContainer(
                        shape: BoxShape.circle,
                        padding: const EdgeInsets.all(8),
                        // ),
                        child: SizedBox(
                          width: 100,
                          height: 100,
                          child: ClipOval(
                            child: FadeInImage(
                              image: NetworkImage(
                                  controller.admin.value!.imageUrl!),
                              placeholder:
                                  const AssetImage('assets/images/profile.png'),
                              fit: BoxFit.cover,
                              imageErrorBuilder: (context, error, stackTrace) =>
                                  Image.asset(
                                'assets/images/profile.png',
                                fit: BoxFit.cover,
                                width: 100,
                                height: 100,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      admin.fullName.toCamelCase(),
                      style: theme.textTheme.headlineSmall!
                          .copyWith(color: theme.colorScheme.secondary),
                    ),
                    const SizedBox(height: 6),
                    Text(admin.email,
                        style: theme.textTheme.bodyMedium),
                    const SizedBox(height: 6),
                    Text('Role: ${admin.role}',
                        style: theme.textTheme.bodyMedium),
                    const SizedBox(height: 24),
                    Divider(
                      height: 32,
                      color: theme.dividerColor,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        NeuButton(
                          width: containerWidth * 0.4,
                          child: const Text("Update Password"),
                          onTap: () {
                            showChangePassword.value =
                                !showChangePassword.value;
                          },
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    if (showChangePassword.value)
                      NeuContainer(
                        width: containerWidth,
                        child: Column(
                          children: [
                            InputField(
                              controller: controller.oldPasswordController,
                              keyboardType: TextInputType.visiblePassword,
                              width: containerWidth * 0.8,
                              label: "Old Password",
                              hintText: "Enter old password",
                              obscure: true,
                            ),
                            InputField(
                              controller: controller.newPasswordController,
                              keyboardType: TextInputType.visiblePassword,
                              width: containerWidth * 0.8,
                              label: "New Password",
                              hintText: "Enter new password",
                              obscure: true,
                            ),
                            const SizedBox(
                              height: 24,
                            ),
                            NeuButton(
                                width: containerWidth * 0.4,
                                onTap: () => controller.changePassword(),
                                child: const Text('Update'))
                          ],
                        ),
                      )
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}