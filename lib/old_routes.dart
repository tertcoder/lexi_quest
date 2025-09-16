import 'package:flutter/material.dart';
import 'features/auth/ui/welcome_screen.dart';
import 'core/widgets/theme_preview_screen.dart';

/// App-wide route definitions
class AppRoutes {
  // Route names
  static const String welcome = '/welcome';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String profile = '/profile';
  static const String annotation = '/annotation';
  static const String statistics = '/statistics';
  static const String settings = '/settings';
  static const String themePreview = '/theme-preview'; // Debug route

  /// Generate routes for the app
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case welcome:
        return MaterialPageRoute(
          builder: (_) => const WelcomeScreen(),
          settings: settings,
        );

      case themePreview:
        return MaterialPageRoute(
          builder: (_) => const ThemePreviewScreen(),
          settings: settings,
        );

      case login:
        return MaterialPageRoute(
          builder:
              (_) => const Scaffold(
                body: Center(child: Text('Login Screen - Coming Soon')),
              ),
          settings: settings,
        );

      case register:
        return MaterialPageRoute(
          builder:
              (_) => const Scaffold(
                body: Center(child: Text('Register Screen - Coming Soon')),
              ),
          settings: settings,
        );

      case home:
        return MaterialPageRoute(
          builder:
              (_) => const Scaffold(
                body: Center(child: Text('Home Screen - Coming Soon')),
              ),
          settings: settings,
        );

      case profile:
        return MaterialPageRoute(
          builder:
              (_) => const Scaffold(
                body: Center(child: Text('Profile Screen - Coming Soon')),
              ),
          settings: settings,
        );

      case annotation:
        return MaterialPageRoute(
          builder:
              (_) => const Scaffold(
                body: Center(child: Text('Annotation Screen - Coming Soon')),
              ),
          settings: settings,
        );

      case statistics:
        return MaterialPageRoute(
          builder:
              (_) => const Scaffold(
                body: Center(child: Text('Statistics Screen - Coming Soon')),
              ),
          settings: settings,
        );

      case AppRoutes.settings:
        return MaterialPageRoute(
          builder:
              (_) => const Scaffold(
                body: Center(child: Text('Settings Screen - Coming Soon')),
              ),
          settings: settings,
        );

      default:
        return MaterialPageRoute(
          builder:
              (_) =>
                  const Scaffold(body: Center(child: Text('Page Not Found'))),
          settings: settings,
        );
    }
  }

  /// Navigation helper methods
  static void navigateToWelcome(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(context, welcome, (route) => false);
  }

  static void navigateToLogin(BuildContext context) {
    Navigator.pushNamed(context, login);
  }

  static void navigateToRegister(BuildContext context) {
    Navigator.pushNamed(context, register);
  }

  static void navigateToHome(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(context, home, (route) => false);
  }

  static void navigateToProfile(BuildContext context) {
    Navigator.pushNamed(context, profile);
  }

  static void navigateToAnnotation(BuildContext context) {
    Navigator.pushNamed(context, annotation);
  }

  static void navigateToStatistics(BuildContext context) {
    Navigator.pushNamed(context, statistics);
  }

  static void navigateToSettings(BuildContext context) {
    Navigator.pushNamed(context, settings);
  }

  static void navigateToThemePreview(BuildContext context) {
    Navigator.pushNamed(context, themePreview);
  }
}
