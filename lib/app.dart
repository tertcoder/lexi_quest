import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'routes.dart';

/// Root widget with GoRouter setup
class LexiQuestApp extends StatelessWidget {
  const LexiQuestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'LexiQuest',
      debugShowCheckedModeBanner: false,

      // Theme configuration
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,

      // GoRouter configuration
      routerConfig: AppRoutes.router,
    );
  }
}
