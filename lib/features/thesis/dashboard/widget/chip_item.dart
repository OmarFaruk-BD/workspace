import 'package:flutter/material.dart';
import 'package:workspace/core/utils/app_colors.dart';

class ChipItem extends StatelessWidget {
  const ChipItem({
    super.key,
    this.onTap,
    required this.text,
    required this.isSelected,
  });
  final String text;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.grey.shade200,
            border:
                isSelected
                    ? Border(bottom: BorderSide(color: AppColors.red, width: 4))
                    : null,
          ),
          child: Text(
            text,
            style: TextStyle(
              color: isSelected ? AppColors.yellow : AppColors.grey,
            ),
          ),
        ),
      ),
    );
  }
}
