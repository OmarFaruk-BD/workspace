import 'package:flutter/cupertino.dart' show CupertinoPageRoute;
import 'package:animations/animations.dart' show OpenContainer;
import 'package:flutter/material.dart';

class AppNavigator {
  static const Duration _duration = Duration(milliseconds: 350);

  static Future<T?> push<T>(BuildContext context, Widget widget) {
    return Navigator.push<T>(
      context,
      CupertinoPageRoute(builder: (_) => widget),
    );
    // return Navigator.push<T>(
    //   context,
    //   MaterialPageRoute(builder: (_) => widget),
    // );
  }

  static Future<T?> pushAndRemoveUntil<T>(BuildContext context, Widget widget) {
    return Navigator.pushAndRemoveUntil<T>(
      context,
      MaterialPageRoute(builder: (_) => widget),
      (Route<dynamic> route) => false,
    );
  }

  static void pop<T>(BuildContext context) => Navigator.pop<T>(context);

  static Future<T?> pushAnimated<T>(BuildContext context, Widget widget) {
    return Navigator.push<T>(
      context,
      PageRouteBuilder<T>(
        transitionDuration: _duration,
        reverseTransitionDuration: _duration,
        pageBuilder: (context, animation, secondaryAnimation) => widget,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          // return FadeThroughTransition(
          //   animation: animation,
          //   secondaryAnimation: secondaryAnimation,
          //   child: child,
          // );

          // return SharedAxisTransition(
          //   animation: animation,
          //   secondaryAnimation: secondaryAnimation,
          //   transitionType: SharedAxisTransitionType.horizontal,
          //   child: child,
          // );

          // return FadeScaleTransition(animation: animation, child: child);

          // return FadeTransition(opacity: animation, child: child);

          // return ScaleTransition(scale: animation, child: child);

          final tween = Tween(begin: const Offset(1, 0), end: Offset.zero);
          final curve = CurvedAnimation(
            parent: animation,
            curve: Curves.linearToEaseOut,
            reverseCurve: Curves.easeInToLinear,
          );
          return SlideTransition(position: tween.animate(curve), child: child);
        },
      ),
    );
  }

  static Widget openContainer({
    required Widget child,
    required Widget navigateTo,
    ValueChanged<dynamic>? onClosed,
  }) {
    return OpenContainer(
      openElevation: 0,
      closedElevation: 0,
      onClosed: onClosed,
      closedBuilder: (_, _) => child,
      openBuilder: (_, _) => navigateTo,
    );
  }
}
