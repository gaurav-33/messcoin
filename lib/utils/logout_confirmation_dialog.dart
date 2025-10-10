
import 'package:flutter/material.dart';
import 'package:get/get.dart';

showLogoutConfirmationDialog(
    {required BuildContext context, required VoidCallback onConfirm}) {
  final theme = Theme.of(context);
  Get.defaultDialog(
    title: 'Logout',
    middleText: 'Are you sure you want to logout?',
    backgroundColor: theme.colorScheme.surface,
    titleStyle: theme.textTheme.bodyMedium,
    middleTextStyle: theme.textTheme.bodySmall,
    actions: [
      TextButton(
        onPressed: () => Get.back(),
        child: Text(
          'Cancel',
          style: theme.textTheme.bodySmall
        ),
      ),
      ElevatedButton(
        onPressed: onConfirm,
        style: ElevatedButton.styleFrom(
          // backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: const Text('Logout'),
      ),
    ],
  );
}
