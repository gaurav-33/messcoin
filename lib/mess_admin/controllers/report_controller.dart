import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:messcoin/core/models/daily_summary_model.dart';
import 'package:messcoin/utils/app_snackbar.dart';
import 'package:open_file/open_file.dart';
import '../../core/services/bill_service.dart';
import '../../core/services/dashboard_service.dart';
import '../../../../core/models/monthly_summary_model.dart';
import '../../../../core/models/weekly_summary_model.dart';

// You can keep this enum as is.
enum ReportPeriod { daily, weekly, monthly }

enum DataViewType { graphical, numerical }

class ReportController extends GetxController {
  // --- STATE VARIABLES ---
  RxBool isLoading = false.obs;
  RxBool isExporting = false.obs;
  RxBool isExportingBill = false.obs;
  RxString error = ''.obs;
  Rx<ReportPeriod> reportPeriod = ReportPeriod.monthly.obs;

  // Summary models for the CURRENT period
  Rx<MonthlySummaryModel?> monthlySummary = Rx<MonthlySummaryModel?>(null);
  Rx<WeeklySummaryModel?> weeklySummary = Rx<WeeklySummaryModel?>(null);
  Rx<DailySummaryModel?> dailySummary = Rx<DailySummaryModel?>(null);

  // Historical data for the PREVIOUS 6 periods for the chart
  RxList<MonthlySummaryModel> monthlyHistory = <MonthlySummaryModel>[].obs;
  RxList<WeeklySummaryModel> weeklyHistory = <WeeklySummaryModel>[].obs;

  Rx<DataViewType> currentView = DataViewType.graphical.obs;
  // File path for exported files
  RxString lastExportedFilePath = ''.obs;

  Rx<DateTime> selectedDailyDate = DateTime.now().obs;
  Rx<DateTime> selectedExportMonth = DateTime.now().obs;
  @override
  void onInit() {
    super.onInit();
    fetchStats();
  }

  /// Toggles between Weekly and Monthly reports and refetches data.
  void togglePeriod(ReportPeriod period) {
    if (reportPeriod.value != period) {
      if (period == ReportPeriod.daily) {
        selectedDailyDate.value = DateTime.now();
      }
      reportPeriod.value = period;
      fetchStats();
    }
  }

  void toggleDataView(Set<DataViewType> newSelection) {
    if (newSelection.isNotEmpty) {
      currentView.value = newSelection.first;
    }
  }

  /// Fetches the summary for the current period and the history for the last 6 periods.
  Future<void> fetchStats() async {
    isLoading.value = true;
    error.value = '';
    try {
      final now = DateTime.now();

      // Clear previous data to prevent showing stale info
      monthlySummary.value = null;
      weeklySummary.value = null;
      dailySummary.value = null;

      monthlyHistory.clear();
      weeklyHistory.clear();

      if (reportPeriod.value == ReportPeriod.monthly) {
        // --- MONTHLY DATA ---
        // 1. Fetch current month's summary for the KPI cards
        final currentMonthRes = await DashboardService()
            .getMonthlyReport(DateFormat('yyyy-MM-dd').format(now));
        if (currentMonthRes.isSuccess) {
          monthlySummary.value =
              MonthlySummaryModel.fromJson(currentMonthRes.data['data']);
        }

        // 2. Fetch last 6 months' history for the line chart
        List<MonthlySummaryModel> months = [];
        for (int i = 5; i >= 0; i--) {
          // Loop from 5 down to 0 to get 6 periods
          final date = DateTime(now.year, now.month - i, 1);
          final dateStr = DateFormat('yyyy-MM-dd').format(date);
          final res = await DashboardService().getMonthlyReport(dateStr);
          if (res.isSuccess) {
            months.add(MonthlySummaryModel.fromJson(res.data['data']));
          }
        }
        monthlyHistory.value = months;
      } else if (reportPeriod.value == ReportPeriod.weekly) {
        // --- WEEKLY DATA ---
        // 1. Fetch current week's summary for the KPI cards
        final currentWeekRes = await DashboardService()
            .getWeeklyReport(DateFormat('yyyy-MM-dd').format(now));
        if (currentWeekRes.isSuccess) {
          weeklySummary.value =
              WeeklySummaryModel.fromJson(currentWeekRes.data['data']);
        }

        // 2. Fetch last 6 weeks' history for the line chart
        List<WeeklySummaryModel> weeks = [];
        for (int i = 5; i >= 0; i--) {
          // Loop from 5 down to 0 to get 6 periods
          final date = now.subtract(Duration(days: 7 * i));
          final dateStr = DateFormat('yyyy-MM-dd').format(date);
          final res = await DashboardService().getWeeklyReport(dateStr);
          if (res.isSuccess) {
            weeks.add(WeeklySummaryModel.fromJson(res.data['data']));
          }
        }
        weeklyHistory.value = weeks;
      } else {
        // Use selectedDailyDate instead of now
        final date = selectedDailyDate.value;
        final dailyResp = await DashboardService()
            .getDailyReport(DateFormat('yyyy-MM-dd').format(date));
        if (dailyResp.isSuccess) {
          dailySummary.value =
              DailySummaryModel.fromJson(dailyResp.data['data']);
        }
      }
    } catch (e) {
      error.value = 'Failed to fetch stats: $e';
    } finally {
      isLoading.value = false;
    }
  }

