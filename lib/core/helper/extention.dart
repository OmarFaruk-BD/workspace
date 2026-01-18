import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

extension StringExtensions on String? {
  /// 'hello' → 'Hello'
  String? capitalize() {
    if (this == null || this!.isEmpty) return null;
    return "${this![0].toUpperCase()}${this!.substring(1)}";
  }

  /// 'FlutterDevelopment' → 'FlutterDevelop'
  String? shorten([int count = 15]) {
    if (this == null || this!.isEmpty) return null;
    return this!.length >= count ? this!.substring(0, count) : this!;
  }

  /// 'FlutterDevelopment' → 'FlutterDevelop...'
  String? ellipsis([int count = 15]) {
    if (this == null || this!.isEmpty) return null;
    return this!.length >= count ? '${this!.substring(0, count)}...' : this!;
  }

  /// 'FlutterDevelopment' → '...velopment'
  String? truncateFromEnd([int count = 15]) {
    if (this == null || this!.isEmpty) return null;
    final bool isLong = this!.length > count;
    return isLong ? '...${this!.substring(this!.length - count)}' : this!;
  }

  /// '13:45:00' → '1:45 PM'
  String? toDateString() {
    if (this == null || this!.isEmpty) return null;
    final time = DateFormat("HH:mm:ss").tryParse(this!);
    return time != null ? DateFormat.jm().format(time) : null;
  }

  /// '01-01-2024 12:30 PM' → DateTime
  DateTime? toDateTime([String format = 'dd-MM-yyyy hh:mm a']) {
    if (this == null || this!.isEmpty) return null;
    return DateFormat(format).tryParse(this!.toUpperCase());
  }

  /// '01:30 PM' → TimeOfDay(13:30)
  TimeOfDay? toTimeOfDay() {
    if (this == null || this!.isEmpty) return null;
    final format = DateFormat('hh:mm a');
    DateTime? dateTime = format.tryParse(this!);
    if (dateTime == null) return null;
    return TimeOfDay.fromDateTime(dateTime);
  }

  /// '13:30' → TimeOfDay(13:30)
  TimeOfDay? stringToTimeOfDay() {
    if (this == null || this!.isEmpty || !this!.contains(':')) return null;
    final parts = this!.split(':');
    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    if (hour == null || minute == null) return null;
    return TimeOfDay(hour: hour, minute: minute);
  }

  DateTime? stringToDate() {
    if (this == null || this!.isEmpty) return null;
    final formatter = DateFormat('MM-dd-yyyy');
    DateTime? dateTime = formatter.tryParse(this!);
    return dateTime;
  }
}

extension DateTimeFormatting on DateTime? {
  /// DateTime => 'MM-dd-yyyy'
  String? toDateString([String format = 'MM-dd-yyyy']) {
    if (this == null) return null;
    final DateFormat formatter = DateFormat(format);
    return formatter.format(this!);
  }

  /// DateTime => 'dd MMM yyyy'
  String? showDate([String format = 'dd MMM yyyy']) {
    if (this == null) return null;
    final DateFormat formatter = DateFormat(format);
    return formatter.format(this!);
  }

  /// DateTime => 'EEEE, MMM dd, yyyy'
  String? showFullDate() => showDate('EEEE, MMM dd, yyyy');

  /// - `'dd-MM-yyyy hh:mm a'` → `01-01-2024 12:30 PM`
  /// - `'dd-MM-yyyy hh:mm:ss a'` → `01-01-2024 12:30:45 PM`
}
