import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workspace/core/utils/app_colors.dart';
import 'package:workspace/core/components/app_bar.dart';
import 'package:workspace/features/thesis/history/widget/date_item.dart';
import 'package:workspace/features/thesis/history/cubit/attendance_cubit.dart';

class AttendanceHistoryPage extends StatefulWidget {
  const AttendanceHistoryPage({super.key});

  @override
  State<AttendanceHistoryPage> createState() => _AttendanceHistoryPageState();
}

class _AttendanceHistoryPageState extends State<AttendanceHistoryPage> {
  final List<Color> _colorList = [
    AppColors.green,
    AppColors.yellow,
    AppColors.red,
  ];

  @override
  void initState() {
    super.initState();
    _initDateList();
  }

  void _initDateList() {
    context.read<AttendanceCubit>().updateAttendanceHistory(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Attendance History',
        onBackTap: () => Navigator.pop(context),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Column(
          children: [
            BlocBuilder<AttendanceCubit, AttendanceState>(
              builder: (context, state) {
                return Column(
                  children: [
                    if (state.isLoading) CircularProgressIndicator(),
                    ...List.generate(state.attendanceHistoryList.length, (
                      index,
                    ) {
                      final data = state.attendanceHistoryList[index];
                      return DateItem(
                        punchIn: data.punchIn ?? '',
                        punchOut: data.punchOut ?? '',
                        totalTime: data.totalHours ?? '',
                        day: data.day?.toString() ?? '',
                        dayName: data.dayName ?? '',
                        color: _colorList[index % 3],
                      );
                    }),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
