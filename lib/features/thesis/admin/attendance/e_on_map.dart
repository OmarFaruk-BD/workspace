import 'package:flutter/material.dart';
import 'package:workspace/core/components/app_bar.dart';
import 'package:workspace/core/service/location_service.dart';
import 'package:workspace/features/thesis/area/screen/map_widget.dart';
import 'package:workspace/features/thesis/auth/model/user_model.dart';
import 'package:workspace/core/components/loading_or_empty.dart';
import 'package:workspace/features/thesis/history/service/attendance_service.dart';

class EmployeeOnMap extends StatefulWidget {
  const EmployeeOnMap({super.key, this.user});
  final UserModel? user;

  @override
  State<EmployeeOnMap> createState() => _EmployeeOnMapState();
}

class _EmployeeOnMapState extends State<EmployeeOnMap> {
  final AttendanceService _attendanceService = AttendanceService();
  final LocationService _locationService = LocationService();
  String? address;

  bool isLoading = true;
  String? long;
  String? lat;

  @override
  void initState() {
    super.initState();
    _initDataList();
  }

  void _initDataList() async {
    final data = await _attendanceService.getAttendanceHistoryV2(
      widget.user?.id ?? '',
    );
    lat = data.$1;
    long = data.$2;
    setState(() => isLoading = false);
    getAddress();
  }

  void getAddress() async {
    final getLat = double.tryParse(lat ?? '');
    final getLong = double.tryParse(long ?? '');
    if (getLat != null && getLong != null) {
      final location = await _locationService.getLocationDetail(
        getLat,
        getLong,
      );
      setState(() => address = location?.fullAddress);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AdminAppBar(
        title: 'Employee On Google Map',
        onBackTap: () => Navigator.pop(context),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LoadingOrEmptyText(isLoading: isLoading),
            if (lat == null || long == null) ...[
              SizedBox(height: 20),
              if (!isLoading)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    '${widget.user?.name ?? ''}\'s no attendance data found.',
                  ),
                ),
            ],

            if (lat != null && long != null) ...[
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  '${widget.user?.name ?? ''}\'s Location',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),
              MapWidget(
                lat: double.tryParse(lat ?? ''),
                lng: double.tryParse(long ?? ''),
              ),
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Location Address: ${address ?? ''}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
