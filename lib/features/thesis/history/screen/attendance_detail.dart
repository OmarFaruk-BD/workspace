import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:workspace/core/helper/extention.dart';
import 'package:workspace/core/utils/app_colors.dart';
import 'package:workspace/core/utils/app_images.dart';
import 'package:workspace/core/components/app_bar.dart';
import 'package:workspace/features/thesis/home/cubit/home_cubit.dart';
import 'package:workspace/features/thesis/history/cubit/attendance_cubit.dart';

class AttendanceDetailPage extends StatefulWidget {
  const AttendanceDetailPage({super.key, this.isLanding = true});
  final bool isLanding;

  @override
  State<AttendanceDetailPage> createState() => _AttendanceDetailPageState();
}

class _AttendanceDetailPageState extends State<AttendanceDetailPage> {
  @override
  void initState() {
    super.initState();
    context.read<AttendanceCubit>().updateAttendanceDetails(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Attendance Details',
        hasBackButton: !widget.isLanding,
      ),
      body: BlocBuilder<AttendanceCubit, AttendanceState>(
        builder: (context, state) {
          return ListView(
            padding: EdgeInsets.all(24),
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 27),
                decoration: BoxDecoration(
                  color: AppColors.green,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${DateTime.now().toDateString('dd MMMM yyyy')}\n${DateTime.now().toDateString('EEEE')}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 20),
              DottedBorder(
                options: const RoundedRectDottedBorderOptions(
                  color: AppColors.yellow,
                  radius: Radius.circular(8),
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildItem(
                      title:
                          state.attendanceDetail?.punchIn.toDateString() ??
                          '--:--',
                      subtitle: 'Punch In',
                      image: AppImages.map,
                    ),
                    _buildItem(
                      title:
                          state.attendanceDetail?.punchOut.toDateString() ??
                          '--:--',
                      subtitle: 'Punch Out',
                      image: AppImages.map,
                    ),
                    _buildItem(
                      title: state.attendanceDetail?.totalHours ?? '--:--',
                      subtitle: 'Total Hours',
                      image: AppImages.clock,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              _buildPunchInItem(
                title: 'Punch In Location: ',
                subtitle: state.attendanceDetail?.punchInLocation ?? '--:--',
              ),
              SizedBox(height: 50),
              _buildPunchInItem(
                title: 'Punch Out Location: ',
                subtitle: state.attendanceDetail?.punchOutLocation ?? '--:--',
              ),
              SizedBox(height: 50),
              if (state.attendanceDetail?.dutyLocation?.isNotEmpty == true)
                ...List.generate(1, (index) {
                  final item = state.attendanceDetail?.dutyLocation?[index];
                  return _buildPunchInItem(
                    image: AppImages.duty,
                    title: 'Your Duty Location: ',
                    subtitle: item?.address ?? '',
                  );
                }),
              if (state.attendanceDetail?.dutyLocation == null ||
                  state.attendanceDetail!.dutyLocation!.isEmpty)
                BlocBuilder<HomeCubit, HomeState>(
                  builder: (context, homeState) {
                    return _buildPunchInItem(
                      image: AppImages.duty,
                      title: 'Your Duty Location: ',
                      subtitle: homeState.address ?? '',
                    );
                  },
                ),
            ],
          );
        },
      ),
    );
  }

  Row _buildPunchInItem({
    String? title,
    String? subtitle,
    String image = AppImages.location_2,
  }) {
    return Row(
      children: [
        SvgPicture.asset(image),
        SizedBox(width: 15),
        Flexible(
          child: Text.rich(
            TextSpan(
              text: title,
              style: TextStyle(
                fontSize: 15,
                color: AppColors.grey,
                fontWeight: FontWeight.w600,
              ),
              children: [
                TextSpan(
                  text: subtitle,
                  style: TextStyle(
                    color: AppColors.grey,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Column _buildItem({
    required String title,
    required String subtitle,
    required String image,
  }) {
    return Column(
      children: [
        SvgPicture.asset(image),
        Text(
          title,
          style: TextStyle(color: AppColors.black, fontWeight: FontWeight.w600),
        ),
        Text(subtitle, style: TextStyle(fontSize: 12, color: AppColors.grey)),
      ],
    );
  }
}
