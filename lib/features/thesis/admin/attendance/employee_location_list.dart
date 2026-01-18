import 'package:flutter/material.dart';
import 'package:workspace/core/components/app_bar.dart';
import 'package:workspace/core/helper/extention.dart';
import 'package:workspace/core/service/location_service.dart';
import 'package:workspace/features/thesis/auth/model/user_model.dart';
import 'package:workspace/core/components/loading_or_empty.dart';
import 'package:workspace/features/thesis/area/model/my_area_model.dart';
import 'package:workspace/features/thesis/admin/service/e_attendance_service.dart';

class EmployeeLocationList extends StatefulWidget {
  const EmployeeLocationList({super.key, this.user});
  final UserModel? user;

  @override
  State<EmployeeLocationList> createState() => _EmployeeLocationListState();
}

class _EmployeeLocationListState extends State<EmployeeLocationList> {
  final EAssignLocationService _service = EAssignLocationService();
  List<MyAreaModel> areas = [];
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    getAssignedLocation();
  }

  void getAssignedLocation() async {
    setState(() => isLoading = true);
    areas = await _service.getAllAssignLocationsByEmployee(
      widget.user?.id ?? '',
    );
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AdminAppBar(title: 'Employee Assigned Area'),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          LoadingOrEmptyText(
            isLoading: isLoading,
            isEmpty: areas.isEmpty,
            emptyText: 'No assigned area found.',
          ),
          ...List.generate(areas.length, (index) {
            final area = areas[index];
            return MyAssignedAreaItem(area: area);
          }),
        ],
      ),
    );
  }
}

class MyAssignedAreaItem extends StatefulWidget {
  const MyAssignedAreaItem({super.key, required this.area});
  final MyAreaModel area;

  @override
  State<MyAssignedAreaItem> createState() => _MyAssignedAreaItemState();
}

class _MyAssignedAreaItemState extends State<MyAssignedAreaItem> {
  final LocationService _service = LocationService();
  MyAreaModel? area;
  String? address;

  @override
  void initState() {
    super.initState();
    area = widget.area;
    getAddress();
  }

  void getAddress() async {
    final lat = double.tryParse(area?.latitude ?? '');
    final long = double.tryParse(area?.longitude ?? '');
    if (lat != null && long != null) {
      final location = await _service.getLocationDetail(lat, long);
      setState(() => address = location?.fullAddress);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Card(
        child: ListTile(
          title: Text(
            address ?? 'My Assigned Area',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Area Range: ${area?.radius ?? ''} km'),
              SizedBox(height: 15),
              Row(
                children: [
                  Expanded(child: Text('Start Time: ${area?.start ?? ''}')),
                  Expanded(
                    child: Text(
                      'Latitude:    ${area?.latitude ?? ''}',
                      textAlign: TextAlign.end,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(child: Text('End Time: ${area?.end ?? ''}')),
                  Expanded(
                    child: Text(
                      'Longitude: ${area?.longitude ?? ''}',
                      textAlign: TextAlign.end,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),
              Text(
                'Created At: ${area?.date?.toDateString('EEE, MMM dd yyyy')}',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
