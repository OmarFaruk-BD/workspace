import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key, required this.startPoint, required this.endPoint});
  final GeoPoint startPoint;
  final GeoPoint endPoint;

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late final MapController controller;
  bool isFocusToCar = false;
  late final GeoPoint start;
  late final GeoPoint end;

  @override
  void initState() {
    super.initState();
    end = widget.endPoint;
    start = widget.startPoint;
    controller = MapController(initPosition: start);
  }

  Future<void> _drawRoute() async {
    await Future.delayed(const Duration(milliseconds: 500));
    await controller.addMarker(
      start,
      markerIcon: MarkerIcon(
        icon: Icon(Icons.location_pin, color: Colors.green, size: 48),
      ),
    );

    await controller.addMarker(
      end,
      markerIcon: MarkerIcon(
        icon: Icon(Icons.location_pin, color: Colors.blue, size: 48),
      ),
    );

    await controller.zoomToBoundingBox(
      BoundingBox(
        north: start.latitude,
        east: start.longitude,
        south: end.latitude,
        west: end.longitude,
      ),
      paddinInPixel: 80,
    );

    await _moveCarAlongRoad();
  }

  Future<void> _moveCarAlongRoad() async {
    RoadInfo roadInfo = await controller.drawRoad(
      start,
      end,
      roadType: RoadType.car,
      roadOption: RoadOption(roadColor: Colors.red, roadWidth: 6),
    );

    List<GeoPoint> points = roadInfo.route;

    await controller.addMarker(
      points.first,
      markerIcon: MarkerIcon(
        icon: Icon(Icons.directions_car, color: Colors.black, size: 50),
      ),
    );

    GeoPoint oldPoint = points.first;

    for (int i = 1; i < points.length; i++) {
      await Future.delayed(const Duration(milliseconds: 20));
      GeoPoint newPoint = points[i];
      await controller.changeLocationMarker(
        oldLocation: oldPoint,
        newLocation: newPoint,
      );
      oldPoint = newPoint;
      if (isFocusToCar) {
        await controller.moveTo(newPoint);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Open Street Map'), centerTitle: true),
      body: SafeArea(
        child: OSMFlutter(
          controller: controller,
          onMapIsReady: (value) async {
            await Future.delayed(const Duration(seconds: 1));
            await _drawRoute();
          },
          osmOption: OSMOption(
            isPicker: false,
            zoomOption: ZoomOption(
              initZoom: 7,
              minZoomLevel: 3,
              maxZoomLevel: 18,
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.directions),
        onPressed: () => setState(() => isFocusToCar = true),
      ),
    );
  }
}
