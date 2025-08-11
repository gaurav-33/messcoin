import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/models/day_extra_menu_model.dart';
import '../../core/widgets/neu_button.dart';
import '../../core/widgets/neu_container.dart';
import '../../config/app_colors.dart';
import '../../core/widgets/neu_loader.dart';
import '../../utils/extensions.dart';
import '../../../../utils/responsive.dart';
import '../controllers/extra_menu_controller.dart';

class ExtraMenuView extends StatelessWidget {
  const ExtraMenuView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ExtraMenuController>();
    final theme = Theme.of(context);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double containerWidth = width;
    final bool isDesktop = Responsive.isDesktop(context);
    final bool isTablet = Responsive.isTablet(context);
    if (isDesktop) {
      containerWidth = 800;
    } else if (isTablet) {
      containerWidth = 700;
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Scaffold(
        body: SingleChildScrollView(
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
                  if (!isDesktop)
                    SizedBox(
                      width: 16,
                    ),
                  Text('Extra Menu',
                      style: Theme.of(context).textTheme.headlineMedium),
                ],
              ),
              SizedBox(
                height: height * 0.03,
              ),
              Obx(
                () => Center(
                  child: Wrap(
                    spacing: containerWidth * 0.03,
                    runSpacing: containerWidth * 0.03,
                    children: List.generate(controller.days.length, (i) {
                      final selected = controller.selectedDayIndex.value == i;
                      return NeuButton(
                        width: containerWidth * 0.1,
                        height: containerWidth * 0.1,
                        shape: BoxShape.circle,
                        onTap: () => controller.selectedDayIndex.value = i,
                        child: Text(
                          controller.days[i].substring(0, 3),
                          style: TextStyle(
                            color: selected
                                ? AppColors.primaryColor
                                : theme.textTheme.bodyMedium?.color,
                            fontWeight: selected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: NeuLoader());
                }
                if (controller.error.isNotEmpty) {
                  return Center(
                    child: Text(controller.error.value,
                        style: theme.textTheme.bodyLarge),
                  );
                }
                return _ExtraMenuList(
                  day: controller.days[controller.selectedDayIndex.value],
                  controller: controller,
                  containerWidth: containerWidth,
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class _ExtraMenuList extends StatelessWidget {
  final String day;
  final ExtraMenuController controller;
  final double containerWidth;
  const _ExtraMenuList(
      {required this.day,
      required this.controller,
      required this.containerWidth});

  @override
  Widget build(BuildContext context) {
    final menu = controller.getExtraMenuForDay(day);
    final theme = Theme.of(context);
    final mealMap = {
      'breakfast': menu?.breakfast ?? [],
      'lunch': menu?.lunch ?? [],
      'dinner': menu?.dinner ?? [],
    };
    return Column(
      children: [
        for (final meal in mealMap.keys)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Center(
              child: NeuContainer(
                width: containerWidth * 0.85,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(meal.capitalizeFirst!,
                            style: theme.textTheme.titleMedium),
                        IconButton(
                          icon: const Icon(Icons.add,
                              color: AppColors.primaryColor),
                          tooltip: 'Add item',
                          onPressed: () => _showAddEditDialog(
                              context, controller, day, meal),
                        ),
                      ],
                    ),
                    const Divider(
                      color: AppColors.darkShadowColor,
                    ),
                    if (mealMap[meal] == null || mealMap[meal]!.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child:
                            Text('No items', style: theme.textTheme.bodyMedium),
                      )
                    else
                      ...mealMap[meal]!
                          .map<Widget>((item) => _ExtraMenuItemTile(
                                day: day,
                                meal: meal,
                                item: item,
                                controller: controller,
                              )),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _ExtraMenuItemTile extends StatelessWidget {
  final String day;
  final String meal;
  final ExtraMeal item;
  final ExtraMenuController controller;
  const _ExtraMenuItemTile(
      {required this.day,
      required this.meal,
      required this.item,
      required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          Icon(Icons.circle, size: 8, color: AppColors.primaryColor),
          const SizedBox(width: 10),
          Expanded(
            child: Text(item.item.toCamelCase(),
                style: theme.textTheme.bodyMedium),
          ),
          Text(
            '₹${item.price}',
            style: theme.textTheme.bodyMedium
                ?.copyWith(color: AppColors.primaryColor),
          ),
          IconButton(
            icon: const Icon(Icons.edit, color: AppColors.dark),
            tooltip: 'Edit',
            onPressed: () =>
                _showAddEditDialog(context, controller, day, meal, item: item),
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Color(0xFFCD0909)),
            tooltip: 'Delete',
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Delete Item'),
                  content:
                      Text('Are you sure you want to delete \"${item.item}\"?'),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(ctx, false),
                        child: const Text('Cancel')),
                    TextButton(
                        onPressed: () => Navigator.pop(ctx, true),
                        child: const Text('Delete')),
                  ],
                ),
              );
              if (confirm == true) {
                controller.deleteExtraMenuItem(
                    day: day, meal: meal, item: item.item);
              }
            },
          ),
        ],
      ),
    );
  }
}

void _showAddEditDialog(BuildContext context, ExtraMenuController controller,
    String day, String meal,
    {ExtraMeal? item}) {
  final isEdit = item != null;
  final itemController = TextEditingController(text: item?.item ?? '');
  final priceController =
      TextEditingController(text: item?.price.toString() ?? '');
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(isEdit ? 'Edit Item' : 'Add Item'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: itemController,
            decoration: const InputDecoration(labelText: 'Item Name'),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: priceController,
            decoration: const InputDecoration(labelText: 'Price'),
            keyboardType: TextInputType.number,
          ),
        ],
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: () async {
            final name = itemController.text.trim();
            final price = int.tryParse(priceController.text.trim());
            if (name.isEmpty || price == null) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Please enter valid name and price')));
              return;
            }
            Navigator.pop(ctx);
            if (isEdit) {
              await controller.editExtraMenuItem(
                day: day,
                meal: meal,
                oldItem: item.item,
                newItem: name,
                price: price,
              );
            } else {
              await controller.addExtraMenuItem(
                day: day,
                meal: meal,
                item: name,
                price: price,
              );
            }
          },
          child: Text(isEdit ? 'Save' : 'Add'),
        ),
      ],
    ),
  );
}
