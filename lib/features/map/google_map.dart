import 'package:flutter/material.dart';
import 'package:workspace/core/helper/navigation.dart';
import 'package:widget_to_marker/widget_to_marker.dart';
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

  Future<BitmapDescriptor> getCustomMarker() async {
    const Widget markerWidget = CustomMarkerWidget(text: "Hello Map");
    final BitmapDescriptor descriptor = await markerWidget.toBitmapDescriptor();
    return descriptor;
  }

  void _onMapTapped(LatLng position) async {
    BitmapDescriptor customIcon = await getCustomMarker();
    setState(() {
      _markers = {
        Marker(
          markerId: const MarkerId('user_marker'),
          position: position,
          icon: customIcon,
          onTap: () {
            AppNavigator.push(context, const DetailPage());
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
