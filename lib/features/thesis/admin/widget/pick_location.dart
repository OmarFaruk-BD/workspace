import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PickLocationDialog extends StatefulWidget {
  const PickLocationDialog({super.key});

  @override
  State<PickLocationDialog> createState() => _PickLocationDialogState();
}

class _PickLocationDialogState extends State<PickLocationDialog> {
  // ignore: unused_field
  GoogleMapController? _mapController;
  LatLng? _selectedLocation;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: SizedBox(
          width: double.maxFinite,
          height: MediaQuery.of(context).size.height * 0.75,
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                const Text(
                  "Pick Location",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 15),
                Expanded(
                  child: GoogleMap(
                    initialCameraPosition: const CameraPosition(
                      target: LatLng(23.8103, 90.4125),
                      zoom: 12,
                    ),
                    onMapCreated: (controller) => _mapController = controller,
                    onTap: (LatLng position) {
                      setState(() => _selectedLocation = position);
                    },
                    markers: _selectedLocation != null
                        ? {
                            Marker(
                              markerId: const MarkerId("picked"),
                              position: _selectedLocation!,
                              icon: BitmapDescriptor.defaultMarkerWithHue(
                                BitmapDescriptor.hueRed,
                              ),
                            ),
                          }
                        : {},
                  ),
                ),
                const SizedBox(height: 12),
                if (_selectedLocation != null)
                  Text(
                    "Lat: ${_selectedLocation!.latitude.toStringAsFixed(4)}, "
                    "Lng: ${_selectedLocation!.longitude.toStringAsFixed(4)}",
                    style: const TextStyle(fontSize: 14),
                  )
                else
                  const Text(
                    "Tap on the map to select a location",
                    style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
                  ),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Close"),
                    ),
                    ElevatedButton(
                      onPressed: _selectedLocation == null
                          ? null
                          : () => Navigator.pop(context, _selectedLocation),
                      child: const Text("Pick"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
