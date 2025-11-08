import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:lexi_quest/features/auth/ui/login_screen.dart';
import 'package:lexi_quest/features/auth/ui/signup_screen.dart';
import 'package:lexi_quest/features/auth/ui/forgot_password_screen.dart';
import 'package:lexi_quest/features/auth/ui/change_password_screen.dart';
import 'package:lexi_quest/features/home/ui/home_screen.dart';
import 'package:lexi_quest/features/annotation/ui/text_annotation_screen.dart';
import 'package:lexi_quest/features/annotation/ui/image_annotation_screen.dart';
import 'package:lexi_quest/features/annotation/ui/audio_annotation_screen.dart';
import 'package:lexi_quest/features/leaderboard/ui/leaderboard_screen.dart';
import 'package:lexi_quest/features/profile/ui/profile_screen.dart';
import 'package:lexi_quest/features/profile/ui/edit_profile_screen.dart';
import 'package:lexi_quest/features/settings/ui/settings_screen.dart';
import 'package:lexi_quest/features/projects/ui/projects_screen.dart';
import 'package:lexi_quest/features/projects/ui/project_details_screen.dart';
import 'package:lexi_quest/features/projects/ui/create_project_screen.dart';
import 'package:lexi_quest/features/projects/ui/edit_project_screen.dart';
import 'package:lexi_quest/features/projects/bloc/projects_bloc.dart';
import 'package:lexi_quest/core/widgets/main_navigation.dart';
import 'package:lexi_quest/core/config/supabase_config.dart';
import 'package:lexi_quest/features/splash/splash_screen.dart';
import 'features/auth/ui/welcome_screen.dart';
import 'core/widgets/theme_preview_screen.dart';

/// Stream wrapper for GoRouter to listen to auth state changes
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<AuthState> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
          (AuthState _) => notifyListeners(),
        );
  }

  late final StreamSubscription<AuthState> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

/// App-wide route definitions using GoRouter
class AppRoutes {
  // Route paths
  static const String splash = '/';
  static const String welcome = '/welcome';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String changePassword = '/change-password';
  static const String home = '/home';
  static const String mainNav = '/main';
  static const String profile = '/profile';
  static const String editProfile = '/profile/edit';
  static const String leaderboard = '/leaderboard';
  static const String projects = '/projects';
  static const String projectDetails = '/projects/details';
  static const String createProject = '/projects/create';
  static const String editProject = '/projects/edit';
  static const String annotation = '/annotation';
  static const String textAnnotation = '/annotation/text';
  static const String imageAnnotation = '/annotation/image';
  static const String audioAnnotation = '/annotation/audio';
  static const String statistics = '/statistics';
  static const String settings = '/settings';
  static const String themePreview = '/theme-preview'; // Debug route

