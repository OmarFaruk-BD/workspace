import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workspace/core/utils/app_images.dart';
import 'package:workspace/core/utils/app_colors.dart';
import 'package:workspace/core/helper/extention.dart';
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
                Text(
                  state.attendanceDetail?.punchIn.toDateString() ?? '--:--',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const Text('Punch In', style: TextStyle(color: AppColors.grey)),
              ],
            ),
            Column(
              children: [
                SvgPicture.asset(AppImages.punch_2),
                Text(
                  state.attendanceDetail?.totalHours ?? '--:--',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const Text(
                  'Total Hours',
                  style: TextStyle(color: AppColors.grey),
                ),
              ],
            ),
            Column(
              children: [
                SvgPicture.asset(AppImages.punch_3),
                Text(
                  state.attendanceDetail?.punchOut.toDateString() ?? '--:--',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const Text(
                  'Punch Out',
                  style: TextStyle(color: AppColors.grey),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
