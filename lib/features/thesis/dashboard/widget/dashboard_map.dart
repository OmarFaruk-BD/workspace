import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:workspace/core/service/permission_service.dart';

class DashboardMapWidget extends StatefulWidget {
  const DashboardMapWidget({super.key});

  @override
  State<DashboardMapWidget> createState() => DashboardMapWidgetState();
}

class DashboardMapWidgetState extends State<DashboardMapWidget> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  LatLng _currentPosition = const LatLng(23.7990944, 90.4099601);
  Marker? _selectedMarker;

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    await PermissionService().locationPermission(context);
    Position position = await Geolocator.getCurrentPosition();
    _currentPosition = LatLng(position.latitude, position.longitude);
    _moveCameraToPosition(_currentPosition);
  }

  Future<void> _moveCameraToPosition(LatLng position) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: position, zoom: 13),
      ),
    );
    setState(() {
      _selectedMarker = Marker(
        markerId: const MarkerId("selected"),
        position: position,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.2,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: GoogleMap(
          mapType: MapType.normal,
          zoomGesturesEnabled: false,
          scrollGesturesEnabled: false,
          tiltGesturesEnabled: false,
          rotateGesturesEnabled: false,
          zoomControlsEnabled: false,
          initialCameraPosition: CameraPosition(
            target: _currentPosition,
            zoom: 14.0,
          ),
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
          markers: _selectedMarker != null ? {_selectedMarker!} : {},
        ),
      ),
    );
  }
}
