import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workspace/core/utils/app_images.dart';
import 'package:workspace/core/utils/app_colors.dart';
import 'package:workspace/core/helper/extention.dart';
import 'package:workspace/core/components/app_text.dart';
import 'package:workspace/features/thesis/history/cubit/attendance_cubit.dart';

class InfoRow extends StatelessWidget {
  const InfoRow({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AttendanceCubit, AttendanceState>(
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                SvgPicture.asset(AppImages.punch_1),
                CommonText(
                  state.attendanceDetail?.punchIn.toDateString() ?? '--:--',
                  fontWeight: FontWeight.w600,
                ),
                CommonText('Punch In', color: AppColors.grey),
              ],
            ),
            Column(
              children: [
                SvgPicture.asset(AppImages.punch_2),
                CommonText(
                  state.attendanceDetail?.totalHours ?? '--:--',
                  fontWeight: FontWeight.w600,
                ),
                CommonText('Total Hours', color: AppColors.grey),
              ],
            ),
            Column(
              children: [
                SvgPicture.asset(AppImages.punch_3),
                CommonText(
                  state.attendanceDetail?.punchOut.toDateString() ?? '--:--',
                  fontWeight: FontWeight.w600,
                ),
                CommonText('Punch Out', color: AppColors.grey),
              ],
            ),
          ],
        );
      },
    );
  }
}
