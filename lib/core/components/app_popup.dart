import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class AppPopup {
  const AppPopup._();

  static Future<T?> show<T>({
    required Widget widget,
    bool dismissible = true,
    required BuildContext context,
  }) async {
    return await showCupertinoDialog<T>(
      context: context,
      barrierDismissible: dismissible,
      builder: (context) => widget,
    );
  }

  static Future<T?> showAnimated<T>({
    required Widget widget,
    bool dismissible = true,
    required BuildContext context,
  }) async {
    return await showGeneralDialog<T>(
      context: context,
      barrierDismissible: dismissible,
      barrierColor: Colors.black.withAlpha(125),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation1, animation2) => widget,
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
