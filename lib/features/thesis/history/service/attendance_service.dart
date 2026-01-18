import 'package:fpdart/fpdart.dart';
import 'package:logger/logger.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:workspace/core/helper/extention.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:workspace/features/thesis/history/model/attendance_detail_model.dart';
import 'package:workspace/features/thesis/history/model/attendance_history_model.dart';

class AttendanceService {
  final Logger _logger = Logger();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Either<String, String>> createAttendance({
    required String longitude,
    required String latitude,
    required String assignTo,
    required String address,
    required bool isPunchIn,
  }) async {
    try {
      final dateTime = DateTime.now();
      String? date = dateTime.toDateString('yyyy-MM-dd');
      String? time = dateTime.toDateString('hh:mm:ss');
      Map<String, dynamic> payload = {
        'date': date,
        'time': time,
        'address': address,
        'latitude': latitude,
        'assignTo': assignTo,
        'longitude': longitude,
        'isPunchIn': isPunchIn,
        'createdAt': FieldValue.serverTimestamp(),
      };
      _logger.e(payload);

      await _firestore.collection('eAttendance').add(payload);

      return const Right('Attendance created successfully.');
    } catch (e) {
      _logger.e('Error creating task: $e');
      return Left('Failed to create attendance: $e');
    }
  }

  Future<AttendanceDetailModel?> getTodayAttendanceEmployee(
    String assignedTo,
  ) async {
    try {
      final querySnapshot = await _firestore.collection('eAttendance').get();
      final attendanceList = querySnapshot.docs
          .map((doc) => doc.data())
          .toList();

      if (attendanceList.isEmpty) return null;

      final today = DateTime.now();

      // ✅ Filter today's attendance for this user
      final todayList = attendanceList.where((item) {
        final date = DateTime.tryParse(item['date'] ?? '');
        return date != null &&
            date.year == today.year &&
            date.month == today.month &&
            date.day == today.day &&
            item['assignTo'] == assignedTo;
      }).toList();

      if (todayList.isEmpty) return null;

      // ✅ Sort by time (earliest → latest)
      todayList.sort(
        (a, b) => (a['time'] as String).compareTo(b['time'] as String),
      );

      // ✅ Find earliest punchIn
      final firstPunchIn = todayList.firstWhere(
        (item) => item['isPunchIn'] == true,
        orElse: () => todayList.first,
      );

      // ✅ Check last record to decide if user punched out or not
      final lastRecord = todayList.last;
      final hasPunchedOut = lastRecord['isPunchIn'] == false;

      final punchInTime = firstPunchIn['time'];
      final punchOutTime = hasPunchedOut ? lastRecord['time'] : null;

      final punchInLat = firstPunchIn['latitude'];
      // final punchInLng = firstPunchIn['longitude'];

      // final punchOutLat = hasPunchedOut ? lastRecord['latitude'] : null;
      final punchOutLng = hasPunchedOut ? lastRecord['longitude'] : null;

      // ✅ Build duty location list (all today’s points)
      final dutyLocations = todayList.map((entry) {
        return DutyLocation(
          latitude: entry['latitude'],
          longitude: entry['longitude'],
          address: entry['address'] ?? '',
          time: entry['time'],
        );
      }).toList();

      final date = firstPunchIn['date'];
      final dayName = DateFormat('EEEE').format(today);

      final totalHours = _calculateTotalHours(punchInTime, punchOutTime);

      // ✅ Build model
      final attendanceDetail = AttendanceDetailModel(
        date: date,
        day: dayName,
        punchIn: punchInTime,
        totalHours: totalHours,
        punchOut: punchOutTime,
        punchInLocation: punchInLat,
        punchOutLocation: punchOutLng,
        dutyLocation: dutyLocations,
      );

      _logger.i('TodayAttendance: ${attendanceDetail.toMap()}');
      return attendanceDetail;
    } on FirebaseException catch (e) {
      _logger.e('TodayAttendanceEmployee Firebase: ${e.message}');
      return null;
    } catch (e) {
      _logger.e('TodayAttendanceEmployee Error: $e');
      return null;
    }
  }

  Future<List<AttendanceHistoryModel>> getAttendanceHistory(
    String assignedTo,
  ) async {
    try {
      final querySnapshot = await _firestore.collection('eAttendance').get();

      final attendanceList = querySnapshot.docs.map((doc) {
        return doc.data();
      }).toList();

      if (attendanceList.isEmpty) return [];

      // Step 1: Filter by assignedTo
      final filteredList = attendanceList
          .where((item) => item['assignTo'] == assignedTo)
          .toList();

      // Step 2: Group by date
      final Map<String, List<Map<String, dynamic>>> groupedByDate = {};

      for (final item in filteredList) {
        final date = item['date'];
        if (date == null) continue;
        groupedByDate.putIfAbsent(date, () => []);
        groupedByDate[date]!.add(item);
      }

      // Step 3: Process each date group
      final List<AttendanceHistoryModel> dataList = [];

      groupedByDate.forEach((date, entries) {
        // Parse times and sort them
        final times = entries.map((e) => e['time'] as String).toList();

        // Sort times to find earliest and latest
        times.sort((a, b) => a.compareTo(b));

        final punchIn = times.first; // earliest time
        final punchOut = times.last; // latest time

        final punchDate = DateTime.tryParse(date);
        final day = punchDate?.day.toString() ?? '';
        final dayName = punchDate?.toDateString('EE');
        final monthYear = punchDate?.toDateString('MM');

        // Optional: compute total hours difference
        final totalHours = _calculateTotalHours(punchIn, punchOut);

        final inTime = DateFormat("HH:mm:ss").parse(punchIn);
        final outTime = DateFormat("HH:mm:ss").parse(punchOut);

        dataList.add(
          AttendanceHistoryModel(
            punchDate: punchDate,
            punchIn: inTime.toDateString('hh:mm a'),
            punchOut: outTime.toDateString('hh:mm a'),
            totalHours: totalHours,
            day: day,
            dayName: dayName,
            monthYear: monthYear,
          ),
        );
      });

      return dataList;
    } on FirebaseException catch (e) {
      _logger.e('TodayAttendanceEmployee: ${e.message}');
      return [];
    } catch (e) {
      _logger.e('TodayAttendanceEmployee: $e');
      return [];
    }
  }

  Future<(String? lat, String? long)> getAttendanceHistoryV2(
    String assignedTo,
  ) async {
    try {
      final querySnapshot = await _firestore.collection('eAttendance').get();

      final attendanceList = querySnapshot.docs.map((doc) {
        return doc.data();
      }).toList();

      final filteredList = attendanceList
          .where((item) => item['assignTo'] == assignedTo)
          .toList();

      Map<String, dynamic> getData = filteredList.first;

      final String? lat = getData['latitude'];
      final String? long = getData['longitude'];

      return (lat, long);
    } on FirebaseException catch (e) {
      _logger.e('TodayAttendanceEmployee: ${e.message}');
      return (null, null);
    } catch (e) {
      _logger.e('TodayAttendanceEmployee: $e');
      return (null, null);
    }
  }

  String _calculateTotalHours(String punchIn, String punchOut) {
    try {
      final inTime = DateFormat("HH:mm:ss").parse(punchIn);
      final outTime = DateFormat("HH:mm:ss").parse(punchOut);

      final duration = outTime.difference(inTime);
      final hours = duration.inHours;
      final minutes = duration.inMinutes.remainder(60);

      return "${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}";
    } catch (e) {
      return '00:00';
    }
  }
}
