import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'features/auth/ui/welcome_screen.dart';
import 'core/widgets/theme_preview_screen.dart';

/// App-wide route definitions using GoRouter
class AppRoutes {
  // Route paths
  static const String welcome = '/welcome';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String profile = '/profile';
  static const String annotation = '/annotation';
  static const String statistics = '/statistics';
  static const String settings = '/settings';
  static const String themePreview = '/theme-preview'; // Debug route

  /// GoRouter configuration
  static final GoRouter router = GoRouter(
    initialLocation: welcome,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: welcome,
        name: 'welcome',
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: themePreview,
        name: 'theme-preview',
        builder: (context, state) => const ThemePreviewScreen(),
      ),
      GoRoute(
        path: login,
        name: 'login',
        builder:
            (context, state) => const Scaffold(
              body: Center(child: Text('Login Screen - Coming Soon')),
            ),
      ),
      GoRoute(
        path: register,
        name: 'register',
        builder:
            (context, state) => const Scaffold(
              body: Center(child: Text('Register Screen - Coming Soon')),
            ),
      ),
      GoRoute(
        path: home,
        name: 'home',
        builder:
            (context, state) => const Scaffold(
              body: Center(child: Text('Home Screen - Coming Soon')),
            ),
      ),
      GoRoute(
        path: profile,
        name: 'profile',
        builder:
            (context, state) => const Scaffold(
              body: Center(child: Text('Profile Screen - Coming Soon')),
            ),
      ),
      GoRoute(
        path: annotation,
        name: 'annotation',
        builder:
            (context, state) => const Scaffold(
              body: Center(child: Text('Annotation Screen - Coming Soon')),
            ),
      ),
      GoRoute(
        path: statistics,
        name: 'statistics',
        builder:
            (context, state) => const Scaffold(
              body: Center(child: Text('Statistics Screen - Coming Soon')),
            ),
      ),
      GoRoute(
        path: settings,
        name: 'settings',
        builder:
            (context, state) => const Scaffold(
              body: Center(child: Text('Settings Screen - Coming Soon')),
            ),
      ),
    ],
    errorBuilder:
        (context, state) => Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  'Page Not Found',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  'The page "${state.uri}" could not be found.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => context.go(welcome),
                  child: const Text('Go to Welcome'),
                ),
              ],
            ),
          ),
        ),
  );

  /// Navigation helper methods using GoRouter
  static void navigateToWelcome(BuildContext context) {
    context.go(welcome);
  }

  static void navigateToLogin(BuildContext context) {
    context.push(login);
  }

  static void navigateToRegister(BuildContext context) {
    context.push(register);
  }

  static void navigateToHome(BuildContext context) {
    context.go(home);
  }

  static void navigateToProfile(BuildContext context) {
    context.push(profile);
  }

  static void navigateToAnnotation(BuildContext context) {
    context.push(annotation);
  }

  static void navigateToStatistics(BuildContext context) {
    context.push(statistics);
  }

  static void navigateToSettings(BuildContext context) {
    context.push(settings);
  }

  static void navigateToThemePreview(BuildContext context) {
    context.push(themePreview);
  }

  /// Navigation helper methods with named routes
  static void navigateToWelcomeNamed(BuildContext context) {
    context.goNamed('welcome');
  }

  static void navigateToLoginNamed(BuildContext context) {
    context.pushNamed('login');
  }

  static void navigateToRegisterNamed(BuildContext context) {
    context.pushNamed('register');
  }

  static void navigateToHomeNamed(BuildContext context) {
    context.goNamed('home');
  }

  static void navigateToProfileNamed(BuildContext context) {
    context.pushNamed('profile');
  }

  static void navigateToAnnotationNamed(BuildContext context) {
    context.pushNamed('annotation');
  }

  static void navigateToStatisticsNamed(BuildContext context) {
    context.pushNamed('statistics');
  }

  static void navigateToSettingsNamed(BuildContext context) {
    context.pushNamed('settings');
  }
}
