import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:workspace/core/utils/app_colors.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:workspace/core/service/permission_service.dart';

class MapWidget extends StatefulWidget {
  const MapWidget({super.key, this.lat, this.lng, this.radius});
  final double? lat;
  final double? lng;
  final double? radius;

  double get getRadius => radius == null ? 2000 : (radius! * 1000);

  double get zoom {
    double zoomLevel = 16 - log(getRadius / 500) / log(2);
    return (zoomLevel - 1.0).clamp(0.0, 21.0);
  }

  @override
  State<MapWidget> createState() => MapWidgetState();
}

class MapWidgetState extends State<MapWidget> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  LatLng _currentPosition = const LatLng(23.7990944, 90.4099601);
  Set<Circle> _circles = {};
  Marker? _selectedMarker;

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    if (widget.lat != null && widget.lng != null) {
      _currentPosition = LatLng(widget.lat!, widget.lng!);
      _moveCameraToPosition(_currentPosition);
      return;
    }
    await PermissionService().locationPermission(context);
    if (!mounted) return;
    await PermissionService().locationPermission(context);
    Position position = await Geolocator.getCurrentPosition();
    _currentPosition = LatLng(position.latitude, position.longitude);
    _moveCameraToPosition(_currentPosition);
  }

  Future<void> _moveCameraToPosition(LatLng position) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: position, zoom: widget.zoom),
      ),
    );
    setState(() {
      _selectedMarker = Marker(
        markerId: const MarkerId("selected"),
        position: position,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      );
      _circles = {
        Circle(
          strokeWidth: 1,
          radius: widget.getRadius,
          center: _currentPosition,
          strokeColor: AppColors.red,
          fillColor: AppColors.red.withValues(alpha: 0.3),
          circleId: const CircleId("currentPositionCircle"),
        ),
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.4,
        margin: EdgeInsets.all(25),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: CameraPosition(
            target: _currentPosition,
            zoom: widget.zoom,
          ),
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
          markers: _selectedMarker != null ? {_selectedMarker!} : {},
          circles: _circles,
        ),
      ),
    );
  }
}
