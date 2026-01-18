import 'package:flutter/material.dart';
import 'package:workspace/core/utils/app_colors.dart';

class DateItem extends StatelessWidget {
  const DateItem({
    super.key,
    required this.day,
    required this.color,
    required this.dayName,
    required this.punchIn,
    required this.punchOut,
    required this.totalTime,
  });
  final Color color;
  final String day;
  final String dayName;
  final String punchIn;
  final String punchOut;
  final String totalTime;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: AppColors.grey.withAlpha(30),
        borderRadius: BorderRadius.circular(8),
        border: Border(bottom: BorderSide(color: AppColors.grey, width: 3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  day,
                  style: TextStyle(
                    height: 0.8,
                    fontSize: 20,
                    color: AppColors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(dayName, style: TextStyle(color: AppColors.white)),
              ],
            ),
          ),
          Column(
            children: [
              Text(
                punchIn,
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'Punch In',
                style: TextStyle(fontSize: 11, color: AppColors.black),
              ),
            ],
          ),
          Column(
            children: [
              Text(
                punchOut,
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'Punch Out',
                style: TextStyle(fontSize: 11, color: AppColors.black),
              ),
            ],
          ),
          Column(
            children: [
              Text(
                totalTime,
                style: TextStyle(
                  fontSize: 12,

                  color: AppColors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'Total Hours',
                style: TextStyle(fontSize: 11, color: AppColors.black),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
