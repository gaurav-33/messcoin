import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:messcoin/config/app_colors.dart';
import 'package:messcoin/core/models/employee_model.dart';
import 'package:messcoin/core/widgets/input_field.dart';
import 'package:messcoin/core/widgets/neu_button.dart';
import 'package:messcoin/core/widgets/neu_container.dart';
import 'package:messcoin/core/widgets/neu_loader.dart';
import 'package:messcoin/mess_admin/controllers/employee_management_controller.dart';
import 'package:messcoin/utils/extensions.dart';
import 'package:messcoin/utils/responsive.dart';

class EmployeeManagementView extends StatelessWidget {
  const EmployeeManagementView({super.key});

  @override
  Widget build(BuildContext context) {
    final EmployeeManagementController controller =
        Get.put(EmployeeManagementController());
    final bool isDesktop = Responsive.isDesktop(context);

    return Padding(
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
                      child: Icon(Icons.menu, size: 24)),
                ),
              if (!isDesktop) const SizedBox(width: 16),
              Text('Employee Management',
                  style: Theme.of(context).textTheme.headlineMedium),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              NeuButton(
                width: Responsive.contentWidth(context) * 0.4,
                onTap: () {
                  controller.clearForm();
                  _showAddEmployeeDialog(context, controller);
                },
                child: const Text('Add Employee'),
              ),
              const SizedBox(width: 8),
              NeuButton(
                width: 40,
                height: 40,
                shape: BoxShape.circle,
                onTap: () => controller.fetchEmployees(),
                child: Icon(Icons.refresh, color: AppColors.primaryColor),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: NeuLoader());
              }
              if (controller.employees.isEmpty) {
                return const Center(
                  child: Text('No employees found.'),
                );
              }
              return ListView.builder(
                itemCount: controller.employees.length,
                itemBuilder: (context, index) {
                  final employee = controller.employees[index];
                  return _buildEmployeeTile(context, employee, controller);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildEmployeeTile(BuildContext context, EmployeeModel employee,
      EmployeeManagementController controller) {
    return NeuContainer(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            employee.fullName.toCamelCase(),
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 4),
          Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  employee.phone,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                if (controller.employeePasswords.containsKey(employee.id))
                  Text(controller.employeePasswords[employee.id]!)
                else
                  const Text('********'),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              NeuButton(
                  width: 40,
                  height: 40,
                  shape: BoxShape.circle,
                  onTap: () => _showDeleteConfirmationDialog(
                      context, controller, employee.id),
                  child: Icon(Icons.delete)),
              const SizedBox(width: 16),
              Obx(() => controller.isGeneratingPassword.value
                  ? const NeuLoader(
                      size: 25,
                    )
                  : NeuButton(
                      width: 40,
                      height: 40,
                      shape: BoxShape.circle,
                      onTap: () => controller.generateNewPassword(employee.id),
                      child: controller.isGeneratingPassword.value
                          ? const NeuLoader(
                              size: 25,
                            )
                          : Icon(Icons.lock_outline_rounded)))
            ],
          ),
        ],
      ),
    );
  }

  void _showAddEmployeeDialog(
      BuildContext context, EmployeeManagementController controller) {
    Get.dialog(
      AlertDialog(
        backgroundColor: AppColors.bgColor,
        title: Text(
          'Add New Employee',
          style: Theme.of(context).textTheme.headlineMedium,
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InputField(
              width: Responsive.contentWidth(context),
              controller: controller.nameController,
              label: 'Name',
              hintText: 'Enter employee name',
            ),
            const SizedBox(height: 16),
            InputField(
              width: Responsive.contentWidth(context),
              controller: controller.phoneController,
              label: 'Phone Number',
              hintText: 'Enter employee Phone No.',
              keyboardType: TextInputType.emailAddress,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          Obx(
            () => ElevatedButton(
              onPressed: controller.isLoading.value
                  ? null
                  : () => controller.addEmployee(),
              child: controller.isLoading.value
                  ? const NeuLoader()
                  : const Text('Add'),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context,
      EmployeeManagementController controller, String employeeId) {
    Get.dialog(
      AlertDialog(
        backgroundColor: AppColors.bgColor,
        title: Text(
          'Confirm Deletion',
          style: Theme.of(context).textTheme.headlineMedium,
          textAlign: TextAlign.center,
        ),
        content: const Text('Are you sure you want to delete this employee?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              controller.deleteEmployee(employeeId);
              Get.back();
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
