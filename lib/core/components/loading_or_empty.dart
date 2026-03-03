import 'package:flutter/material.dart';
import 'package:workspace/core/utils/app_colors.dart';

class LoadingOrEmptyText extends StatelessWidget {
  const LoadingOrEmptyText({
    super.key,
    this.isEmpty = false,
    this.isLoading = false,
    this.emptyText = 'No record found.',
  });

  final bool isEmpty;
  final bool isLoading;
  final String emptyText;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15),
          child: CircularProgressIndicator(
            color: AppColors.primary,
            strokeWidth: 6,
          ),
        ),
      );
    } else if (isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Text(
            emptyText,
            style: const TextStyle(fontSize: 16, color: AppColors.red),
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }
}
