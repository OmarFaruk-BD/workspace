import 'package:flutter/material.dart';
import 'package:workspace/core/utils/app_colors.dart';

class AppSnackBar {
  const AppSnackBar._();

  static void show(
    BuildContext context,
    String message, {
    int duration = 4,
    String? actionLabel,
    VoidCallback? onAction,
    Color bgColor = AppColors.green,
  }) {
    final messenger = ScaffoldMessenger.of(context);

    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          persist: false,
          backgroundColor: bgColor,
          margin: const EdgeInsets.all(12),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: duration),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          content: Text(
            message,
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          action: SnackBarAction(
            label: actionLabel ?? 'OK',
            textColor: AppColors.white,
            onPressed: onAction ?? () => messenger.hideCurrentSnackBar(),
          ),
        ),
      );
  }

  static void success(BuildContext context, String message) {
    show(context, message, bgColor: AppColors.green, duration: 3);
  }

  static void error(BuildContext context, String message) {
    show(context, message, bgColor: AppColors.red, duration: 6);
  }
}
