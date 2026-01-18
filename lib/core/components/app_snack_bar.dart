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
    Color backgroundColor = AppColors.green,
  }) {
    final messenger = ScaffoldMessenger.of(context);

    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          backgroundColor: backgroundColor,
          margin: const EdgeInsets.all(12),
          padding: EdgeInsets.only(left: 15),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: duration),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          content: Row(
            children: [
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppColors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(width: 5),
              SnackBarAction(
                label: actionLabel ?? 'OK',
                textColor: Colors.white,
                onPressed: onAction ?? () => messenger.hideCurrentSnackBar(),
              ),
            ],
          ),
        ),
      );
  }

  static void success(BuildContext context, String message) {
    return show(context, message, duration: 3);
  }

  static void error(BuildContext context, String message) {
    return show(context, message, backgroundColor: AppColors.red, duration: 6);
  }
}
