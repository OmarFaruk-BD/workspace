import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapTapMarkerPage extends StatefulWidget {
  const MapTapMarkerPage({super.key});

  @override
  State<MapTapMarkerPage> createState() => _MapTapMarkerPageState();
}

class _MapTapMarkerPageState extends State<MapTapMarkerPage> {
  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(23.8103, 90.4125),
    zoom: 14,
  );

  GoogleMapController? _mapController;

  Set<Marker> _markers = {};

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void _onMapTapped(LatLng position) {
    setState(() {
      _markers = {
        Marker(
          markerId: const MarkerId('user_marker'),
          position: position,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),

          infoWindow: const InfoWindow(
            title: 'Selected Location',
            snippet: 'Tap again to change',
          ),
        ),
      };
    });

    _mapController?.animateCamera(CameraUpdate.newLatLng(position));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tap to Place Red Marker')),
      body: GoogleMap(
        initialCameraPosition: _initialPosition,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        markers: _markers,
        onMapCreated: _onMapCreated,
        onTap: _onMapTapped,
      ),
    );
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
}
