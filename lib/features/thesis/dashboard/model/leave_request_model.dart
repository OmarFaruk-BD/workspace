import 'dart:convert';

class LeaveListResModel {
  final int? statusCode;
  final String? message;
  final LeaveListModel? data;

  LeaveListResModel({this.statusCode, this.message, this.data});

  LeaveListResModel copyWith({
    int? statusCode,
    String? message,
    LeaveListModel? data,
  }) => LeaveListResModel(
    statusCode: statusCode ?? this.statusCode,
    message: message ?? this.message,
    data: data ?? this.data,
  );

  factory LeaveListResModel.fromJson(String str) =>
      LeaveListResModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory LeaveListResModel.fromMap(Map<String, dynamic> json) =>
      LeaveListResModel(
        statusCode: json["status_code"],
        message: json["message"],
        data:
            json["data"] == null ? null : LeaveListModel.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() => {
    "status_code": statusCode,
    "message": message,
    "data": data?.toMap(),
  };
}

class LeaveListModel {
  final int? availableTotal;
  final int? takenTotal;
  final List<Day>? days;

  LeaveListModel({this.availableTotal, this.takenTotal, this.days});

  LeaveListModel copyWith({
    int? availableTotal,
    int? takenTotal,
    List<Day>? days,
  }) => LeaveListModel(
    availableTotal: availableTotal ?? this.availableTotal,
    takenTotal: takenTotal ?? this.takenTotal,
    days: days ?? this.days,
  );

  factory LeaveListModel.fromJson(String str) =>
      LeaveListModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory LeaveListModel.fromMap(Map<String, dynamic> json) => LeaveListModel(
    availableTotal: json["available_total"],
    takenTotal: json["taken_total"],
    days:
        json["days"] == null
            ? []
            : List<Day>.from(json["days"]!.map((x) => Day.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "available_total": availableTotal,
    "taken_total": takenTotal,
    "days": days == null ? [] : List<dynamic>.from(days!.map((x) => x.toMap())),
  };
}

class Day {
  final String? date;
  final String? day;
  final String? weekday;
  final String? available;
  final String? status;

  Day({this.date, this.day, this.weekday, this.available, this.status});

  Day copyWith({
    String? date,
    String? day,
    String? weekday,
    String? available,
    String? status,
  }) => Day(
    date: date ?? this.date,
    day: day ?? this.day,
    weekday: weekday ?? this.weekday,
    available: available ?? this.available,
    status: status ?? this.status,
  );

  factory Day.fromJson(String str) => Day.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Day.fromMap(Map<String, dynamic> json) => Day(
    date: json["date"],
    day: json["day"],
    weekday: json["weekday"],
    available: json["available"],
    status: json["status"],
  );

  Map<String, dynamic> toMap() => {
    "date": date,
    "day": day,
    "weekday": weekday,
    "available": available,
    "status": status,
  };
}
