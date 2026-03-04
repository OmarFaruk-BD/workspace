import 'package:flutter/material.dart';
import 'package:widget_to_marker/widget_to_marker.dart';
import 'package:workspace/features/map/info_window.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapTapMarkerPage extends StatefulWidget {
  const MapTapMarkerPage({super.key});

  @override
  State<MapTapMarkerPage> createState() => _MapTapMarkerPageState();
}

class _MapTapMarkerPageState extends State<MapTapMarkerPage> {
  final CustomInfoWindowController _windowController =
      CustomInfoWindowController();

  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(23.8103, 90.4125),
    zoom: 14,
  );

  GoogleMapController? _mapController;

  Set<Marker> _markers = {};

  void _onMapCreated(GoogleMapController controller) {
    _windowController.googleMapController = controller;
    _mapController = controller;
  }

  Future<BitmapDescriptor> getCustomMarker() async {
    const Widget markerWidget = CustomMarkerWidget(text: '4.8*');
    final BitmapDescriptor descriptor = await markerWidget.toBitmapDescriptor();
    return descriptor;
  }

  void _onMapTapped(LatLng position) async {
    _windowController.hideInfoWindow!();
    BitmapDescriptor customIcon = await getCustomMarker();
    setState(() {
      _markers = {
        Marker(
          markerId: const MarkerId('user_marker'),
          position: position,
          icon: customIcon,
          onTap: () {
            _windowController.addInfoWindow!(
              const InfoWindowWidget(height: 100, width: 200),
              position,
              50,
              100,
              200,
            );
          },
        ),
      };
    });

    _mapController?.animateCamera(CameraUpdate.newLatLng(position));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tap to Place Red Marker')),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: _initialPosition,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            markers: _markers,
            onMapCreated: _onMapCreated,
            onTap: _onMapTapped,
            onCameraMove: (position) {
              _windowController.onCameraMove!();
            },
          ),
          CustomInfoWindow(controller: _windowController),
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

class CustomMarkerWidget extends StatelessWidget {
  final String text;

  const CustomMarkerWidget({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class DetailPage extends StatelessWidget {
  const DetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Page')),
      body: ListView(children: const [Center(child: Text('Detail Page'))]),
    );
  }
}



/*

class _MapTapMarkerPageState extends State<MapTapMarkerPage> {
  final CustomInfoWindowController _windowController =
      CustomInfoWindowController();

  final LatLng _latLng = const LatLng(28.7041, 77.1025);
  final double _zoom = 15.0;
  final double offset = 50;
  final double height = 75;
  final double width = 150;

  @override
  void dispose() {
    _windowController.dispose();
    super.dispose();
  }

  Set<Marker> markers = {};

  @override
  Widget build(BuildContext context) {
    markers.add(
      Marker(
        markerId: const MarkerId("marker_id"),
        position: _latLng,
        onTap: () {
          _windowController.addInfoWindow!(
            InfoWindowWidget(height: height, width: width),
            _latLng,
            offset,
            height,
            width,
          );
        },
      ),
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Info Window Example'),
        backgroundColor: Colors.red,
      ),
      body: Stack(
        children: <Widget>[
          GoogleMap(
            onTap: (position) {
              _windowController.hideInfoWindow!();
            },
            onCameraMove: (position) {
              _windowController.onCameraMove!();
            },
            onMapCreated: (GoogleMapController controller) async {
              _windowController.googleMapController = controller;
            },
            markers: markers,
            initialCameraPosition: CameraPosition(target: _latLng, zoom: _zoom),
          ),
          CustomInfoWindow(
            (top, left, width, height) => null,
            controller: _windowController,
          ),
        ],
      ),
    );
  }
}

*/