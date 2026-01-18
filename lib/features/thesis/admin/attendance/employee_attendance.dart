import 'package:flutter/material.dart';
import 'package:workspace/core/components/app_bar.dart';
import 'package:workspace/core/components/app_button.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:workspace/core/components/app_snack_bar.dart';
import 'package:workspace/core/service/location_service.dart';
import 'package:workspace/core/components/app_text_field.dart';
import 'package:workspace/features/thesis/auth/model/user_model.dart';
import 'package:workspace/features/thesis/admin/widget/pick_location.dart';
import 'package:workspace/features/thesis/admin/service/e_attendance_service.dart';

class AddEmployeeAttendancePage extends StatefulWidget {
  const AddEmployeeAttendancePage({super.key, this.user});
  final UserModel? user;

  @override
  State<AddEmployeeAttendancePage> createState() =>
      _AddEmployeeAttendancePageState();
}

class _AddEmployeeAttendancePageState extends State<AddEmployeeAttendancePage> {
  final EAssignLocationService _eAssignLocation = EAssignLocationService();
  final TextEditingController _radius = TextEditingController();
  final LocationService _locationService = LocationService();
  TimeOfDay _startTime = TimeOfDay(hour: 09, minute: 00);
  TimeOfDay _endTime = TimeOfDay(hour: 16, minute: 00);
  bool _isLoading = false;
  String? _address;
  String? _long;
  String? _lat;

  @override
  void initState() {
    super.initState();
    _radius.text = '10';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AdminAppBar(title: 'Assign Attendance'),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Office Start Time'),
              SizedBox(height: 8),
              AppTextField(
                readOnly: true,
                controller: TextEditingController(
                  text: _startTime.format(context),
                ),
                onTap: () async {
                  await showTimePicker(
                    context: context,
                    initialTime: _startTime,
                  ).then((time) {
                    setState(() {
                      _startTime = time ?? TimeOfDay(hour: 09, minute: 00);
                    });
                  });
                },
              ),
              SizedBox(height: 20),
              Text('Office End Time'),
              SizedBox(height: 8),
              AppTextField(
                readOnly: true,
                controller: TextEditingController(
                  text: _endTime.format(context),
                ),
                onTap: () async {
                  await showTimePicker(
                    context: context,
                    initialTime: _endTime,
                  ).then((time) {
                    setState(() {
                      _endTime = time ?? TimeOfDay(hour: 09, minute: 00);
                    });
                  });
                },
              ),
              SizedBox(height: 20),
              Text('Assign location'),
              SizedBox(height: 8),
              AppTextField(
                readOnly: true,
                hintText: 'Assign Location',
                controller: TextEditingController(
                  text: _lat == null
                      ? null
                      : 'Lat: ${_lat ?? ''}, Lng: ${_long ?? ''}',
                ),
                onTap: () async {
                  final LatLng? picked = await showDialog<LatLng>(
                    context: context,
                    builder: (context) => const PickLocationDialog(),
                  );
                  if (picked != null) {
                    _lat = picked.latitude.toStringAsFixed(4);
                    _long = picked.longitude.toStringAsFixed(4);
                    setState(() {});
                    final data = await _locationService.getLocationDetail(
                      picked.latitude,
                      picked.longitude,
                    );
                    _address = data?.fullAddress;
                    setState(() {});
                  }
                },
              ),
              if (_address != null) SizedBox(height: 8),
              if (_address != null) Text(_address ?? ''),
              SizedBox(height: 20),
              Text('Assign Radius (in KM)'),
              SizedBox(height: 8),
              AppTextField(
                controller: _radius,
                hintText: 'Enter radius',
                textInputType: TextInputType.number,
              ),
              SizedBox(height: 30),
              AppButton(
                text: 'Assign Location',
                isLoading: _isLoading,
                width: double.maxFinite,
                onTap: _createTask,
              ),
              SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  void _createTask() async {
    setState(() => _isLoading = true);
    final result = await _eAssignLocation.assignLocation(
      start: _startTime.format(context).toString(),
      end: _endTime.format(context).toString(),
      userId: widget.user?.id ?? '',
      lat: _lat ?? '',
      long: _long ?? '',
      radius: _radius.text,
    );
    setState(() => _isLoading = false);
    result.fold((error) => AppSnackBar.show(context, error), (data) {
      AppSnackBar.show(context, data);
    });
  }
}
