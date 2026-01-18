import 'package:flutter/material.dart';
import 'package:workspace/core/helper/extention.dart';
import 'package:workspace/core/utils/app_colors.dart';
import 'package:workspace/core/components/app_bar.dart';
import 'package:workspace/core/service/location_service.dart';
import 'package:workspace/features/thesis/auth/model/user_model.dart';
import 'package:workspace/core/components/loading_or_empty.dart';
import 'package:workspace/features/thesis/history/widget/date_item.dart';
import 'package:workspace/features/thesis/history/service/attendance_service.dart';
import 'package:workspace/features/thesis/history/model/attendance_detail_model.dart';
import 'package:workspace/features/thesis/history/model/attendance_history_model.dart';

class EAttendanceHistory extends StatefulWidget {
  const EAttendanceHistory({super.key, this.user});
  final UserModel? user;

  @override
  State<EAttendanceHistory> createState() => _EAttendanceHistoryState();
}

class _EAttendanceHistoryState extends State<EAttendanceHistory> {
  final AttendanceService _attendanceService = AttendanceService();
  List<AttendanceHistoryModel> _attendanceHistoryList = [];
  AttendanceDetailModel? _todayAttendanceHistory;
  bool isLoading = true;

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

  void _initDateList() async {
    _attendanceHistoryList = await _attendanceService.getAttendanceHistory(
      widget.user?.id ?? '',
    );

    _todayAttendanceHistory = await _attendanceService
        .getTodayAttendanceEmployee(widget.user?.id ?? '');

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AdminAppBar(
        title: 'Employee Attendance History',
        onBackTap: () => Navigator.pop(context),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LoadingOrEmptyText(
              isLoading: isLoading,
              isEmpty: _attendanceHistoryList.isEmpty,
              emptyText: 'No attendance history found.',
            ),
            if (!isLoading && _todayAttendanceHistory != null)
              ToDayAttendanceHistory(
                todayAttendanceHistory: _todayAttendanceHistory,
              ),
            if (!isLoading && _todayAttendanceHistory != null)
              SizedBox(height: 25),
            if (!isLoading && _attendanceHistoryList.isNotEmpty)
              Text(
                'Previous Attendance',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            SizedBox(height: 15),
            ...List.generate(_attendanceHistoryList.length, (index) {
              final data = _attendanceHistoryList[index];
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
        ),
      ),
    );
  }
}

class ToDayAttendanceHistory extends StatefulWidget {
  const ToDayAttendanceHistory({super.key, this.todayAttendanceHistory});
  final AttendanceDetailModel? todayAttendanceHistory;

  @override
  State<ToDayAttendanceHistory> createState() => _ToDayAttendanceHistoryState();
}

class _ToDayAttendanceHistoryState extends State<ToDayAttendanceHistory> {
  final LocationService _service = LocationService();
  AttendanceDetailModel? todayAttendanceHistory;
  String? address;

  @override
  void initState() {
    super.initState();
    todayAttendanceHistory = widget.todayAttendanceHistory;
    getAddress();
  }

  void getAddress() async {
    final lat = double.tryParse(todayAttendanceHistory?.punchInLocation ?? '');
    final long = double.tryParse(
      todayAttendanceHistory?.punchOutLocation ?? '',
    );

    if (lat != null && long != null) {
      _getAddressFromLocation(lat, long);
    } else {
      if (todayAttendanceHistory?.dutyLocation != null &&
          todayAttendanceHistory!.dutyLocation!.isNotEmpty) {
        final firstLocation = todayAttendanceHistory!.dutyLocation!.first;
        final lat = double.tryParse(firstLocation.latitude ?? '');
        final long = double.tryParse(firstLocation.longitude ?? '');
        if (lat != null && long != null) {
          _getAddressFromLocation(lat, long);
        } else {
          final lastLocation = todayAttendanceHistory!.dutyLocation!.last;
          final lat = double.tryParse(lastLocation.latitude ?? '');
          final long = double.tryParse(lastLocation.longitude ?? '');
          if (lat != null && long != null) {
            _getAddressFromLocation(lat, long);
          }
        }
      }
    }
  }

  void _getAddressFromLocation(double lat, double long) async {
    final location = await _service.getLocationDetail(lat, long);
    setState(() => address = location?.fullAddress);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Today\'s Attendance',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(
                      todayAttendanceHistory?.punchIn?.toDateString() ??
                          '--:--',
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
                      todayAttendanceHistory?.punchOut?.toDateString() ??
                          '--:--',
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
                      todayAttendanceHistory?.totalHours ?? '--:--',
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
            SizedBox(height: 15),
            if (address != null)
              Text(
                'Address: $address',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            if (address != null) SizedBox(height: 8),
            Text(
              'Date: ${todayAttendanceHistory?.date ?? ''}',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
