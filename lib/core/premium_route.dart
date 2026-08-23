import 'package:flutter/material.dart';

Route<T> premiumRoute<T>({
  required WidgetBuilder builder,
  RouteSettings? settings,
}) {
  return PageRouteBuilder<T>(
    settings: settings,
    transitionDuration: const Duration(
      milliseconds: 360,
    ),
    reverseTransitionDuration:
        const Duration(
      milliseconds: 300,
    ),
    pageBuilder: (
      context,
      animation,
      secondaryAnimation,
    ) {
      return builder(context);
    },
    transitionsBuilder: (
      context,
      animation,
      secondaryAnimation,
      child,
    ) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
        reverseCurve:
            Curves.easeInCubic,
      );

      final fade = Tween<double>(
        begin: 0.92,
        end: 1,
      ).animate(
        curved,
      );

      final slide = Tween<Offset>(
        begin: const Offset(
          0.035,
          0,
        ),
        end: Offset.zero,
      ).animate(
        curved,
      );

      return FadeTransition(
        opacity: fade,
        child: SlideTransition(
          position: slide,
          child: child,
        ),
      );
    },
  );
}