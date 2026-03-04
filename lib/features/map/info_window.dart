import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

typedef AddInfoWindow = Function(Widget, LatLng, double, double, double);

class CustomInfoWindowController {
  AddInfoWindow? addInfoWindow;
  VoidCallback? onCameraMove;
  VoidCallback? hideInfoWindow;
  VoidCallback? showInfoWindow;
  GoogleMapController? googleMapController;

  void dispose() {
    addInfoWindow = null;
    onCameraMove = null;
    hideInfoWindow = null;
    showInfoWindow = null;
    googleMapController = null;
  }
}

class CustomInfoWindow extends StatefulWidget {
  final CustomInfoWindowController controller;

  const CustomInfoWindow({super.key, required this.controller});

  @override
  CustomInfoWindowState createState() => CustomInfoWindowState();
}

class CustomInfoWindowState extends State<CustomInfoWindow> {
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
    widget.controller.addInfoWindow = _addInfoWindow;
    widget.controller.onCameraMove = _onCameraMove;
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
      _leftMargin = left;
      _topMargin = top;
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

class InfoWindowWidget extends StatelessWidget {
  const InfoWindowWidget({
    super.key,
    required this.width,
    required this.height,
  });
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(4),
              ),
              width: double.infinity,
              height: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.account_circle,
                      color: Colors.white,
                      size: 30,
                    ),
                    const SizedBox(width: 8.0),
                    Text(
                      "I am here",
                      style: Theme.of(
                        context,
                      ).textTheme.titleLarge?.copyWith(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
