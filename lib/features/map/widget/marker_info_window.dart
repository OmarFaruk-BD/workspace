import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

typedef AddMarkerInfoWindow = Function(Widget, LatLng, double, double, double);

class InfoWindowController {
  VoidCallback? onCameraMove;
  VoidCallback? hideInfoWindow;
  VoidCallback? showInfoWindow;
  AddMarkerInfoWindow? addInfoWindow;
  GoogleMapController? googleMapController;

  void dispose() {
    addInfoWindow = null;
    onCameraMove = null;
    hideInfoWindow = null;
    showInfoWindow = null;
    googleMapController = null;
  }
}

class MarkerInfoWindow extends StatefulWidget {
  final InfoWindowController controller;

  const MarkerInfoWindow({super.key, required this.controller});

  @override
  MarkerInfoWindowState createState() => MarkerInfoWindowState();
}

class MarkerInfoWindowState extends State<MarkerInfoWindow> {
  bool _showNow = false;
  double _leftMargin = 0;
  double _topMargin = 0;
  Widget? _child;
  LatLng? _latLng;
  double? _offset;
  double? _height;
  double? _width;

  @override
  void initState() {
    super.initState();
    widget.controller.onCameraMove = _onCameraMove;
    widget.controller.addInfoWindow = _addInfoWindow;
    widget.controller.hideInfoWindow = _hideInfoWindow;
    widget.controller.showInfoWindow = _showInfoWindow;
  }

  void _updateInfoWindow() async {
    if (_latLng == null ||
        _child == null ||
        _offset == null ||
        _height == null ||
        _width == null ||
        widget.controller.googleMapController == null) {
      return;
    }
    ScreenCoordinate screenCoordinate = await widget
        .controller
        .googleMapController!
        .getScreenCoordinate(_latLng!);
    if (!mounted) return;

    double devicePixelRatio =
        Theme.of(context).platform == TargetPlatform.android
        ? MediaQuery.of(context).devicePixelRatio
        : 1.0;
    double left =
        (screenCoordinate.x.toDouble() / devicePixelRatio) - (_width! / 2);
    double top =
        (screenCoordinate.y.toDouble() / devicePixelRatio) -
        (_offset! + _height!);
    setState(() {
      _showNow = true;
      _topMargin = top;
      _leftMargin = left;
    });
  }

  void _addInfoWindow(
    Widget child,
    LatLng latLng,
    double offset,
    double height,
    double width,
  ) {
    _child = child;
    _latLng = latLng;
    _offset = offset;
    _height = height;
    _width = width;
    _updateInfoWindow();
  }

  void _onCameraMove() {
    if (!_showNow) return;
    _updateInfoWindow();
  }

  void _hideInfoWindow() {
    setState(() => _showNow = false);
  }

  void _showInfoWindow() {
    _updateInfoWindow();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: _leftMargin,
      top: _topMargin,
      child: Visibility(
        visible:
            (_showNow == false ||
                (_leftMargin == 0 && _topMargin == 0) ||
                _child == null ||
                _latLng == null)
            ? false
            : true,
        child: SizedBox(height: _height, width: _width, child: _child),
      ),
    );
  }
}
