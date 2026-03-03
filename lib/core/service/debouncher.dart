import 'dart:async';

import 'package:flutter/material.dart';

class Debouncer {
  Debouncer({this.milliseconds = 800});
  final int milliseconds;
  VoidCallback? _action;
  Timer? _timer;

  void call(VoidCallback action) {
    _action = action;
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), _callAction);
  }

  void _callAction() {
    _action?.call();
    _timer = null;
  }

  void reset() {
    _action = null;
    _timer = null;
  }
}
