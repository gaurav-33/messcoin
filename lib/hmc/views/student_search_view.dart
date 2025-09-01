import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:messcoin/core/widgets/app_bar.dart';
import 'package:messcoin/hmc/controllers/hmc_student_search_controller.dart';
import 'package:messcoin/utils/extensions.dart';
import '../../config/app_colors.dart';
import '../../core/models/student_model.dart';
import '../../core/widgets/input_field.dart';
import '../../core/widgets/neu_button.dart';
import '../../core/widgets/neu_container.dart';
import '../../core/widgets/neu_loader.dart';
import '../../utils/responsive.dart';
import '../../utils/show_image_dialog.dart';

class StudentSearchView extends StatelessWidget {
  const StudentSearchView({super.key});

  @override
  Widget build(BuildContext context) {
    final StudentSearchController controller =
        Get.find<StudentSearchController>();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                const SizedBox(height: 24),
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: FocusScope.of(context).unfocus,
                  child: Column(
                    children: [
                      _buildSearchCard(context, controller),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: FocusScope.of(context).unfocus,
                  child: Obx(() {
                    if (controller.isLoading.value &&
                        controller.student.value == null) {
                      return const Center(
                          child: Padding(
                              padding: EdgeInsets.all(32.0),
                              child: NeuLoader()));
                    }
                    if (controller.student.value == null) {
                      return const _EmptyState();
                    }
                    // When a student is found, show their details and the new card
                    return Responsive.isMobile(context)
                        ? Column(
                            children: [
                              _buildProfileCard(
                                  context, controller.student.value!),
                              const SizedBox(height: 16),
                              _buildWalletCard(
                                  context, controller.student.value!),
                              const SizedBox(height: 16),
                            ],
                          )
                        : Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: _buildProfileCard(
                                        context, controller.student.value!),
                                  ),
                                  const SizedBox(width: 24),
                                  Expanded(
                                    flex: 1,
                                    // Wrap wallet and coupon cards in a Column
                                    child: Column(
                                      children: [
                                        _buildWalletCard(
                                            context, controller.student.value!),
                                        // const SizedBox(height: 24),
                                        // _buildAddCouponCard(
                                        //     context, controller),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Header containing the title and menu button.
  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        NeuAppBar(
          toBack: true,
        ),
        const SizedBox(height: 24),
        Text('Student Information',
            style: Theme.of(context).textTheme.headlineMedium),
      ],
    );
  }

  /// A card containing the student search functionality.
  Widget _buildSearchCard(
      BuildContext context, StudentSearchController controller) {
    return NeuContainer(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Find Student by Roll Number",
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            crossAxisAlignment: WrapCrossAlignment.end,
            children: [
              InputField(
                controller: controller.rollController,
                width: 300,
                label: 'Student Roll No.',
                hintText: 'Enter student roll number',
              ),
              NeuButton(
                onTap: () {
                  controller.rollController.clear();
                  controller.student.value = null;
                },
                width: Responsive.contentWidth(context) * 0.3,
                child: const Text('Clear'),
              ),
              NeuButton(
                onTap: controller.searchByRoll,
                width: Responsive.contentWidth(context) * 0.3,
                child: const Text('Search'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// A detailed card displaying the student's profile information.
  Widget _buildProfileCard(BuildContext context, StudentModel student) {
    return NeuContainer(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProfileHeader(context, student),
          const Divider(height: 32),
          _buildDetailSection(title: "Contact Information", children: [
            _buildDetailRow("Email:", student.email),
          ]),
          const SizedBox(height: 16),
          _buildDetailSection(title: "Academic Details", children: [
            _buildDetailRow("Roll No:", student.rollNo),
            _buildDetailRow("Room No:", student.roomNo),
            _buildDetailRow("Hostel:", student.mess.hostel.toCamelCase()),
            _buildDetailRow("Semester:", student.semester.toString()),
          ]),
        ],
      ),
    );
  }

  /// The header section of the profile card.
  Widget _buildProfileHeader(BuildContext context, StudentModel student) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 80,
          height: 80,
          child: GestureDetector(
            onTap: () => showImageDialog(context, student.imageUrl),
            child: ClipOval(
              child: FadeInImage(
                image: NetworkImage(student.imageUrl),
                placeholder: AssetImage('assets/images/profile.png'),
                fit: BoxFit.cover,
                imageErrorBuilder: (context, error, stackTrace) => Image.asset(
                  'assets/images/profile.png',
                  fit: BoxFit.cover,
                  width: 80,
                  height: 80,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                student.fullName.toCamelCase(),
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 4),
              Text(
                'Mess: ${student.mess.name.toCamelCase()}',
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(color: AppColors.primaryColor),
              ),
              const SizedBox(height: 8),
              _StatusChips(
                  isVerified: student.isVerified, isActive: student.isActive),
            ],
          ),
        ),
      ],
    );
  }

  /// A generic section with a title and list of detail rows.
  Widget _buildDetailSection(
      {required String title, required List<Widget> children}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        ...children,
      ],
    );
  }

  /// A simple row for displaying a label and a value.
  Widget _buildDetailRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("$label ", style: const TextStyle(fontWeight: FontWeight.w500)),
          Expanded(child: Text(value ?? 'N/A')),
        ],
      ),
    );
  }

  /// A card dedicated to showing the student's wallet balance.
  Widget _buildWalletCard(BuildContext context, StudentModel student) {
    return NeuContainer(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Wallet Details",
              style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 16),
          _buildWalletItem("Current Balance", student.wallet.balance,
              isLarge: true),
          const Divider(height: 24),
          _buildWalletItem("Total Credit", student.wallet.totalCredit),
          _buildWalletItem("Used Credit", student.wallet.loadedCredit),
          _buildWalletItem("Credit Left",
              (student.wallet.totalCredit - student.wallet.loadedCredit)),
          _buildWalletItem("Left Over Credit", student.wallet.leftOverCredit),
        ],
      ),
    );
  }

  Widget _buildWalletItem(String name, num value, {bool isLarge = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(name,
                style: TextStyle(
                    fontSize: isLarge ? 18 : 16,
                    fontWeight: isLarge ? FontWeight.bold : FontWeight.normal)),
          ),
          Text(
            '₹${value.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: isLarge ? 20 : 16,
              color: isLarge ? AppColors.primaryColor : AppColors.dark,
              fontWeight: FontWeight.bold,
              fontFamily: 'FiraCode',
            ),
          ),
        ],
      ),
    );
  }
}

/// A custom widget for displaying the student's status (verified/active).
class _StatusChips extends StatelessWidget {
  final bool isVerified;
  final bool isActive;

  const _StatusChips({required this.isVerified, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: [
        _StatusChip(
          label: isVerified ? 'Verified' : 'Unverified',
          color: isVerified ? AppColors.success : AppColors.error,
          icon: isVerified ? Icons.check_circle : Icons.error_outline,
        ),
        _StatusChip(
          label: isActive ? 'Active' : 'Inactive',
          color: isActive ? AppColors.success : AppColors.error,
          icon: isActive ? Icons.power_settings_new : Icons.block,
        ),
      ],
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String label;
  final Color color;
  final IconData icon;

  const _StatusChip(
      {required this.label, required this.color, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 6),
          Text(label,
              style: TextStyle(color: color, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

/// A placeholder widget shown when no student is searched.
class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 48.0, horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person_search, size: 80, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text('Search for a Student',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(
              'Enter a student\'s roll number to view their profile and wallet information.',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
