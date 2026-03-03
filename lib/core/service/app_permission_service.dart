import 'dart:async';

import 'package:flutter/material.dart';
import 'package:workspace/core/components/app_popup.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:workspace/core/components/app_alert_dialog.dart';

class AppPermissionService with WidgetsBindingObserver {
  AppPermissionService() {
    WidgetsBinding.instance.addObserver(this);
  }

  Completer<bool>? _settingsCompleter;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed && _settingsCompleter != null) {
      final status = await Permission.location.status;
      _settingsCompleter?.complete(status.isGranted);
      _settingsCompleter = null;
    }
  }

  Future<bool> locationPermission(BuildContext context) async {
    final status = await Permission.location.status;

    if (status.isGranted || status.isLimited) return true;

    if (status.isDenied) {
      final newStatus = await Permission.location.request();
      return newStatus.isGranted;
    }

    if (status.isPermanentlyDenied || status.isRestricted) {
      if (!context.mounted) return false;

      final onApprove = await AppPopup.show<bool>(
        context: context,
        widget: const AppAlertDialog(
          title: 'Location Access Needed',
          content: 'Please enable location permission in settings.',
        ),
      );
      if (onApprove == true) {
        _settingsCompleter = Completer<bool>();
        await openAppSettings();
      }

      return _settingsCompleter != null
          ? await _settingsCompleter!.future
          : false;
    }

    return false;
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
  }
}
