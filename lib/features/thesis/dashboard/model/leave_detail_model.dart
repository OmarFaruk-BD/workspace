import 'dart:convert';

class LeaveDetailResModel {
  final int? statusCode;
  final String? message;
  final LeaveDetailModel? data;

  LeaveDetailResModel({this.statusCode, this.message, this.data});

  LeaveDetailResModel copyWith({
    int? statusCode,
    String? message,
    LeaveDetailModel? data,
  }) => LeaveDetailResModel(
    statusCode: statusCode ?? this.statusCode,
    message: message ?? this.message,
    data: data ?? this.data,
  );

  factory LeaveDetailResModel.fromJson(String str) =>
      LeaveDetailResModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory LeaveDetailResModel.fromMap(
    Map<String, dynamic> json,
  ) => LeaveDetailResModel(
    statusCode: json["status_code"],
    message: json["message"],
    data: json["data"] == null ? null : LeaveDetailModel.fromMap(json["data"]),
  );

  Map<String, dynamic> toMap() => {
    "status_code": statusCode,
    "message": message,
    "data": data?.toMap(),
  };
}

class LeaveDetailModel {
  final String? id;
  final String? leaveType;
  final String? leaveMode;
  final String? status;
  final String? dayCount;
  final String? reason;
  final String? fromDate;
  final String? toDate;
  final String? emergencyContact;

  LeaveDetailModel({
    this.id,
    this.leaveType,
    this.leaveMode,
    this.status,
    this.dayCount,
    this.reason,
    this.fromDate,
    this.toDate,
    this.emergencyContact,
  });

  LeaveDetailModel copyWith({
    String? id,
    String? leaveType,
    String? leaveMode,
    String? status,
    String? dayCount,
    String? reason,
    String? fromDate,
    String? toDate,
    String? emergencyContact,
  }) => LeaveDetailModel(
    id: id ?? this.id,
    leaveType: leaveType ?? this.leaveType,
    leaveMode: leaveMode ?? this.leaveMode,
    status: status ?? this.status,
    dayCount: dayCount ?? this.dayCount,
    reason: reason ?? this.reason,
    fromDate: fromDate ?? this.fromDate,
    toDate: toDate ?? this.toDate,
    emergencyContact: emergencyContact ?? this.emergencyContact,
  );

  factory LeaveDetailModel.fromJson(String str) =>
      LeaveDetailModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory LeaveDetailModel.fromMap(Map<String, dynamic> json) =>
      LeaveDetailModel(
        id: json["id"],
        leaveType: json["leave_type"],
        leaveMode: json["leave_mode"],
        status: json["status"],
        dayCount: json["day_count"],
        reason: json["reason"],
        fromDate: json["from_date"],
        toDate: json["to_date"],
        emergencyContact: json["emergency_contact"],
      );

  Map<String, dynamic> toMap() => {
    "id": id,
    "leave_type": leaveType,
    "leave_mode": leaveMode,
    "status": status,
    "day_count": dayCount,
    "reason": reason,
    "from_date": fromDate,
    "to_date": toDate,
    "emergency_contact": emergencyContact,
  };
}
