import 'package:flutter/material.dart';
import 'package:widget_to_marker/widget_to_marker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:workspace/features/map/widget/marker_icon.dart';
import 'package:workspace/features/map/widget/marker_info_widget.dart';
import 'package:workspace/features/map/widget/marker_info_window.dart';

class MapTapMarkerPage extends StatefulWidget {
  const MapTapMarkerPage({super.key});

  @override
  State<MapTapMarkerPage> createState() => _MapTapMarkerPageState();
}

class _MapTapMarkerPageState extends State<MapTapMarkerPage> {
  final InfoWindowController _windowController = InfoWindowController();
  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(23.8103, 90.4125),
    zoom: 14,
  );
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  Set<Circle> _circles = {};

  void _onMapCreated(GoogleMapController controller) {
    _windowController.googleMapController = controller;
    _mapController = controller;
  }

  Future<BitmapDescriptor> _getCustomMarker() async {
    const Widget markerWidget = MarkerIcon(text: '4.8*');
    final BitmapDescriptor descriptor = await markerWidget.toBitmapDescriptor();
    return descriptor;
  }

  void _onMarkerTap(LatLng position) {
    _windowController.addInfoWindow!(
      const InfoWindowWidget(height: 100, width: 200),
      position,
      50,
      100,
      200,
    );
  }

  void _onMapTapped(LatLng position) async {
    _windowController.hideInfoWindow!();
    BitmapDescriptor customIcon = await _getCustomMarker();
    setState(() {
      _markers = {
        Marker(
          markerId: const MarkerId('user_marker'),
          icon: customIcon,
          position: position,
          onTap: () => _onMarkerTap(position),
        ),
      };
      _circles = {
        Circle(
          radius: 1000,
          strokeWidth: 1,
          center: position,
          strokeColor: Colors.red,
          fillColor: Colors.red.withValues(alpha: 0.2),
          circleId: const CircleId('currentPositionCircle'),
        ),
      };
    });

    _mapController?.animateCamera(CameraUpdate.newLatLng(position));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tap to Place Marker')),
      body: Stack(
        children: [
          GoogleMap(
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            initialCameraPosition: _initialPosition,
            markers: _markers,
            circles: _circles,
            onTap: _onMapTapped,
            onMapCreated: _onMapCreated,
            onCameraMove: (position) => _windowController.onCameraMove!(),
          ),
          MarkerInfoWindow(controller: _windowController),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _windowController.dispose();
    _mapController?.dispose();
    super.dispose();
  }
}
