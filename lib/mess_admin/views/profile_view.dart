import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/extensions.dart';
import '../../core/widgets/input_field.dart';
import '../../../../config/app_colors.dart';
import '../../../../core/widgets/neu_button.dart';
import '../../../../core/widgets/neu_container.dart';
import '../../../../core/widgets/neu_loader.dart';
import '../../../../utils/responsive.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfileController>();
    final bool isDesktop = Responsive.isDesktop(context);
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
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (!isDesktop)
                    Padding(
                      padding: const EdgeInsets.all(4),
                      child: NeuButton(
                          onTap: () => Scaffold.of(context).openDrawer(),
                          width: 45,
                          child: Icon(
                            Icons.menu,
                            color: AppColors.dark,
                          )),
                    ),
                  if (!isDesktop) const SizedBox(width: 16),
                  Text('Profile',
                      style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(width: 12),
                ],
              ),
              Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: NeuLoader());
                }
                if (controller.error.isNotEmpty) {
                  return Center(
                      child: Text(controller.error.value,
                          style: Theme.of(context).textTheme.bodyLarge));
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
                        // child: CircleAvatar(
                        //   radius: 48,
                        //   backgroundColor: AppColors.bgColor,
                        //   backgroundImage: controller.admin.value?.imageUrl !=
                        //           ''
                        //       ? NetworkImage(controller.admin.value!.imageUrl!)
                        //       : AssetImage('assets/images/profile.png'),
                        // ),
                        child: SizedBox(
                          width: 100,
                          height: 100,
                          child: ClipOval(
                            child: FadeInImage(
                              image: NetworkImage(
                                  controller.admin.value!.imageUrl!),
                              placeholder:
                                  AssetImage('assets/images/profile.png'),
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
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall!
                          .copyWith(color: AppColors.primaryColor),
                    ),
                    const SizedBox(height: 6),
                    Text(admin.email,
                        style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(height: 6),
                    Text('Role: ${admin.role}',
                        style: Theme.of(context).textTheme.bodyMedium),
                    if (admin.mess != null) ...[
                      const SizedBox(height: 6),
                      Text('Mess: ${admin.mess!.name.toCamelCase()}',
                          style: Theme.of(context).textTheme.bodyMedium),
                      const SizedBox(height: 4),
                      Text('Hostel: ${admin.mess!.hostel.toCamelCase()}',
                          style: Theme.of(context).textTheme.bodyMedium),
                    ],
                    const SizedBox(height: 24),
                    Divider(
                      height: 32,
                      color: AppColors.darkShadowColor,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        NeuButton(
                          width: containerWidth * 0.4,
                          child: Text("Update Password"),
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
                                child: Text('Update'))
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
