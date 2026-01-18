import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workspace/features/thesis/auth/cubit/auth_cubit.dart';
import 'package:workspace/features/thesis/history/service/attendance_service.dart';
import 'package:workspace/features/thesis/history/model/attendance_detail_model.dart';
import 'package:workspace/features/thesis/history/model/attendance_history_model.dart';

part 'attendance_state.dart';

class AttendanceCubit extends Cubit<AttendanceState> {
  AttendanceCubit() : super(AttendanceInitial());
  final AttendanceService _attendanceService = AttendanceService();

  void updateAttendanceDetails(BuildContext context) async {
    final user = context.read<AuthCubit>().state.user;
    final assignedTo = user?.id ?? '';
    final attendanceDetail = await _attendanceService
        .getTodayAttendanceEmployee(assignedTo);
    emit(state.copyWith(attendanceDetail: attendanceDetail));
  }

  void updateAttendanceHistory(BuildContext context) async {
    final user = context.read<AuthCubit>().state.user;
    final assignedTo = user?.id ?? '';
    emit(state.copyWith(isLoading: true));
    final dataList = await _attendanceService.getAttendanceHistory(assignedTo);
    dataList.sort((a, b) {
      final aDate = a.punchDate ?? DateTime.fromMillisecondsSinceEpoch(0);
      final bDate = b.punchDate ?? DateTime.fromMillisecondsSinceEpoch(0);
      return bDate.compareTo(aDate);
    });
    emit(state.copyWith(attendanceHistoryList: dataList, isLoading: false));
  }
}
