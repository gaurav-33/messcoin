import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/models/coupon_model.dart';
import '../../core/widgets/neu_button.dart';
import '../../core/widgets/neu_container.dart';
import '../../config/app_colors.dart';
import '../../core/widgets/neu_loader.dart';
import '../../mess_admin/controllers/coupon_controller.dart';
import '../../utils/extensions.dart';
import '../../utils/responsive.dart';

class CouponView extends StatelessWidget {
  const CouponView({super.key});

  @override
  Widget build(BuildContext context) {
    final CouponController controller = Get.put(CouponController());

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: AppColors.bgColor,
          elevation: 0,
          toolbarHeight: 80,
          title: _buildHeader(context, controller),
          bottom: const TabBar(
            labelColor: AppColors.primaryColor,
            unselectedLabelColor: AppColors.darkShadowColor,
            indicatorColor: AppColors.primaryColor,
            dividerColor: Colors.transparent,
            indicatorWeight: 3.0,
            tabs: [
              Tab(icon: Icon(Icons.pending_actions), text: 'Pending'),
              Tab(icon: Icon(Icons.check_circle_outline), text: 'Approved'),
              Tab(icon: Icon(Icons.cancel_outlined), text: 'Rejected'),
            ],
          ),
        ),
        body: Obx(
          () => TabBarView(
            children: [
              _buildPaginatedList(context, controller, 'pending'),
              _buildPaginatedList(context, controller, 'approved'),
              _buildPaginatedList(context, controller, 'rejected'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, CouponController controller) {
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
        Text('Coupons', style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(width: 12),
        Obx(() => Row(
              children: [
                Icon(Icons.circle,
                    color: controller.isLive.value ? Colors.green : Colors.red,
                    size: 12),
                const SizedBox(width: 4),
                Text(
                  controller.isLive.value ? 'Live' : 'Offline',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color:
                            controller.isLive.value ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            )),
        const Spacer(),
        NeuButton(
          width: 40,
          height: 40,
          shape: BoxShape.circle,
          onTap: () => controller.fetchPendingCoupons(),
          child: Icon(Icons.refresh, color: AppColors.primaryColor),
        ),
      ],
    );
  }

  Widget _buildPaginatedList(
      BuildContext context, CouponController controller, String status) {
    final List<CouponModel> coupons;
    final bool isLoading;
    final int currentPage, totalPages;
    final Function(int) fetchPage;
    final RxBool hasAttemptedFetch;

    switch (status) {
      case 'approved':
        coupons = controller.approvedCoupons;
        isLoading = controller.isApprovedLoading.value;
        currentPage = controller.approvedCurrentPage;
        totalPages = controller.approvedTotalPages;
        fetchPage = (p) => controller.fetchApprovedCoupons(page: p);
        hasAttemptedFetch = controller.hasAttemptedInitialFetchApproved;
        break;
      case 'rejected':
        coupons = controller.rejectedCoupons;
        isLoading = controller.isRejectedLoading.value;
        currentPage = controller.rejectedCurrentPage;
        totalPages = controller.rejectedTotalPages;
        fetchPage = (p) => controller.fetchRejectedCoupons(page: p);
        hasAttemptedFetch = controller.hasAttemptedInitialFetchRejected;
        break;
      default: // 'pending'
        coupons = controller.pendingCoupons;
        isLoading = controller.isPendingLoading.value;
        currentPage = controller.pendingCurrentPage;
        totalPages = controller.pendingTotalPages;
        fetchPage = (p) => controller.fetchPendingCoupons(page: p);
        hasAttemptedFetch = true.obs; // Pending is always fetched on init
        break;
    }

    // FIX: Trigger initial fetch only once per tab.
    if (!hasAttemptedFetch.value) {
      hasAttemptedFetch.value =
          true; // Set flag immediately to prevent re-triggering
      fetchPage(1);
    }

    // Show a loader for the initial fetch or when changing pages
    if (isLoading) {
      return const Center(child: NeuLoader());
    }

    // Main content area
    Widget contentArea = coupons.isEmpty
        ? Center(
            child: Text(
              'No ${status.toCamelCase()} coupons found.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          )
        : Responsive.isDesktop(context)
            ? _buildCouponsDataTable(context, controller, coupons, status)
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: coupons.length,
                itemBuilder: (context, index) {
                  return _buildCouponCard(context, controller, coupons[index]);
                },
              );

    return Column(
      children: [
        Expanded(child: contentArea),

        // Pagination Controls
        if (totalPages > 1)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: SizedBox(
                child: Row(
              // Obx to rebuild buttons on state change
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Previous Button
                NeuButton(
                  onTap: (currentPage > 1 && !isLoading)
                      ? () => fetchPage(currentPage - 1)
                      : null, // Disable if on first page or loading
                  padding: const EdgeInsets.all(12),
                  shape: BoxShape.circle,
                  child: const Icon(Icons.arrow_back_ios_new, size: 18),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Text(
                    'Page $currentPage of $totalPages',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold, fontFamily: 'FiraCode'),
                  ),
                ),

                // Next Button
                NeuButton(
                  onTap: (currentPage < totalPages && !isLoading)
                      ? () => fetchPage(currentPage + 1)
                      : null, // Disable if on last page or loading
                  padding: const EdgeInsets.all(12),
                  shape: BoxShape.circle,
                  child: const Icon(Icons.arrow_forward_ios, size: 18),
                ),
              ],
            )),
          ),
      ],
    );
  }

  Widget _buildCouponCard(
      BuildContext context, CouponController controller, CouponModel coupon) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      behavior: HitTestBehavior.translucent,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: NeuContainer(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      coupon.studentData?.fullName.toCamelCase() ??
                          'Unknown Student',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '₹ ${coupon.amount.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'FiraCode',
                        ),
                  ),
                ],
              ),
              Text('Roll: ${coupon.studentData?.rollNo ?? 'N/A'}'),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Coupon ID', style: TextStyle(fontSize: 12)),
                        SelectableText(coupon.couponId,
                            style: const TextStyle(fontFamily: 'FiraCode')),
                      ],
                    ),
                  ),
                  if (coupon.status == 'pending')
                    _buildActionButtons(context, controller, coupon),
                ],
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'Requested: ${coupon.createdAt.toString().toKolkataTime()}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCouponsDataTable(BuildContext context,
      CouponController controller, List<CouponModel> coupons, String status) {
    return SingleChildScrollView(
      child: NeuContainer(
        margin: const EdgeInsets.all(16),
        child: DataTable(
          columns: [
            DataColumn(
                label: Expanded(
              child: Text(
                'Student Name',
              ),
            )),
            const DataColumn(label: Text('Roll No.')),
            const DataColumn(label: Text('Amount')),
            const DataColumn(label: Text('Coupon ID')),
            if (status == 'pending') const DataColumn(label: Text('Actions')),
          ],
          dataRowMinHeight: status == 'pending' ? 95 : 0,
          dataRowMaxHeight: status == 'pending' ? 95 : kMinInteractiveDimension,
          columnSpacing: 24,
          rows: coupons.map((coupon) {
            return DataRow(cells: [
              DataCell(
                  Text(coupon.studentData?.fullName.toCamelCase() ?? 'N/A')),
              DataCell(Text(coupon.studentData?.rollNo ?? 'N/A')),
              DataCell(Text('₹${coupon.amount.toStringAsFixed(2)}',
                  style: const TextStyle(fontFamily: 'FiraCode'))),
              DataCell(_buildClippedCouponId(coupon.couponId)),
              if (status == 'pending')
                DataCell(_buildTableActionButtons(context, controller, coupon)),
            ]);
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildClippedCouponId(String couponId) {
    const int maxLength = 10;
    final bool isLong = couponId.length > maxLength;
    final String displayText =
        isLong ? '${couponId.substring(0, maxLength)}...' : couponId;

    return Tooltip(
      message: couponId,
      child: Text(
        displayText,
        style: const TextStyle(fontFamily: 'FiraCode'),
      ),
    );
  }

  Widget _buildActionButtons(
      BuildContext context, CouponController controller, CouponModel coupon) {
    return Wrap(
      spacing: 12.0,
      runSpacing: 8.0,
      alignment: WrapAlignment.end,
      children: [
        NeuButton(
          shape: BoxShape.circle,
          width: 45,
          height: 45,
          onTap: () => controller.approveCoupon(coupon.id),
          child: const Icon(Icons.check, color: AppColors.success, size: 20),
        ),
        NeuButton(
          shape: BoxShape.circle,
          width: 45,
          height: 45,
          onTap: () => controller.rejectCoupon(coupon.id),
          child: const Icon(Icons.close, color: AppColors.error, size: 20),
        ),
      ],
    );
  }

  Widget _buildTableActionButtons(
      BuildContext context, CouponController controller, CouponModel coupon) {
    // Replaced Row with Wrap to prevent overflow
    return Wrap(
      spacing: 8.0, // Horizontal space between buttons
      runSpacing: 8.0, // Vertical space if buttons wrap
      children: [
        Tooltip(
          message: 'Approve',
          child: NeuButton(
            onTap: () => controller.approveCoupon(coupon.id),
            shape: BoxShape.circle,
            height: 35,
            width: 35,
            child: const Icon(Icons.check, color: AppColors.success, size: 20),
          ),
        ),
        Tooltip(
          message: 'Reject',
          child: NeuButton(
            onTap: () => controller.rejectCoupon(coupon.id),
            shape: BoxShape.circle,
            height: 35,
            width: 35,
            child: const Icon(Icons.close, color: AppColors.error, size: 20),
          ),
        ),
      ],
    );
  }
}
