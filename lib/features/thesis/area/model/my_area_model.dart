class MyAreaModel {
  final int? id;
  final DateTime? date;
  final String? latitude;
  final String? longitude;
  final String? radius;
  final String? start;
  final String? end;

  MyAreaModel({
    this.id,
    this.date,
    this.latitude,
    this.longitude,
    this.radius,
    this.start,
    this.end,
  });

  MyAreaModel copyWith({
    int? id,
    DateTime? date,
    String? latitude,
    String? longitude,
    String? radius,
  }) => MyAreaModel(
    id: id ?? this.id,
    date: date ?? this.date,
    latitude: latitude ?? this.latitude,
    longitude: longitude ?? this.longitude,
    radius: radius ?? this.radius,
  );

  @override
  String toString() {
    return 'MyAreaModel(id: $id, date: $date, latitude: $latitude, longitude: $longitude, radius: $radius, start: $start, end: $end)';
  }
}
