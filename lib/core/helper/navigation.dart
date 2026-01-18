import 'package:flutter/material.dart';

class AppNavigator {
  static const Duration _duration = Duration(milliseconds: 300);

  static Future<T?> push<T>(BuildContext context, Widget widget) {
    return Navigator.push<T>(
      context,
      MaterialPageRoute(builder: (_) => widget),
    );
  }

  static Future<T?> pushAndRemoveUntil<T>(BuildContext context, Widget widget) {
    return Navigator.pushAndRemoveUntil<T>(
      context,
      MaterialPageRoute(builder: (_) => widget),
      (Route<dynamic> route) => false,
    );
  }

  static void pop<T>(BuildContext context) => Navigator.pop<T>(context);

  static Future<T?> pushTo<T>(BuildContext context, Widget widget) {
    return Navigator.push<T>(
      context,
      PageRouteBuilder<T>(
        transitionDuration: _duration,
        reverseTransitionDuration: _duration,
        pageBuilder: (context, animation, secondaryAnimation) => widget,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          // return FadeTransition(opacity: animation, child: child);
          // return ScaleTransition(scale: animation, child: child);

          final tween = Tween(begin: const Offset(1, 0), end: Offset.zero);
          final curve = CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOut,
          );
          return SlideTransition(position: tween.animate(curve), child: child);
        },
      ),
    );
  }

  static Future<T?> pushAndRemoveUntilTo<T>(
    BuildContext context,
    Widget widget,
  ) {
    return Navigator.of(context).pushAndRemoveUntil<T>(
      PageRouteBuilder<T>(
        transitionDuration: _duration,
        reverseTransitionDuration: _duration,
        pageBuilder: (context, animation, secondaryAnimation) => widget,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final tween = Tween(begin: const Offset(0, 1), end: Offset.zero);
          final curve = CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOut,
          );
          return SlideTransition(position: tween.animate(curve), child: child);
        },
      ),
      (Route<dynamic> route) => false,
    );
  }
}
