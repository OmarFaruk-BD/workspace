import 'package:flutter/material.dart';

class AppPopup {
  const AppPopup._();

  static Future<T?> show<T>({
    required Widget widget,
    bool dismissible = true,
    required BuildContext context,
    Color barrierColor = Colors.black54,
  }) async {
    return await showDialog<T>(
      context: context,
      barrierColor: barrierColor,
      barrierDismissible: dismissible,
      builder: (BuildContext context) => widget,
    );
  }

  static Future<T?> showAnimated<T>({
    required Widget child,
    bool dismissible = true,
    required BuildContext context,
  }) async {
    return await showGeneralDialog<T>(
      context: context,
      barrierDismissible: dismissible,
      barrierColor: Colors.black.withAlpha(125),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation1, animation2) => child,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      transitionBuilder: (context, a1, a2, widget) {
        return Transform.scale(
          scale: a1.value,
          child: Opacity(opacity: a1.value, child: widget),
        );
      },
    );
  }
}
