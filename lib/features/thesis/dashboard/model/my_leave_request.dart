import 'dart:convert';

class MyLeaveRequestResModel {
  final MyLeaveRequestModel? data;

  MyLeaveRequestResModel({this.data});

  MyLeaveRequestResModel copyWith({MyLeaveRequestModel? data}) =>
      MyLeaveRequestResModel(data: data ?? this.data);

  factory MyLeaveRequestResModel.fromJson(String str) =>
      MyLeaveRequestResModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory MyLeaveRequestResModel.fromMap(Map<String, dynamic> json) =>
      MyLeaveRequestResModel(
        data:
            json["data"] == null
                ? null
                : MyLeaveRequestModel.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() => {"data": data?.toMap()};
}

class MyLeaveRequestModel {
  final MyLeaveModel? pending;
  final MyLeaveModel? approved;
  final MyLeaveModel? notApproved;

  MyLeaveRequestModel({this.pending, this.approved, this.notApproved});

  MyLeaveRequestModel copyWith({
    MyLeaveModel? pending,
    MyLeaveModel? approved,
    MyLeaveModel? notApproved,
  }) => MyLeaveRequestModel(
    pending: pending ?? this.pending,
    approved: approved ?? this.approved,
    notApproved: notApproved ?? this.notApproved,
  );

  factory MyLeaveRequestModel.fromJson(String str) =>
      MyLeaveRequestModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory MyLeaveRequestModel.fromMap(Map<String, dynamic> json) =>
      MyLeaveRequestModel(
        pending:
            json["pending"] == null
                ? null
                : MyLeaveModel.fromMap(json["pending"]),
        approved:
            json["approved"] == null
                ? null
                : MyLeaveModel.fromMap(json["approved"]),
        notApproved:
            json["not_approved"] == null
                ? null
                : MyLeaveModel.fromMap(json["not_approved"]),
      );

  Map<String, dynamic> toMap() => {
    "pending": pending?.toMap(),
    "approved": approved?.toMap(),
    "not_approved": notApproved?.toMap(),
  };
}

class MyLeaveModel {
  final int? count;
  final Items? items;

  MyLeaveModel({this.count, this.items});

  MyLeaveModel copyWith({int? count, Items? items}) =>
      MyLeaveModel(count: count ?? this.count, items: items ?? this.items);

  factory MyLeaveModel.fromJson(String str) =>
      MyLeaveModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory MyLeaveModel.fromMap(Map<String, dynamic> json) => MyLeaveModel(
    count: json["count"],
    items: json["items"] == null ? null : Items.fromMap(json["items"]),
  );

  Map<String, dynamic> toMap() => {"count": count, "items": items?.toMap()};
}

class Items {
  final List<Datum>? data;

  Items({ this.data});

  Items copyWith({List<Datum>? data}) => Items(
    data: data ?? this.data,
  );

  factory Items.fromJson(String str) => Items.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Items.fromMap(Map<String, dynamic> json) => Items(
    data:
        json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
  };
}

class Datum {
  final String? id;
  final String? leaveType;
  final String? leaveMode;
  final String? fromDate;
  final String? toDate;
  final String? status;
  final String? dayCount;

  Datum({
    this.id,
    this.leaveType,
    this.leaveMode,
    this.fromDate,
    this.toDate,
    this.status,
    this.dayCount,
  });

  Datum copyWith({
    String? id,
    String? leaveType,
    String? leaveMode,
    String? fromDate,
    String? toDate,
    String? status,
    String? dayCount,
  }) => Datum(
    id: id ?? this.id,
    leaveType: leaveType ?? this.leaveType,
    leaveMode: leaveMode ?? this.leaveMode,
    fromDate: fromDate ?? this.fromDate,
    toDate: toDate ?? this.toDate,
    status: status ?? this.status,
    dayCount: dayCount ?? this.dayCount,
  );

  factory Datum.fromJson(String str) => Datum.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Datum.fromMap(Map<String, dynamic> json) => Datum(
    id: json["id"],
    leaveType: json["leave_type"],
    leaveMode: json["leave_mode"],
    fromDate: json["from_date"],
    toDate: json["to_date"],
    status: json["status"],
    dayCount: json["day_count"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "leave_type": leaveType,
    "leave_mode": leaveMode,
    "from_date": fromDate,
    "to_date": toDate,
    "status": status,
    "day_count": dayCount,
  };
}
