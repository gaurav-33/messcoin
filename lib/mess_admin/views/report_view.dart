import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:messcoin/core/models/daily_summary_model.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import '../../../../core/models/monthly_summary_model.dart';
import '../../../../core/models/weekly_summary_model.dart';
import '../../../../core/widgets/neu_button.dart';
import '../../../../core/widgets/neu_container.dart';
import '../../../../config/app_colors.dart';
import '../../../../core/widgets/neu_loader.dart';
import '../../../../mess_admin/controllers/report_controller.dart';
import '../../../../utils/responsive.dart';

class ReportView extends StatelessWidget {
  const ReportView({super.key});

  @override
  Widget build(BuildContext context) {
    final ReportController controller = Get.find<ReportController>();
    final isDesktop = Responsive.isDesktop(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isDesktop ? 48 : 16,
            vertical: 12,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: 24),
              _buildControlsHeader(context, controller),
              const SizedBox(height: 24),
              Obx(() {
                if (controller.isLoading.value) {
                  return const Center(
                      child: Padding(
                    padding: EdgeInsets.all(48.0),
                    child: NeuLoader(),
                  ));
                }
                if (controller.error.isNotEmpty) {
                  return Center(
                      child: Text(controller.error.value,
                          style: const TextStyle(color: Colors.red)));
                }
                // Main content
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildKpiGrid(context, controller),
                    const SizedBox(height: 32),
                    if (controller.reportPeriod.value == ReportPeriod.daily)
                      Obx(() => controller.dailySummary.value == null
                          ? const Center(
                              child: NeuContainer(
                              padding: EdgeInsets.all(32),
                              child: Text("No daily data to display."),
                            ))
                          : controller.currentView.value ==
                                  DataViewType.graphical
                              ? _buildDailyGraphicalSection(context, controller)
                              : _buildDailyNumericalSection(
                                  context, controller)),
                    if (controller.reportPeriod.value == ReportPeriod.weekly ||
                        controller.reportPeriod.value == ReportPeriod.monthly)
                      Obx(() {
                        final history = controller.reportPeriod.value ==
                                ReportPeriod.monthly
                            ? controller.monthlyHistory
                            : controller.weeklyHistory;
                        if (history.isEmpty) {
                          return const Center(
                              child: NeuContainer(
                            padding: EdgeInsets.all(32),
                            child: Text("No historical data to display."),
                          ));
                        }
                        if (controller.currentView.value ==
                            DataViewType.graphical) {
                          return _buildChartSection(context, controller);
                        } else {
                          return _buildNumericalDataSection(
                              context, controller);
                        }
                      }),
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  /// Header containing the title and menu button.
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
              child: const Icon(Icons.menu,),
            ),
          ),
        Text('Financial Reports',
            style: Theme.of(context).textTheme.headlineMedium),
      ],
    );
  }

  /// A header row with the period toggle, data view toggle, and export button.
  Widget _buildControlsHeader(
      BuildContext context, ReportController controller) {
      final theme = Theme.of(context);
    return NeuContainer(
      padding: const EdgeInsets.all(16),
      child: Wrap(
        spacing: 16,
        runSpacing: 16,
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          // Row for Toggles
          Wrap(
            spacing: 16,
            runSpacing: 16,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              // Period Toggle (Weekly/Monthly)
              Obx(() => SegmentedButton<ReportPeriod>(
                    showSelectedIcon: false,
                    style: SegmentedButton.styleFrom(
                      selectedForegroundColor: theme.colorScheme.surface,
                    ),
                    onSelectionChanged: (newSelection) {
                      controller.togglePeriod(newSelection.first);
                    },
                    segments: const [
                      ButtonSegment(
                          value: ReportPeriod.daily, label: Text('Daily')),
                      ButtonSegment(
                          value: ReportPeriod.weekly, label: Text('Weekly')),
                      ButtonSegment(
                          value: ReportPeriod.monthly, label: Text('Monthly')),
                    ],
                    selected: <ReportPeriod>{controller.reportPeriod.value},
                  )),

              Obx(() => SegmentedButton<DataViewType>(
                    showSelectedIcon: false,
                    style: SegmentedButton.styleFrom(
                      selectedForegroundColor: theme.colorScheme.surface
                    ),
                    onSelectionChanged: controller.toggleDataView,
                    segments: const [
                      ButtonSegment(
                        value: DataViewType.graphical,
                        label: Text('Graphical'),
                        icon: Icon(Icons.show_chart_rounded),
                      ),
                      ButtonSegment(
                        value: DataViewType.numerical,
                        label: Text('Numerical'),
                        icon: Icon(Icons.table_rows_rounded),
                      ),
                    ],
                    selected: <DataViewType>{controller.currentView.value},
                  )),
            ],
          ),
          Obx(
            () => controller.reportPeriod.value == ReportPeriod.daily
                ? GestureDetector(
                    onTap: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: controller.selectedDailyDate.value,
                        firstDate: DateTime(2020, 1),
                        lastDate: DateTime.now(),
                      );
                      if (picked != null) {
                        controller.selectDailyDate(picked);
                      }
                    },
                    child: NeuContainer(
                      width: Responsive.contentWidth(context) * 0.4,
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 14),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.calendar_today,
                              size: 18, color: AppColors.primaryColor),
                          const SizedBox(width: 8),
                          Obx(() => Text(
                                DateFormat('dd MMM, yyyy')
                                    .format(controller.selectedDailyDate.value),
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(color: AppColors.primaryColor),
                              )),
                        ],
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),

          // Export Menu Button
          _buildExportMenu(context, controller),
          _buildBillExportMenu(context, controller),

          Obx(() => controller.reportPeriod.value == ReportPeriod.monthly
              ? GestureDetector(
                  onTap: () async {
                    final picked = await showMonthPicker(
                      context: context,
                      initialDate: controller.selectedExportMonth.value,
                      firstDate: DateTime(2025, 1, 1),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) {
                      controller.selectedExportMonth.value = picked;
                    }
                  },
                  child: NeuContainer(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 14),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.calendar_month,
                            size: 18, color: AppColors.primaryColor),
                        const SizedBox(width: 8),
                        Obx(() => Text(
                              DateFormat('MMMM yyyy')
                                  .format(controller.selectedExportMonth.value),
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(color: AppColors.primaryColor),
                            )),
                      ],
                    ),
                  ),
                )
              : SizedBox.shrink()),
        ],
      ),
    );
  }

  Widget _buildDailyGraphicalSection(
      BuildContext context, ReportController controller) {
    final summary = controller.dailySummary.value;
    if (summary == null) {
      return const SizedBox.shrink();
    }

    // Grouped bar chart for 3 meals: breakfast, lunch, dinner
    final meals = ['breakfast', 'lunch', 'dinner'];
    final mealColors = {
      'breakfast': Colors.purple,
      'lunch': Colors.amber,
      'dinner': Colors.indigo,
    };

    // Each meal bar: Transaction count, Transaction Amount
    List<BarChartGroupData> barGroups = [];
    for (int i = 0; i < meals.length; i++) {
      final mealType = meals[i];
      final mealSummary = summary.mealWiseSummary
              .firstWhereOrNull((m) => m.mealType == mealType) ??
          MealSummaryModel(
              mealType: mealType,
              transactionCount: 0,
              transactionTotalAmount: 0);
      // NOTE: If you only want transactionTotalAmount graph, remove transactionCount below
      barGroups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: mealSummary.transactionTotalAmount,
              color: mealColors[mealType],
              width: 26,
            ),
          ],
          showingTooltipIndicators: [0],
        ),
      );
    }

    return _TrendChartContainer(
      title: "Meal-wise Collection (${controller.getDateLabel()})",
      legends: [
        _ChartLegend(color: mealColors['breakfast']!, text: "Breakfast"),
        _ChartLegend(color: mealColors['lunch']!, text: "Lunch"),
        _ChartLegend(color: mealColors['dinner']!, text: "Dinner"),
      ],
      chart: BarChart(
        BarChartData(
          maxY: barGroups
                  .map((e) => e.barRods[0].toY)
                  .fold<double>(0, (a, b) => b > a ? b : a) *
              1.25,
          minY: 0,
          barGroups: barGroups,
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) => Text(value.toStringAsFixed(0),
                    style:
                        const TextStyle(color: AppColors.dark, fontSize: 12)),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final ix = value.toInt();
                  if (ix >= 0 && ix < meals.length) {
                    return Text(meals[ix].capitalizeFirst!,
                        style: const TextStyle(
                            color: AppColors.dark,
                            fontWeight: FontWeight.bold));
                  } else {
                    return const SizedBox();
                  }
                },
              ),
            ),
            topTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: false),
          gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              getDrawingHorizontalLine: (v) =>
                  const FlLine(color: AppColors.lightDark, strokeWidth: 0.5)),
          barTouchData: BarTouchData(
            enabled: true,
            touchTooltipData: BarTouchTooltipData(
              getTooltipColor: (spot) => AppColors.neutralLight,
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                return BarTooltipItem(
                    meals[group.x].capitalizeFirst! +
                        '\n₹' +
                        rod.toY.toStringAsFixed(2),
                    TextStyle(
                      color: mealColors[meals[group.x]]!,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ));
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDailyNumericalSection(
      BuildContext context, ReportController controller) {
    final summary = controller.dailySummary.value;
    if (summary == null) return SizedBox();

    return _TrendChartContainer(
      title: 'Meal-wise Data (${controller.getDateLabel()})',
      legends: const [],
      chart: DataTable(
        columnSpacing: 24,
        headingRowColor:
            MaterialStateProperty.all(AppColors.primaryColor.withOpacity(0.1)),
        columns: [
          DataColumn(label: Text('Meal')),
          DataColumn(label: Text('Transactions'), numeric: true),
          DataColumn(label: Text('Amount'), numeric: true),
        ],
        rows: summary.mealWiseSummary
            .map((meal) => DataRow(cells: [
                  DataCell(Text(meal.mealType.capitalizeFirst!)),
                  DataCell(Text(meal.transactionCount.toString())),
                  DataCell(Text(
                      '₹${meal.transactionTotalAmount.toStringAsFixed(2)}')),
                ]))
            .toList(),
      ),
    );
  }

  Widget _buildNumericalDataSection(
      BuildContext context, ReportController controller) {
    final isMonthly = controller.reportPeriod.value == ReportPeriod.monthly;
    final history =
        isMonthly ? controller.monthlyHistory : controller.weeklyHistory;

    return _TrendChartContainer(
      // Re-using the container for consistent styling
      title: isMonthly ? 'Monthly Data History' : 'Weekly Data History',
      legends: const [], // No legends needed for the table
      chart: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columnSpacing: 24,
          headingRowColor: MaterialStateProperty.all(
              AppColors.primaryColor.withOpacity(0.1)),
          columns: [
            DataColumn(label: Text('Period')),
            DataColumn(label: Text('Transactions'), numeric: true),
            DataColumn(label: Text('Trans. Amount'), numeric: true),
            DataColumn(label: Text('Coupons'), numeric: true),
            DataColumn(label: Text('Coupon Amount'), numeric: true),
            DataColumn(label: Text('Feedbacks'), numeric: true),
            DataColumn(label: Text('Avg. Rating'), numeric: true),
          ],
          rows: List<DataRow>.generate(history.length, (index) {
            final item = history[index];
            String periodLabel;
            int transactionCount, couponCount, feedbackCount;
            double transactionAmount, couponAmount, avgRating;

            if (isMonthly) {
              final monthlyItem = item as MonthlySummaryModel;
              periodLabel = DateFormat('MMM yyyy').format(monthlyItem
                  .startOfMonth
                  .add(Duration(hours: 5, minutes: 30)));
              transactionCount = monthlyItem.transactionCount;
              transactionAmount = monthlyItem.transactionTotalAmount;
              couponCount = monthlyItem.couponCount;
              couponAmount = monthlyItem.couponTotalAmount;
              feedbackCount = monthlyItem.feedbackCount;
              avgRating = monthlyItem.feedbackAvgRating;
            } else {
              final weeklyItem = item as WeeklySummaryModel;
              final start = DateFormat('dd MMM').format(
                  weeklyItem.startOfWeek.add(Duration(hours: 5, minutes: 30)));
              final end = DateFormat('dd MMM').format(
                  weeklyItem.endOfWeek.add(Duration(hours: 5, minutes: 30)));
              periodLabel = '$start - $end';
              transactionCount = weeklyItem.transactionCount;
              transactionAmount = weeklyItem.transactionTotalAmount;
              couponCount = weeklyItem.couponCount;
              couponAmount = weeklyItem.couponTotalAmount;
              feedbackCount = weeklyItem.feedbackCount;
              avgRating = weeklyItem.feedbackAvgRating;
            }

            return DataRow(
              cells: [
                DataCell(Text(periodLabel,
                    style: const TextStyle(fontWeight: FontWeight.bold))),
                DataCell(Text(transactionCount.toString())),
                DataCell(Text('₹${transactionAmount.toStringAsFixed(2)}')),
                DataCell(Text(couponCount.toString())),
                DataCell(Text('₹${couponAmount.toStringAsFixed(2)}')),
                DataCell(Text(feedbackCount.toString())),
                DataCell(Text(avgRating.toStringAsFixed(2))),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _buildKpiGrid(BuildContext context, ReportController controller) {
    final summary = controller.getCurrentSummary();
    final dateLabel = controller.getDateLabel();

    // Define the list of KPI cards to avoid repetition
    final kpiCards = [
      _KpiCard(
        icon: Icons.receipt_long,
        title: 'Transactions',
        value: summary?['transactionCount']?.toString() ?? '0',
        color: Colors.blue,
      ),
      _KpiCard(
        icon: Icons.attach_money,
        title: 'Transaction Amount',
        value:
            '₹${summary?['transactionTotalAmount']?.toStringAsFixed(2) ?? '0.00'}',
        color: Colors.green,
      ),
      _KpiCard(
        icon: Icons.confirmation_number,
        title: 'Coupons Issued',
        value: summary?['couponCount']?.toString() ?? '0',
        color: Colors.orange,
      ),
      _KpiCard(
        icon: Icons.monetization_on,
        title: 'Coupon Amount',
        value:
            '₹${summary?['couponTotalAmount']?.toStringAsFixed(2) ?? '0.00'}',
        color: Colors.teal,
      ),
      _KpiCard(
        icon: Icons.feedback,
        title: 'Feedbacks',
        value: summary?['feedbackCount']?.toString() ?? '0',
        color: Colors.pinkAccent,
      ),
      _KpiCard(
        icon: Icons.star_half_rounded,
        title: 'Average Rating',
        value: summary?['feedbackAvgRating']?.toStringAsFixed(2) ?? '0.00',
        color: Colors.blueAccent,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Summary for: $dateLabel',
            style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 16),
        LayoutBuilder(builder: (context, constraints) {
          final int crossAxisCount;
          if (Responsive.isDesktop(context)) {
            crossAxisCount = 4;
          } else if (Responsive.isTablet(context)) {
            crossAxisCount = 4;
          } else {
            crossAxisCount = 2;
          }

          const double mainAxisSpacing = 16;
          const double crossAxisSpacing = 16;
          const double desiredCardHeight = 180;
          final double totalHorizontalSpacing =
              (crossAxisCount - 1) * crossAxisSpacing;
          final double cardWidth =
              (constraints.maxWidth - totalHorizontalSpacing) / crossAxisCount;

          final double childAspectRatio = cardWidth / desiredCardHeight;

          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              mainAxisSpacing: mainAxisSpacing,
              crossAxisSpacing: crossAxisSpacing,
              childAspectRatio: childAspectRatio,
            ),
            itemCount: kpiCards.length,
            itemBuilder: (context, index) => kpiCards[index],
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
          );
        }),
      ],
    );
  }

  /// Main container for all trend charts.
  Widget _buildChartSection(BuildContext context, ReportController controller) {
    final isMonthly = controller.reportPeriod.value == ReportPeriod.monthly;
    final history =
        isMonthly ? controller.monthlyHistory : controller.weeklyHistory;

    if (history.isEmpty) {
      return const SizedBox.shrink(); // Hide if no history
    }

    return Column(
      children: [
        _buildAmountChart(context, history, isMonthly),
        const SizedBox(height: 24),
        _buildCountChart(context, history, isMonthly),
        const SizedBox(height: 24),
        _buildRatingChart(context, history, isMonthly),
      ],
    );
  }

  /// Chart for financial amounts (transactions and coupons).
  Widget _buildAmountChart(BuildContext context, List history, bool isMonthly) {
    final List<FlSpot> transactionSpots = [];
    final List<FlSpot> couponSpots = [];
    double maxValue = 0.0;

    for (int i = 0; i < history.length; i++) {
      final item = history[i];
      final transactionAmount = (isMonthly
              ? (item as MonthlySummaryModel).transactionTotalAmount
              : (item as WeeklySummaryModel).transactionTotalAmount)
          .toDouble();
      final couponAmount = (isMonthly
              ? (item as MonthlySummaryModel).couponTotalAmount
              : (item as WeeklySummaryModel).couponTotalAmount)
          .toDouble();

      if (transactionAmount > maxValue) {
        maxValue = transactionAmount;
      }
      if (couponAmount > maxValue) {
        maxValue = couponAmount;
      }

      transactionSpots.add(FlSpot(i.toDouble(), transactionAmount));
      couponSpots.add(FlSpot(i.toDouble(), couponAmount));
    }

    return _TrendChartContainer(
      title: 'Financial Trends (Amount in ₹)',
      legends: const [
        _ChartLegend(color: Colors.green, text: 'Transactions'),
        _ChartLegend(color: Colors.teal, text: 'Coupons'),
      ],
      chart: LineChart(
        LineChartData(
          maxY: maxValue * 1.5, // Add 50% padding to the top
          lineBarsData: [
            _createLineBarData(transactionSpots, Colors.green),
            _createLineBarData(couponSpots, Colors.teal),
          ],
          titlesData: _getTitlesData(context, history, isMonthly, (value) {
            if (value >= 1000) return '${(value / 1000).toStringAsFixed(0)}k';
            return value.toStringAsFixed(0);
          }),
          // Common chart properties
          minY: 0,
          gridData: _getGridData(),
          borderData: FlBorderData(show: false),
          lineTouchData: _getLineTouchData(),
        ),
      ),
    );
  }

  /// Chart for activity counts (transactions, coupons, feedback).
  Widget _buildCountChart(BuildContext context, List history, bool isMonthly) {
    final List<FlSpot> transactionSpots = [];
    final List<FlSpot> couponSpots = [];
    final List<FlSpot> feedbackSpots = [];
    double maxValue = 0.0;

    for (int i = 0; i < history.length; i++) {
      final item = history[i];
      final transactionCount = (isMonthly
              ? (item as MonthlySummaryModel).transactionCount
              : (item as WeeklySummaryModel).transactionCount)
          .toDouble();
      final couponCount = (isMonthly
              ? (item as MonthlySummaryModel).couponCount
              : (item as WeeklySummaryModel).couponCount)
          .toDouble();
      final feedbackCount = (isMonthly
              ? (item as MonthlySummaryModel).feedbackCount
              : (item as WeeklySummaryModel).feedbackCount)
          .toDouble();

      if (transactionCount > maxValue) {
        maxValue = transactionCount;
      }
      if (couponCount > maxValue) {
        maxValue = couponCount;
      }
      if (feedbackCount > maxValue) {
        maxValue = feedbackCount;
      }

      transactionSpots.add(FlSpot(i.toDouble(), transactionCount));
      couponSpots.add(FlSpot(i.toDouble(), couponCount));
      feedbackSpots.add(FlSpot(i.toDouble(), feedbackCount));
    }

    return _TrendChartContainer(
      title: 'Activity Trends (Count)',
      legends: const [
        _ChartLegend(color: Colors.blue, text: 'Transactions'),
        _ChartLegend(color: Colors.orange, text: 'Coupons'),
        _ChartLegend(color: Colors.pinkAccent, text: 'Feedback'),
      ],
      chart: LineChart(
        LineChartData(
          maxY: maxValue * 1.25,
          lineBarsData: [
            _createLineBarData(transactionSpots, Colors.blue),
            _createLineBarData(couponSpots, Colors.orange),
            _createLineBarData(feedbackSpots, Colors.pinkAccent),
          ],
          titlesData: _getTitlesData(
              context, history, isMonthly, (value) => value.toStringAsFixed(0)),
          minY: 0,
          gridData: _getGridData(),
          borderData: FlBorderData(show: false),
          lineTouchData: _getLineTouchData(),
        ),
      ),
    );
  }

  /// Chart for average feedback rating.
  Widget _buildRatingChart(BuildContext context, List history, bool isMonthly) {
    final List<FlSpot> ratingSpots = [];
    for (int i = 0; i < history.length; i++) {
      final item = history[i];
      final rating = (isMonthly
              ? (item as MonthlySummaryModel).feedbackAvgRating
              : (item as WeeklySummaryModel).feedbackAvgRating)
          .toDouble();
      ratingSpots.add(FlSpot(i.toDouble(), rating));
    }

    return _TrendChartContainer(
      title: 'Average Rating Trend (out of 5)',
      legends: const [
        _ChartLegend(color: Colors.blueAccent, text: 'Avg. Rating'),
      ],
      chart: LineChart(
        LineChartData(
          maxY: 5, // Rating is out of 5
          lineBarsData: [
            _createLineBarData(ratingSpots, Colors.blueAccent),
          ],
          titlesData: _getTitlesData(
              context, history, isMonthly, (value) => value.toStringAsFixed(1)),
          minY: 0,
          gridData: _getGridData(),
          borderData: FlBorderData(show: false),
          lineTouchData: _getLineTouchData(),
        ),
      ),
    );
  }

  /// Helper to create a styled LineChartBarData object.
  LineChartBarData _createLineBarData(List<FlSpot> spots, Color color) {
    return LineChartBarData(
      spots: spots,
      isCurved: true,
      color: color,
      barWidth: 3,
      isStrokeCapRound: true,
      dotData: const FlDotData(show: false),
      belowBarData: BarAreaData(
        show: true,
        color: color.withOpacity(0.2),
      ),
    );
  }

  /// Helper to configure the titles for the X and Y axes.
  FlTitlesData _getTitlesData(BuildContext context, List history,
      bool isMonthly, String Function(double) formatLeftTitle) {
    return FlTitlesData(
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: (value, meta) {
            return SideTitleWidget(
              meta: meta,
              space: 10,
              child: Text(
                formatLeftTitle(value),
                style: const TextStyle(color: AppColors.dark, fontSize: 12),
              ),
            );
          },
          reservedSize: 40,
        ),
      ),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 30,
          interval: 1,
          getTitlesWidget: (value, meta) {
            final index = value.toInt();
            if (index < 0 || index >= history.length) return const SizedBox();

            final item = history[index];
            final String text = isMonthly
                ? DateFormat('MMM').format((item as MonthlySummaryModel)
                    .startOfMonth
                    .add(const Duration(hours: 5, minutes: 30)))
                : DateFormat('dd MMM').format((item as WeeklySummaryModel)
                    .endOfWeek
                    .add(const Duration(hours: 5, minutes: 30)));

            return SideTitleWidget(
              meta: meta,
              space: 10,
              child: Text(
                text,
                style: const TextStyle(
                  color: AppColors.dark,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            );
          },
        ),
      ),
      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
    );
  }

  /// Helper to configure the background grid.
  FlGridData _getGridData() {
    return FlGridData(
      show: true,
      drawVerticalLine: false,
      getDrawingHorizontalLine: (value) {
        return const FlLine(
          color: AppColors.lightDark,
          strokeWidth: 0.5,
        );
      },
    );
  }

  /// Helper to configure the tooltip that appears on touch.
  LineTouchData _getLineTouchData() {
    return LineTouchData(
      touchTooltipData: LineTouchTooltipData(
        getTooltipItems: (touchedSpots) {
          return touchedSpots.map((LineBarSpot touchedSpot) {
            final textStyle = TextStyle(
              color: touchedSpot.bar.color ?? Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            );
            return LineTooltipItem(
              '${touchedSpot.y.toStringAsFixed(2)} ',
              textStyle,
            );
          }).toList();
        },
        getTooltipColor: (spot) => AppColors.neutralLight,
        tooltipRoundedRadius: 8.0,
      ),
    );
  }

  Widget _buildExportMenu(BuildContext context, ReportController controller) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        if (value == 'pdf') {
          final selectedDate = controller.selectedExportMonth.value;
          final formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
          controller.exportAsPdf(formattedDate);
        } else if (value == 'excel') {
          final selectedDate = controller.selectedExportMonth.value;
          final formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
          controller.exportAsExcel(formattedDate);
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(
          value: 'pdf',
          child: Row(children: [
            Icon(Icons.picture_as_pdf_outlined, color: Colors.red),
            SizedBox(width: 8),
            Text('Export as PDF'),
          ]),
        ),
        const PopupMenuItem<String>(
          value: 'excel',
          child: Row(children: [
            Icon(Icons.grid_on_outlined, color: Colors.green),
            SizedBox(width: 8),
            Text('Export as Excel'),
          ]),
        ),
      ],
      child: Obx(
        () => NeuButton(
          width: Responsive.isMobile(context) ? double.infinity : 120,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.download_for_offline_outlined,
                  size: 20, color: AppColors.primaryColor),
              const SizedBox(width: 8),
              if (controller.isExporting.value) NeuLoader(),
              if (!controller.isExporting.value) const Text('Export'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBillExportMenu(
      BuildContext context, ReportController controller) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        if (value == 'pdf') {
          final selectedDate = controller.selectedExportMonth.value;
          final year = DateFormat('yyyy').format(selectedDate);
          final month = DateFormat('M').format(selectedDate);
          controller.exportBillAsPdf(int.parse(month), int.parse(year));
        } else if (value == 'excel') {
          final selectedDate = controller.selectedExportMonth.value;
          final year = DateFormat('yyyy').format(selectedDate);
          final month = DateFormat('M').format(selectedDate);
          controller.exportBillAsExcel(int.parse(month), int.parse(year));
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(
          value: 'pdf',
          child: Row(children: [
            Icon(Icons.picture_as_pdf_outlined, color: Colors.red),
            SizedBox(width: 8),
            Text('Export as PDF'),
          ]),
        ),
        const PopupMenuItem<String>(
          value: 'excel',
          child: Row(children: [
            Icon(Icons.grid_on_outlined, color: Colors.green),
            SizedBox(width: 8),
            Text('Export as Excel'),
          ]),
        ),
      ],
      child: Obx(
        () => NeuButton(
          width: Responsive.isMobile(context) ? double.infinity : 150,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.download_for_offline_outlined,
                  size: 20, color: AppColors.primaryColor),
              const SizedBox(width: 8),
              if (controller.isExportingBill.value) NeuLoader(),
              if (!controller.isExportingBill.value) const Text('Export Bill'),
            ],
          ),
        ),
      ),
    );
  }
}

