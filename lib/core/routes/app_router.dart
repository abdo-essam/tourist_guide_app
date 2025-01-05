import 'package:flutter/material.dart';
import 'package:tourist_guide_app/core/theme/app_colors.dart';

import '../../data/models/governorate.dart';
import '../../screens/auth/login_page.dart';
import '../../screens/auth/signup_page.dart';
import '../../screens/governorates/landmarks_page.dart';
import '../../screens/main_layout.dart';
import 'route_transitions.dart';

class AppRouter {
  static const String signup = '/signup';
  static const String login = '/login';
  static const String home = '/home';
  static const String governorates = '/governorates';
  static const String landMark = '/landmark';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments as Map<String, dynamic>?;
    switch (settings.name) {
      case signup:
        return RouteTransitions.fadeTransition(const SignupPage());
      case login:
        return RouteTransitions.slideUpTransition(const LoginPage());
      case home:
        return RouteTransitions.custom(MainLayout());
      case landMark:
          return RouteTransitions.fadeTransition(LandmarksPage(governorate: args!['governorate'] as Governorate));
      default:
        return _errorRoute('No route defined for ${settings.name}');
    }
  }
  static Route<dynamic> _errorRoute(String message) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              message,
              style: TextStyle(color: AppColors.error),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}