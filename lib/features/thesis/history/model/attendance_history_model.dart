import 'dart:convert';

class AttendanceHistoryResModel {
  final int? statusCode;
  final String? message;
  final List<AttendanceHistoryModel>? data;

  AttendanceHistoryResModel({this.statusCode, this.message, this.data});

  AttendanceHistoryResModel copyWith({
    int? statusCode,
    String? message,
    List<AttendanceHistoryModel>? data,
  }) => AttendanceHistoryResModel(
    statusCode: statusCode ?? this.statusCode,
    message: message ?? this.message,
    data: data ?? this.data,
  );

  factory AttendanceHistoryResModel.fromJson(String str) =>
      AttendanceHistoryResModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AttendanceHistoryResModel.fromMap(Map<String, dynamic> json) =>
      AttendanceHistoryResModel(
        statusCode: json["status_code"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<AttendanceHistoryModel>.from(
                json["data"]!.map((x) => AttendanceHistoryModel.fromMap(x)),
              ),
      );

  Map<String, dynamic> toMap() => {
    "status_code": statusCode,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
  };
}

class AttendanceHistoryModel {
  final DateTime? punchDate;
  final String? punchIn;
  final String? punchOut;
  final String? totalHours;
  final String? day;
  final String? dayName;
  final String? monthYear;
  final String? lat;
  final String? long;

  AttendanceHistoryModel({
    this.punchDate,
    this.punchIn,
    this.punchOut,
    this.totalHours,
    this.day,
    this.dayName,
    this.monthYear,
    this.lat,
    this.long,
  });

  AttendanceHistoryModel copyWith({
    DateTime? punchDate,
    String? punchIn,
    String? punchOut,
    String? totalHours,
    String? day,
    String? dayName,
    String? monthYear,
    String? lat,
    String? long,
  }) => AttendanceHistoryModel(
    punchDate: punchDate ?? this.punchDate,
    punchIn: punchIn ?? this.punchIn,
    punchOut: punchOut ?? this.punchOut,
    totalHours: totalHours ?? this.totalHours,
    day: day ?? this.day,
    dayName: dayName ?? this.dayName,
    monthYear: monthYear ?? this.monthYear,
    lat: lat ?? this.lat,
    long: long ?? this.long,
  );

  factory AttendanceHistoryModel.fromJson(String str) =>
      AttendanceHistoryModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AttendanceHistoryModel.fromMap(Map<String, dynamic> json) =>
      AttendanceHistoryModel(
        punchDate: json["punch_date"] == null
            ? null
            : DateTime.parse(json["punch_date"]),
        punchIn: json["punch_in"],
        punchOut: json["punch_out"],
        totalHours: json["total_hours"],
        day: json["day"],
        dayName: json["day_name"],
        monthYear: json["month_year"],
      );

  Map<String, dynamic> toMap() => {
    "punch_date":
        "${punchDate!.year.toString().padLeft(4, '0')}-${punchDate!.month.toString().padLeft(2, '0')}-${punchDate!.day.toString().padLeft(2, '0')}",
    "punch_in": punchIn,
    "punch_out": punchOut,
    "total_hours": totalHours,
    "day": day,
    "day_name": dayName,
    "month_year": monthYear,
  };
}