/// A reusable container for a chart with a title and legend.
class _TrendChartContainer extends StatelessWidget {
  final String title;
  final List<_ChartLegend> legends;
  final Widget chart;

  const _TrendChartContainer({
    required this.title,
    required this.legends,
    required this.chart,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        if (legends.isNotEmpty) ...[
          const SizedBox(height: 8),
          // Legends
          Wrap(
            spacing: 16,
            runSpacing: 4,
            children: legends,
          ),
        ],
        const SizedBox(height: 16),
        // Chart or Table
        NeuContainer(
          padding: legends.isNotEmpty
              ? const EdgeInsets.only(
                  top: 24, right: 16, left: 8) // Padding for charts
              : const EdgeInsets.all(8), // Padding for table
          child: SizedBox(
            height: legends.isNotEmpty ? 250 : null, // Fixed height for charts
            width: double.infinity,
            child: chart,
          ),
        )
      ],
    );
  }
}

/// A simple legend widget for the charts.
class _ChartLegend extends StatelessWidget {
  final Color color;
  final String text;

  const _ChartLegend({required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          color: color,
        ),
        const SizedBox(width: 6),
        Text(text, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}

/// A styled card for displaying a Key Performance Indicator (KPI).
class _KpiCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color color;

  const _KpiCard(
      {required this.icon,
      required this.title,
      required this.value,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return NeuContainer(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: color.withOpacity(0.15),
            child: Icon(icon, color: color),
          ),
          const SizedBox(height: 12),
          // Flexible allows text to wrap and prevents overflow
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  value,
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
