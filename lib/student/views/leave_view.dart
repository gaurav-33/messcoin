import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../config/app_colors.dart';
import '../../core/models/leave_model.dart';
import '../../core/widgets/app_bar.dart';
import '../../core/widgets/neu_button.dart';
import '../../core/widgets/neu_container.dart';
import '../../core/widgets/neu_loader.dart';
import '../../student/controllers/leave_controller.dart';
import '../../utils/extensions.dart';
import '../../../../utils/responsive.dart';

class LeaveView extends StatelessWidget {
  const LeaveView({super.key});

  @override
  Widget build(BuildContext context) {
    final LeaveController controller = Get.put(LeaveController());
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  SizedBox(height: 10),
                  NeuAppBar(toBack: true),
                  SizedBox(height: 24),
                ],
              ),
            ),
            Text('Leave History', style: textTheme.headlineMedium),
            const SizedBox(height: 16),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value && controller.leaves.isEmpty) {
                  return const Center(child: NeuLoader());
                }
                if (controller.leaves.isEmpty) {
                  return const Center(child: Text('No Leave History Found'));
                }

                return Center(
                  child: SizedBox(
                    width: Responsive.contentWidth(context),
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            itemCount: controller.leaves.length,
                            itemBuilder: (context, index) {
                              final leave = controller.leaves[index];
                              return _buildLeaveTimelineItem(context, leave);
                            },
                          ),
                        ),
                        if (controller.studentLeaveTotalPages > 1)
                          _buildPaginationControls(context, controller),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeaveTimelineItem(BuildContext context, LeaveModel leave) {
    final Color statusColor = _getStatusColor(leave.status);
    final String statusLabel = _getStatusLabel(leave.status);
    final IconData statusIcon = _getStatusIcon(leave.status);
    final textTheme = Theme.of(context).textTheme;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildTimelineMarker(context),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 16.0, left: 16.0, right: 16.0, bottom: 8.0),
              child: NeuContainer(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            '${DateFormat('dd MMM').format(leave.startDate)} - ${DateFormat('dd MMM yyyy').format(leave.endDate)}',
                            style: textTheme.titleMedium,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(statusIcon, color: statusColor, size: 14),
                              const SizedBox(width: 4),
                              Text(
                                statusLabel,
                                style: textTheme.bodySmall?.copyWith(
                                    color: statusColor,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Applied: ${leave.createdAt.toString().toKolkataTime()}',
                      style: textTheme.bodySmall
                          ?.copyWith(color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineMarker(BuildContext context) {
    return SizedBox(
      width: 20,
      child: Column(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Container(
              width: 2,
              color: AppColors.primaryColor.withOpacity(0.3),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaginationControls(
      BuildContext context, LeaveController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          NeuButton(
            shape: BoxShape.circle,
            onTap: controller.studentLeaveCurrentPage > 1
                ? () => controller.fetchLeaves(
                    studentId: '',
                    page: controller.studentLeaveCurrentPage - 1,
                    limit: controller.studentLeavePageSize)
                : null,
            child:
                Icon(Icons.keyboard_arrow_left_rounded, color: AppColors.dark),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: Text(
              'Page ${controller.studentLeaveCurrentPage} of ${controller.studentLeaveTotalPages}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          NeuButton(
            shape: BoxShape.circle,
            onTap: controller.studentLeaveCurrentPage <
                    controller.studentLeaveTotalPages
                ? () => controller.fetchLeaves(
                    studentId: '',
                    page: controller.studentLeaveCurrentPage + 1,
                    limit: controller.studentLeavePageSize)
                : null,
            child:
                Icon(Icons.keyboard_arrow_right_rounded, color: AppColors.dark),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'completed':
        return Colors.green;
      case 'ongoing':
        return Colors.orange;
      case 'pending':
      default:
        return Colors.blue;
    }
  }

  String _getStatusLabel(String status) {
    return status.toUpperCase();
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'completed':
        return Icons.check_circle;
      case 'ongoing':
        return Icons.timelapse;
      case 'pending':
      default:
        return Icons.hourglass_empty;
    }
  }
}
