part of 'attendance_cubit.dart';

class AttendanceState {
  const AttendanceState({
    this.attendanceDetail,
    required this.isLoading,
    required this.attendanceHistoryList,
  });
  final bool isLoading;
  final AttendanceDetailModel? attendanceDetail;
  final List<AttendanceHistoryModel> attendanceHistoryList;

  AttendanceState copyWith({
    bool? isLoading,
    AttendanceDetailModel? attendanceDetail,
    List<AttendanceHistoryModel>? attendanceHistoryList,
  }) {
    return AttendanceState(
      isLoading: isLoading ?? this.isLoading,
      attendanceDetail: attendanceDetail ?? this.attendanceDetail,
      attendanceHistoryList:
          attendanceHistoryList ?? this.attendanceHistoryList,
    );
  }
}

class AttendanceInitial extends AttendanceState {
  AttendanceInitial() : super(attendanceHistoryList: [], isLoading: false);
}
