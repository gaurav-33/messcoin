import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../core/models/leave_model.dart';
import '../../utils/extensions.dart';
import '../../../../config/app_colors.dart';
import '../../../../core/widgets/neu_button.dart';
import '../../../../core/widgets/neu_container.dart';
import '../../../../core/widgets/input_field.dart';
import '../../../../core/widgets/neu_loader.dart';
import '../../../../mess_admin/controllers/leave_controller.dart';
import '../../../../utils/responsive.dart';

class LeaveView extends StatelessWidget {
  const LeaveView({super.key});

  @override
  Widget build(BuildContext context) {
    final LeaveController controller = Get.find<LeaveController>();

    return Obx(() {
      final bool studentFound = controller.student.value != null;
      return DefaultTabController(
        length: studentFound ? 3 : 2,
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: AppColors.bgColor,
            elevation: 0,
            toolbarHeight: 80,
            title: _buildHeader(context),
            bottom: TabBar(
              labelColor: AppColors.primaryColor,
              unselectedLabelColor: AppColors.lightDark,
              indicatorColor: AppColors.primaryColor,
              dividerColor: Colors.transparent,
              indicatorWeight: 3.0,
              tabs: [
                const Tab(icon: Icon(Icons.edit_calendar), text: 'Grant Leave'),
                const Tab(icon: Icon(Icons.directions_run), text: 'Ongoing'),
                if (studentFound)
                  const Tab(icon: Icon(Icons.history), text: 'History'),
              ],
            ),
          ),
          body: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => FocusScope.of(context).unfocus,
            child: TabBarView(
              children: [
                _buildLeaveApplicationTab(context, controller),
                _buildOngoingLeavesTab(context, controller),
                if (studentFound) _buildStudentHistoryTab(context, controller),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildHeader(BuildContext context) {
    final bool isDesktop = Responsive.isDesktop(context);
    return Row(
      children: [
        if (!isDesktop)
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: NeuButton(
              onTap: () => Scaffold.of(context).openDrawer(),
              width: 45,
              child: const Icon(Icons.menu, color: AppColors.dark),
            ),
          ),
        Text('Leave Management',
            style: Theme.of(context).textTheme.headlineMedium),
      ],
    );
  }

  Widget _buildLeaveApplicationTab(
      BuildContext context, LeaveController controller) {
    final isDesktop = Responsive.isDesktop(context);
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isDesktop ? 48 : 16,
          vertical: 24,
        ),
        child: Column(
          children: [
            _buildSearchCard(context, controller),
            const SizedBox(height: 16),
            Obx(() {
              if (controller.isLoading.value &&
                  controller.student.value == null) {
                return const Center(
                    child: Padding(
                        padding: EdgeInsets.all(32.0), child: NeuLoader()));
              }
              if (controller.student.value == null) {
                return const _EmptyState();
              }
              return _buildLeaveApplicationCard(context, controller);
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildOngoingLeavesTab(
      BuildContext context, LeaveController controller) {
    final isDesktop = Responsive.isDesktop(context);
    return RefreshIndicator(
      onRefresh: () => controller.fetchOngoingLeaves(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isDesktop ? 48 : 16,
            vertical: 24,
          ),
          child: Obx(() {
            if (controller.isOngoingLoading.value &&
                controller.ongoingLeaves.isEmpty) {
              return const Center(child: NeuLoader());
            }
            if (controller.ongoingLeaves.isEmpty) {
              return const Center(child: Text("No ongoing leaves found."));
            }
            return _buildLeaveList(
              context,
              leaves: controller.ongoingLeaves,
              currentPage: controller.ongoingCurrentPage,
              totalPages: controller.ongoingTotalPages,
              onPageChanged: (page) =>
                  controller.fetchOngoingLeaves(page: page),
              isOngoingList: true,
            );
          }),
        ),
      ),
    );
  }

  Widget _buildStudentHistoryTab(
      BuildContext context, LeaveController controller) {
    final isDesktop = Responsive.isDesktop(context);
    return RefreshIndicator(
      onRefresh: () => controller.fetchStudentLeaves(
          studentId: controller.student.value!.id),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isDesktop ? 48 : 16,
            vertical: 24,
          ),
          child: Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: NeuLoader());
            }
            if (controller.studentLeaves.isEmpty) {
              return const Center(
                  child: Text("No leave history for this student."));
            }
            return _buildLeaveList(
              context,
              leaves: controller.studentLeaves,
              currentPage: controller.studentLeaveCurrentPage,
              totalPages: controller.studentLeaveTotalPages,
              onPageChanged: (page) => controller.fetchStudentLeaves(
                studentId: controller.student.value!.id,
                page: page,
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildSearchCard(BuildContext context, LeaveController controller) {
    return NeuContainer(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Search Student", style: Theme.of(context).textTheme.titleLarge),
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
                hintText: 'Enter roll number',
                keyboardType: TextInputType.number,
              ),
              NeuButton(
                width: Responsive.contentWidth(context) * 0.3,
                onTap: () => controller.clearAll(),
                child: const Text('Clear'),
              ),
              NeuButton(
                width: Responsive.contentWidth(context) * 0.3,
                onTap: () {
                  FocusScope.of(context).unfocus();
                  controller.searchByRoll();
                },
                child: const Text('Search'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLeaveApplicationCard(
      BuildContext context, LeaveController controller) {
    return NeuContainer(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            controller.student.value!.fullName.toCamelCase(),
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          _buildStudentDetailRow("Roll No", controller.student.value!.rollNo),
          const Divider(height: 32),
          Text('Grant New Leave',
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              _buildDatePickerButton(context, controller, isFromDate: true),
              _buildDatePickerButton(context, controller, isFromDate: false),
            ],
          ),
          const SizedBox(height: 16),
          InputField(
            width: Responsive.contentWidth(context) * 0.8,
            controller: controller.reasonController,
            label: 'Reason for Leave (Optional)',
            hintText: 'Enter a brief reason',
            maxLines: 3,
          ),
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.centerRight,
            child: Obx(
              () => NeuButton(
                onTap: controller.isCreatingLeave.value
                    ? null
                    : () => controller.createLeave(),
                width: 200,
                child: controller.isCreatingLeave.value
                    ? const NeuLoader()
                    : const Text('Grant Leave'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeaveList(
    BuildContext context, {
    required List<LeaveModel> leaves,
    required int currentPage,
    required int totalPages,
    required ValueChanged<int> onPageChanged,
    bool isOngoingList = false,
  }) {
    return Column(
      children: [
        ...leaves.map((leave) => _buildLeaveCard(
            context, Get.find<LeaveController>(), leave, isOngoingList)),
        if (totalPages > 1) ...[
          const Divider(height: 24),
          _buildPaginationControls(
              currentPage: currentPage,
              totalPages: totalPages,
              onPageChanged: onPageChanged,
              context: context),
        ]
      ],
    );
  }

  /// A styled card for displaying a single leave record with actions.
  Widget _buildLeaveCard(BuildContext context, LeaveController controller,
      LeaveModel leave, bool isOngoing) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: NeuContainer(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (isOngoing)
                          Text(
                              leave.studentData?.fullName.toCamelCase() ??
                                  "N/A",
                              style: Theme.of(context).textTheme.titleMedium),
                        if (!isOngoing)
                          Text("LEAVE ID: ${leave.id.substring(0, 8)}...",
                              style: Theme.of(context).textTheme.bodySmall),
                        if (isOngoing)
                          Text("Roll: ${leave.studentData?.rollNo ?? 'N/A'}",
                              style: Theme.of(context).textTheme.bodyMedium),
                      ],
                    ),
                  ),
                  // --- NEW: ACTION MENU ---

                  _buildActionMenu(context, controller, leave)
                ],
              ),
              const Divider(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _DateDisplay(label: "From", date: leave.startDate),
                  const Icon(Icons.arrow_forward,
                      color: AppColors.primaryColor),
                  _DateDisplay(label: "To", date: leave.endDate),
                ],
              ),
              if (leave.reason != null) ...[
                const SizedBox(height: 8),
                Text("Reason: ${leave.reason}",
                    style: Theme.of(context).textTheme.bodySmall),
              ],
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _StatusChip(status: leave.status),
                  Text('Applied: ${leave.createdAt.toString().toKolkataTime()}',
                      style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the three-dot menu for modifying or deleting a leave.
  Widget _buildActionMenu(
      BuildContext context, LeaveController controller, LeaveModel leave) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        if (value == 'modify') {
          controller.showUpdateLeaveDialog(context, leave);
        } else if (value == 'delete') {
          Get.defaultDialog(
            title: "Confirm Deletion",
            middleText: "Are you sure you want to delete this leave record?",
            textConfirm: "Delete",
            textCancel: "Cancel",
            confirmTextColor: Colors.white,
            onConfirm: () {
              Get.back(); // Close the dialog
              controller.deleteLeave(leave.id);
            },
          );
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(
          value: 'modify',
          child: Row(
            children: [
              Icon(Icons.edit_outlined, size: 20),
              SizedBox(width: 8),
              Text('Modify Dates'),
            ],
          ),
        ),
        const PopupMenuItem<String>(
          value: 'delete',
          child: Row(
            children: [
              Icon(Icons.delete_outline, color: Colors.red, size: 20),
              SizedBox(width: 8),
              Text('Delete Leave', style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
      ],
      child: const Icon(Icons.more_vert),
    );
  }

  Widget _buildPaginationControls({
    required int currentPage,
    required int totalPages,
    required ValueChanged<int> onPageChanged,
    required BuildContext context,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        NeuButton(
          shape: BoxShape.circle,
          onTap: currentPage > 1 ? () => onPageChanged(currentPage - 1) : null,
          child: const Icon(Icons.keyboard_arrow_left_rounded),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text('Page $currentPage of $totalPages',
              style: Theme.of(context).textTheme.bodyMedium),
        ),
        NeuButton(
          shape: BoxShape.circle,
          onTap: currentPage < totalPages
              ? () => onPageChanged(currentPage + 1)
              : null,
          child: const Icon(Icons.keyboard_arrow_right_rounded),
        ),
      ],
    );
  }

  Widget _buildDatePickerButton(
      BuildContext context, LeaveController controller,
      {required bool isFromDate}) {
    final dateValue =
        isFromDate ? controller.fromDate.value : controller.toDate.value;
    final text = isFromDate ? "From Date" : "To Date";
    final formattedDate =
        dateValue != null ? DateFormat('dd MMM yyyy').format(dateValue) : text;

    return NeuButton(
      width: 220,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: dateValue ?? DateTime.now(),
          firstDate: DateTime.now().subtract(const Duration(days: 30)),
          lastDate: DateTime.now().add(const Duration(days: 365)),
        );
        if (picked != null) {
          if (isFromDate) {
            controller.fromDate.value = picked;
          } else {
            controller.toDate.value = picked;
          }
        }
      },
      child: Row(
        children: [
          const Icon(Icons.calendar_today,
              size: 20, color: AppColors.primaryColor),
          const SizedBox(width: 12),
          Text(formattedDate),
        ],
      ),
    );
  }

  Widget _buildStudentDetailRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          Text("$label: ", style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value ?? 'N/A'),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String status;
  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    String label;
    IconData icon;

    switch (status) {
      case 'completed':
        color = AppColors.success;
        label = 'Completed';
        icon = Icons.check_circle;
        break;
      case 'ongoing':
        color = AppColors.warning;
        label = 'Ongoing';
        icon = Icons.timelapse;
        break;
      default: // pending
        color = AppColors.info;
        label = 'Pending';
        icon = Icons.hourglass_empty;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
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

class _DateDisplay extends StatelessWidget {
  final String label;
  final DateTime date;
  const _DateDisplay({required this.label, required this.date});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
        Text(
          DateFormat('dd MMM yyyy').format(date),
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

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
              'Enter a student\'s roll number to view their details and manage their leaves.',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
