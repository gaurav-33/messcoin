import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../config/app_colors.dart';
import '../../core/widgets/app_bar.dart';
import '../../core/widgets/neu_container.dart';
import '../../utils/extensions.dart';
import '../../../../core/models/student_model.dart';
import '../../../../core/widgets/input_field.dart';
import '../../../../core/widgets/neu_button.dart';
import '../../../../utils/responsive.dart';
import '../controllers/dashboard_controller.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final DashboardController controller = Get.find<DashboardController>();

    final showChangePassword = false.obs;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Obx(
              () => Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),
                  const NeuAppBar(toBack: true),
                  const SizedBox(height: 24),
                  _buildProfileCard(context, controller.student.value),
                  const SizedBox(height: 24),
                  _buildChangePasswordSection(
                      context, controller, showChangePassword),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context, StudentModel? studentModel) {
    return NeuContainer(
      width: Responsive.contentWidth(context),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _buildProfileHeader(context, studentModel),
          const SizedBox(height: 18),
          _buildStatusIndicators(context, studentModel),
          const SizedBox(height: 18),
          _buildWalletDetails(context, studentModel),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, StudentModel? studentModel) {
    return Column(
      children: [
        NeuContainer(
          shape: BoxShape.circle,
          padding: const EdgeInsets.all(8),
          child: CircleAvatar(
            radius: 60,
            backgroundColor: AppColors.bgColor,
            backgroundImage: studentModel?.imageUrl != ''
                ? NetworkImage(studentModel!.imageUrl)
                : AssetImage('assets/images/profile.png'),
          ),
        ),
        const SizedBox(height: 18),
        Text(
          studentModel?.fullName.toCamelCase() ?? 'Mess Coin User',
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .headlineMedium!
              .copyWith(color: AppColors.primaryColor),
        ),
        const SizedBox(height: 12),
        _buildInfoRow(context, 'Roll No:', studentModel?.rollNo ?? 'XXXXXX'),
        _buildInfoRow(context, 'Room No:', studentModel?.roomNo ?? 'XXXX'),
        _buildInfoRow(context, 'Email:', studentModel?.email ?? ''),
        _buildInfoRow(context, 'Hostel:',
            studentModel?.mess.hostel.toCamelCase() ?? 'NA'),
        _buildInfoRow(context, 'Semester:', '${studentModel?.semester}'),
        _buildInfoRow(
          context,
          'Mess:',
          studentModel?.mess.name.toCamelCase() ?? 'NA',
          isPrimary: true,
        ),
      ],
    );
  }

  Widget _buildInfoRow(BuildContext context, String title, String value,
      {bool isPrimary = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Text.rich(
        TextSpan(
          text: title,
          style: Theme.of(context)
              .textTheme
              .bodyLarge
              ?.copyWith(fontWeight: FontWeight.bold),
          children: [
            TextSpan(
              text: ' $value',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: isPrimary ? AppColors.primaryColor : null,
                    fontWeight: isPrimary ? FontWeight.bold : FontWeight.normal,
                  ),
            ),
          ],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildStatusIndicators(
      BuildContext context, StudentModel? studentModel) {
    final bool isVerified = studentModel?.isVerified ?? false;
    final bool isActive = studentModel?.isActive ?? false;

    return Row(
      children: [
        Expanded(
          child: NeuContainer(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                    isVerified
                        ? Icons.verified_user_outlined
                        : Icons.gpp_bad_outlined,
                    color: isVerified ? Colors.green : Colors.red,
                    size: 20),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    isVerified ? 'Verified' : 'Unverified',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: isVerified ? Colors.green : Colors.red),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: NeuContainer(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                    isActive
                        ? Icons.power_settings_new
                        : Icons.no_accounts_outlined,
                    color: isActive ? Colors.green : Colors.red,
                    size: 20),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    isActive ? 'Active' : 'Inactive',
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(color: isActive ? Colors.green : Colors.red),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWalletDetails(BuildContext context, StudentModel? studentModel) {
    return NeuContainer(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            'Wallet Summary',
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(color: AppColors.primaryColor),
          ),
          const SizedBox(height: 12),
          _buildWalletItem(
              context, 'Total Credit', studentModel?.wallet.totalCredit ?? 0),
          _buildWalletItem(
              context, 'Used Credit', studentModel?.wallet.loadedCredit ?? 0),
          _buildWalletItem(
              context,
              'Credit Left',
              (studentModel?.wallet.totalCredit.toInt() ?? 0) -
                  (studentModel?.wallet.loadedCredit.toInt() ?? 0)),
          _buildWalletItem(
              context, 'Balance', studentModel?.wallet.balance ?? 0),
          _buildWalletItem(context, 'Left Over Credit',
              studentModel?.wallet.leftOverCredit ?? 0),
        ],
      ),
    );
  }

  Widget _buildWalletItem(BuildContext context, String name, num value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('$name:', style: Theme.of(context).textTheme.bodyMedium),
          Text('₹$value', style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }

  Widget _buildChangePasswordSection(BuildContext context,
      DashboardController controller, RxBool showChangePassword) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: NeuButton(
                onTap: () =>
                    showChangePassword.value = !showChangePassword.value,
                child: Text(
                  showChangePassword.value ? "Cancel" : "Update Password",
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: showChangePassword.value
              ? Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: _buildChangePasswordForm(context, controller),
                )
              : const SizedBox(width: double.infinity),
        ),
      ],
    );
  }

  Widget _buildChangePasswordForm(
      BuildContext context, DashboardController controller) {
    final formWidth = Responsive.contentWidth(context);
    return NeuContainer(
      width: formWidth,
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          InputField(
            controller: controller.oldPasswordController,
            width: formWidth * 0.9,
            label: "Old Password",
            hintText: "Enter old password",
            obscure: true,
          ),
          InputField(
            controller: controller.newPasswordController,
            width: formWidth * 0.9,
            label: "New Password",
            hintText: "Enter new password",
            obscure: true,
          ),
          const SizedBox(height: 24),
          NeuButton(
            width: formWidth * 0.5,
            onTap: () => controller.changePassword(),
            child: const Text('Confirm Update'),
          ),
        ],
      ),
    );
  }
}