  /// GoRouter configuration
  static final GoRouter router = GoRouter(
    initialLocation: splash, // Start with splash screen
    debugLogDiagnostics: true,
    refreshListenable: GoRouterRefreshStream(SupabaseConfig.client.auth.onAuthStateChange),
    redirect: (context, state) {
      // Allow splash screen to always load
      if (state.matchedLocation == splash) {
        return null;
      }

      final isAuthenticated = SupabaseConfig.client.auth.currentUser != null;
      final isGoingToAuth = state.matchedLocation == welcome ||
          state.matchedLocation == login ||
          state.matchedLocation == register ||
          state.matchedLocation == forgotPassword ||
          state.matchedLocation == themePreview; // Allow theme preview

      // If not authenticated and trying to access protected route, redirect to welcome
      if (!isAuthenticated && !isGoingToAuth) {
        return welcome;
      }

      // If authenticated and trying to access auth screens, redirect to main
      if (isAuthenticated && (state.matchedLocation == welcome || state.matchedLocation == login || state.matchedLocation == register)) {
        return mainNav;
      }

      return null; // No redirect needed
    },
    routes: [
      GoRoute(
        path: splash,
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
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
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: register,
        name: 'register',
        builder: (context, state) => const SignUpScreen(),
      ),
      GoRoute(
        path: forgotPassword,
        name: 'forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: changePassword,
        name: 'change-password',
        builder: (context, state) => const ChangePasswordScreen(),
      ),
      GoRoute(
        path: home,
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: mainNav,
        name: 'main',
        builder: (context, state) => const MainNavigation(),
      ),
      GoRoute(
        path: profile,
        name: 'profile',
        builder: (context, state) => const ProfileScreen(),
        routes: [
          GoRoute(
            path: 'edit',
            name: 'edit-profile',
            builder: (context, state) => const EditProfileScreen(),
          ),
        ],
      ),
      GoRoute(
        path: leaderboard,
        name: 'leaderboard',
        builder: (context, state) => const LeaderboardScreen(),
      ),
      GoRoute(
        path: projects,
        name: 'projects',
        builder: (context, state) => const ProjectsScreen(),
      ),
      GoRoute(
        path: '$projectDetails/:id',
        name: 'project-details',
        builder: (context, state) {
          final projectId = state.pathParameters['id']!;
          return ProjectDetailsScreen(projectId: projectId);
        },
      ),
      GoRoute(
        path: createProject,
        name: 'create-project',
        builder: (context, state) => BlocProvider(
          create: (context) => ProjectsBloc(),
          child: const CreateProjectScreen(),
        ),
      ),
      GoRoute(
        path: '$editProject/:id',
        name: 'edit-project',
        builder: (context, state) {
          final projectId = state.pathParameters['id']!;
          return EditProjectScreen(projectId: projectId);
        },
      ),
      GoRoute(
        path: annotation,
        name: 'annotation',
        builder: (context, state) => Scaffold(
          appBar: AppBar(title: const Text('Select Annotation Type')),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => context.push(textAnnotation),
                  child: const Text('Text Annotation'),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => context.push(imageAnnotation),
                  child: const Text('Image Annotation'),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => context.push(audioAnnotation),
                  child: const Text('Audio Annotation'),
                ),
              ],
            ),
          ),
        ),
      ),
      GoRoute(
        path: textAnnotation,
        name: 'text-annotation',
        builder: (context, state) {
          final projectId = state.uri.queryParameters['projectId'];
          return TextAnnotationScreen(projectId: projectId);
        },
      ),
      GoRoute(
        path: imageAnnotation,
        name: 'image-annotation',
        builder: (context, state) {
          final projectId = state.uri.queryParameters['projectId'];
          return ImageAnnotationScreen(projectId: projectId);
        },
      ),
      GoRoute(
        path: audioAnnotation,
        name: 'audio-annotation',
        builder: (context, state) {
          final projectId = state.uri.queryParameters['projectId'];
          return AudioAnnotationScreen(projectId: projectId);
        },
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
        builder: (context, state) => const SettingsScreen(),
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

  static void navigateToMainNav(BuildContext context) {
    context.go(mainNav);
  }

  static void navigateToProfile(BuildContext context) {
    context.push(profile);
  }

  static void navigateToLeaderboard(BuildContext context) {
    context.push(leaderboard);
  }

  static void navigateToAnnotation(BuildContext context) {
    context.push(annotation);
  }

  static void navigateToTextAnnotation(BuildContext context) {
    context.push(textAnnotation);
  }

  static void navigateToImageAnnotation(BuildContext context) {
    context.push(imageAnnotation);
  }

  static void navigateToAudioAnnotation(BuildContext context) {
    context.push(audioAnnotation);
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

  static void navigateToMainNavNamed(BuildContext context) {
    context.goNamed('main');
  }

  static void navigateToProfileNamed(BuildContext context) {
    context.pushNamed('profile');
  }

  static void navigateToLeaderboardNamed(BuildContext context) {
    context.pushNamed('leaderboard');
  }

  static void navigateToAnnotationNamed(BuildContext context) {
    context.pushNamed('annotation');
  }

  static void navigateToTextAnnotationNamed(BuildContext context) {
    context.pushNamed('text-annotation');
  }

  static void navigateToImageAnnotationNamed(BuildContext context) {
    context.pushNamed('image-annotation');
  }

  static void navigateToAudioAnnotationNamed(BuildContext context) {
    context.pushNamed('audio-annotation');
  }

  static void navigateToStatisticsNamed(BuildContext context) {
    context.pushNamed('statistics');
  }

  static void navigateToSettingsNamed(BuildContext context) {
    context.pushNamed('settings');
  }

  static void navigateToThemePreviewNamed(BuildContext context) {
    context.pushNamed('theme-preview');
  }
}
