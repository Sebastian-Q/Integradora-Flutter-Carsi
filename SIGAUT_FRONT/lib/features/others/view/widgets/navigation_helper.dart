import 'package:flutter/material.dart';

class NavigationHelper {
  static Future navigateReplacement(BuildContext context, Widget page) {
    return Navigator.pushReplacement(
      context,
      _animatedRoute(page),
    );
  }

  static Future navigate(BuildContext context, Widget page) {
    return Navigator.push(
      context,
      _animatedRoute(page),
    );
  }

  /// 🔥 Animación personalizada para toda la app
  static PageRouteBuilder _animatedRoute(Widget page) {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 280),
      reverseTransitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (context, animation, secondaryAnimation) => page,

      /// Animación Slide + Fade
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final offsetAnimation = Tween(
          begin: const Offset(0.10, 0), // suave desde la derecha
          end: Offset.zero,
        ).animate(
          CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
        );

        final fadeAnimation = Tween<double>(
          begin: 0,
          end: 1,
        ).animate(
          CurvedAnimation(parent: animation, curve: Curves.easeOut),
        );

        return FadeTransition(
          opacity: fadeAnimation,
          child: SlideTransition(
            position: offsetAnimation,
            child: child,
          ),
        );
      },
    );
  }
}
