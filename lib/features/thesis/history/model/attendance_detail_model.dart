import 'dart:convert';

class AttendanceDetailModel {
  final String? date;
  final String? day;
  final String? punchIn;
  final String? punchOut;
  final String? totalHours;
  final String? punchInLocation;
  final String? punchOutLocation;
  final List<DutyLocation>? dutyLocation;

  AttendanceDetailModel({
    this.date,
    this.day,
    this.punchIn,
    this.punchOut,
    this.totalHours,
    this.punchInLocation,
    this.punchOutLocation,
    this.dutyLocation,
  });

  AttendanceDetailModel copyWith({
    String? date,
    String? day,
    String? punchIn,
    String? punchOut,
    String? totalHours,
    String? punchInLocation,
    String? punchOutLocation,
    List<DutyLocation>? dutyLocation,
  }) => AttendanceDetailModel(
    date: date ?? this.date,
    day: day ?? this.day,
    punchIn: punchIn ?? this.punchIn,
    punchOut: punchOut ?? this.punchOut,
    totalHours: totalHours ?? this.totalHours,
    punchInLocation: punchInLocation ?? this.punchInLocation,
    punchOutLocation: punchOutLocation ?? this.punchOutLocation,
    dutyLocation: dutyLocation ?? this.dutyLocation,
  );

  factory AttendanceDetailModel.fromJson(String str) =>
      AttendanceDetailModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AttendanceDetailModel.fromMap(Map<String, dynamic> json) =>
      AttendanceDetailModel(
        date: json["date"],
        day: json["day"],
        punchIn: json["punch_in"],
        punchOut: json["punch_out"],
        totalHours: json["total_hours"],
        punchInLocation: json["punch_in_location"],
        punchOutLocation: json["punch_out_location"],
        dutyLocation:
            json["duty_location"] == null
                ? []
                : List<DutyLocation>.from(
                  json["duty_location"]!.map((x) => DutyLocation.fromMap(x)),
                ),
      );

  Map<String, dynamic> toMap() => {
    "date": date,
    "day": day,
    "punch_in": punchIn,
    "punch_out": punchOut,
    "total_hours": totalHours,
    "punch_in_location": punchInLocation,
    "punch_out_location": punchOutLocation,
    "duty_location":
        dutyLocation == null
            ? []
            : List<dynamic>.from(dutyLocation!.map((x) => x.toMap())),
  };
}

class DutyLocation {
  final int? id;
  final String? latitude;
  final String? longitude;
  final String? address;
  final String? time;
  final String? remark;

  DutyLocation({
    this.id,
    this.latitude,
    this.longitude,
    this.address,
    this.time,
    this.remark,
  });

  DutyLocation copyWith({
    int? id,
    String? latitude,
    String? longitude,
    String? address,
    String? time,
    String? remark,
  }) => DutyLocation(
    id: id ?? this.id,
    latitude: latitude ?? this.latitude,
    longitude: longitude ?? this.longitude,
    address: address ?? this.address,
    time: time ?? this.time,
    remark: remark ?? this.remark,
  );

  factory DutyLocation.fromJson(String str) =>
      DutyLocation.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory DutyLocation.fromMap(Map<String, dynamic> json) => DutyLocation(
    id: json["id"],
    latitude: json["latitude"],
    longitude: json["longitude"],
    address: json["address"],
    time: json["time"],
    remark: json["remark"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "latitude": latitude,
    "longitude": longitude,
    "address": address,
    "time": time,
    "remark": remark,
  };
}