  void selectDailyDate(DateTime date) async {
    selectedDailyDate.value = date;
    await fetchStats();
  }

  /// Helper to get the current summary data map for the KPI cards.
  Map<String, num>? getCurrentSummary() {
    if (reportPeriod.value == ReportPeriod.daily &&
        dailySummary.value != null) {
      return dailySummary.value!.toMap();
    }
    if (reportPeriod.value == ReportPeriod.monthly &&
        monthlySummary.value != null) {
      return monthlySummary.value!.toMap();
    }
    if (reportPeriod.value == ReportPeriod.weekly &&
        weeklySummary.value != null) {
      return weeklySummary.value!.toMap();
    }
    // Return a default map with zeros if data is not available
    return {
      'transactionCount': 0,
      'transactionTotalAmount': 0.0,
      'couponCount': 0,
      'couponTotalAmount': 0.0,
      'feedbackCount': 0,
      'feedbackAvgRating': 0.0,
    };
  }

  /// Helper to get the formatted date label for the summary section.
  String getDateLabel() {
    if (reportPeriod.value == ReportPeriod.monthly &&
        monthlySummary.value != null) {
      return DateFormat('MMMM yyyy').format(monthlySummary.value!.startOfMonth
          .add(Duration(hours: 5, minutes: 30)));
    }
    if (reportPeriod.value == ReportPeriod.weekly &&
        weeklySummary.value != null) {
      final start = DateFormat('dd MMM').format(weeklySummary.value!.startOfWeek
          .add(Duration(hours: 5, minutes: 30)));
      final end = DateFormat('dd MMM, yyyy').format(
          weeklySummary.value!.endOfWeek.add(Duration(hours: 5, minutes: 30)));
      return "$start - $end";
    }
    if (reportPeriod.value == ReportPeriod.daily &&
        dailySummary.value != null) {
      return DateFormat('dd MMMM yyyy').format(
          dailySummary.value!.date.add(Duration(hours: 5, minutes: 30)));
    }
    return "Current Period";
  }

  Future<void> exportAsPdf(String date) async {
    isExporting.value = true;
    final resp = await DashboardService().downloadMonthlyPdfReport(date);
    if (resp.isSuccess && resp.data != null) {
      AppSnackbar.info('Opening PDF...');
      String filePath = resp.data;
      final result = await OpenFile.open(filePath);
      if (result.type == ResultType.done) {
        lastExportedFilePath.value = filePath;
      }
    }
    isExporting.value = false;
  }

  Future<void> exportAsExcel(String date) async {
    isExporting.value = true;
    final resp = await DashboardService().downloadMonthlyExcelReport(date);
    if (resp.isSuccess && resp.data != null) {
      AppSnackbar.info('Opening EXCEL...');
      String filePath = resp.data;
      final result = await OpenFile.open(filePath);
      if (result.type == ResultType.done) {
        lastExportedFilePath.value = filePath;
      }
    }
    isExporting.value = false;
  }

  Future<void> exportBillAsPdf(int month, int year) async {
    isExportingBill.value = true;
    final resp =
        await BillService().downloadMonthlyPdfBill(month: month, year: year);
    if (resp.isSuccess && resp.data != null) {
      AppSnackbar.info('Opening PDF...');
      String filePath = resp.data;
      final result = await OpenFile.open(filePath);
      if (result.type == ResultType.done) {
        lastExportedFilePath.value = filePath;
      }
    }
    isExportingBill.value = false;
  }

  Future<void> exportBillAsExcel(int month, int year) async {
    isExportingBill.value = true;
    final resp =
        await BillService().downloadMonthlyExcelBill(month: month, year: year);
    if (resp.isSuccess && resp.data != null) {
      AppSnackbar.info('Opening EXCEL...');
      String filePath = resp.data;
      final result = await OpenFile.open(filePath);
      if (result.type == ResultType.done) {
        lastExportedFilePath.value = filePath;
      }
    }
    isExportingBill.value = false;
  }
}
