import 'package:flutter/material.dart';
import 'package:workspace/core/utils/app_colors.dart';
import 'package:workspace/core/helper/navigation.dart';
import 'package:workspace/core/components/app_button.dart';
import 'package:workspace/core/components/app_snack_bar.dart';
import 'package:workspace/features/thesis/dashboard/screen/leave_apply.dart';
import 'package:workspace/features/thesis/dashboard/model/leave_request_model.dart';

class AvailableItem extends StatelessWidget {
  const AvailableItem({super.key, required this.day});
  final Day day;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: AppColors.grey,
        borderRadius: BorderRadius.circular(8),
        border: Border(bottom: BorderSide(color: AppColors.grey, width: 3)),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: day.available == '0' ? AppColors.yellow : AppColors.green,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  day.day ?? '',
                  style: TextStyle(
                    height: 0.8,
                    fontSize: 20,
                    color: AppColors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  day.weekday ?? '',
                  style: TextStyle(color: AppColors.white),
                ),
              ],
            ),
          ),
          SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  day.date ?? '',
                  style: TextStyle(
                    color: AppColors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Available: ${day.available ?? 0}',
                  style: TextStyle(
                    color:
                        day.available == '0' ? AppColors.red : AppColors.green,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 15),
          AppButton(
            text: 'Apply',
            vPadding: 8,
            textSize: 14,
            hPadding: 16,
            btnColor: day.available == '0' ? AppColors.grey : null,
            onTap: () {
              if (day.available == '0') {
                AppSnackBar.show(context, 'No leave available.');
                return;
              }
              AppNavigator.push(context, LeaveApplyPage());
            },
          ),
        ],
      ),
    );
  }
}
