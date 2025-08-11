import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../config/app_colors.dart';
import '../../core/models/day_extra_menu_model.dart';
import '../../core/widgets/app_bar.dart';
import '../../core/widgets/neu_button.dart';
import '../../core/widgets/neu_container.dart';
import '../../core/widgets/neu_loader.dart';
import '../../utils/extensions.dart';
import '../../../../utils/responsive.dart';
import '../controllers/menu_controller.dart';

class MenuView extends StatelessWidget {
  const MenuView({super.key});

  @override
  Widget build(BuildContext context) {
    final MessMenuController controller =
        Get.find<MessMenuController>();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                const NeuAppBar(toBack: true),
                const SizedBox(height: 24),
                // Mess Name Header
                Container(
                  width: Responsive.contentWidth(context),
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    controller.messName?.toCamelCase() ?? 'Mess Coin',
                    style: Theme.of(context).textTheme.headlineMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 24),
                // Day Selector Buttons
                _buildDaySelector(context, controller),
                const SizedBox(height: 24),
                // Combined Menu Details
                _buildMenuDetails(context, controller),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDaySelector(
      BuildContext context, MessMenuController controller) {
    return Obx(
      () => SizedBox(
        width: Responsive.contentWidth(context),
        child: Wrap(
          alignment: WrapAlignment.center,
          spacing: 12.0,
          runSpacing: 12.0,
          children: List.generate(controller.days.length, (index) {
            final isSelected = index == controller.selectedDayIndex.value;
            return NeuButton(
              width: 45,
              height: 45,
              shape: BoxShape.circle,
              onTap: (){
                controller.selectedDayIndex.value = index;
                controller.fetchMenuForDay(controller.days[index]);
                },
              child: Text(
                controller.days[index].substring(0, 3),
                style: TextStyle(
                  color: isSelected ? AppColors.primaryColor : null,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildMenuDetails(
      BuildContext context, MessMenuController controller) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: NeuLoader());
      }
      final dayName = controller.days[controller.selectedDayIndex.value];
      final regularMenu = controller.getMenuForDay(dayName);
      final extraMenu = controller.getExtraMenuForDay(dayName);

      final bool hasAnyMenu = regularMenu != null || extraMenu != null;

      return Container(
        width: Responsive.contentWidth(context),
        padding: const EdgeInsets.all(16),
        child: !hasAnyMenu
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text('No menu available for $dayName'),
                ),
              )
            : Column(
                children: [
                  Text('Mess Menu',
                      style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 16),
                  _buildMealSection(context, 'Breakfast',
                      regularMenu?.breakfast?.items, extraMenu?.breakfast),
                  _buildMealSection(context, 'Lunch', regularMenu?.lunch?.items,
                      extraMenu?.lunch),
                  _buildMealSection(
                      context,
                      'Snacks',
                      regularMenu?.snacks?.items,
                      null), // Assuming no extra snacks
                  _buildMealSection(context, 'Dinner',
                      regularMenu?.dinner?.items, extraMenu?.dinner),
                ],
              ),
      );
    });
  }

  // This is the key updated widget.
  // It now takes both regular and extra items and displays them together.
  Widget _buildMealSection(BuildContext context, String meal,
      List<String>? regularItems, List<ExtraMeal>? extraItems) {
    final bool hasRegular = regularItems != null && regularItems.isNotEmpty;
    final bool hasExtra = extraItems != null && extraItems.isNotEmpty;

    if (!hasRegular && !hasExtra) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: NeuContainer(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(meal, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            // Display regular items if they exist
            if (hasRegular)
              ...regularItems.map(
                (item) => _buildMenuItem(context, item),
              ),
            // Display a separator and extra items if they exist
            if (hasRegular && hasExtra) ...[
              const Divider(
                height: 24,
                color: AppColors.darkShadowColor,
              ),
              Text('Paid Extras',
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(color: AppColors.primaryColor)),
              const SizedBox(height: 8),
            ],
            if (hasExtra)
              ...extraItems.map(
                (item) => _buildMenuItem(context, item.item, price: item.price),
              ),
          ],
        ),
      ),
    );
  }

  // A flexible helper to build a row for a menu item (with or without price).
  Widget _buildMenuItem(BuildContext context, String item, {num? price}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Icon(Icons.circle, size: 8, color: AppColors.primaryColor),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(item.toCamelCase(),
                style: Theme.of(context).textTheme.bodyMedium),
          ),
          if (price != null) ...[
            const SizedBox(width: 10),
            Text(
              '₹$price',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: AppColors.primaryColor),
            ),
          ]
        ],
      ),
    );
  }
}
