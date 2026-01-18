import 'dart:async';

import 'package:flutter/material.dart';
import 'package:workspace/core/components/app_popup.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:workspace/core/components/approval_popup.dart';

class PermissionService with WidgetsBindingObserver {
  PermissionService() {
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
    var status = await Permission.location.status;

    if (status.isGranted || status.isLimited) return true;

    if (status.isDenied) {
      final newStatus = await Permission.location.request();
      return newStatus.isGranted;
    }

    if (status.isPermanentlyDenied || status.isRestricted) {
      if (!context.mounted) return false;

      await AppPopup.showAnimated(
        context: context,
        child: ApprovalWidget(
          title: 'Location Access Needed',
          description:
              'We use your location to show nearby restaurants and improve your experience. Please enable location permission in settings.',
          onApprove: () async {
            _settingsCompleter = Completer<bool>();
            await openAppSettings();
            if (!context.mounted) return;
            Navigator.of(context).pop();
          },
        ),
      );

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
