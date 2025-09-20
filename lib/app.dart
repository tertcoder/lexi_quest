import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/theme/app_theme.dart';
import 'routes.dart';
import 'features/annotation/bloc/annotation_bloc.dart';
import 'features/gamification/bloc/gamification_bloc.dart';

/// Root widget with GoRouter setup
class LexiQuestApp extends StatelessWidget {
  const LexiQuestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AnnotationBloc>(create: (context) => AnnotationBloc()),
        BlocProvider<GamificationBloc>(create: (context) => GamificationBloc()),
      ],
      child: MaterialApp.router(
        title: 'LexiQuest',
        debugShowCheckedModeBanner: false,

        // Theme configuration
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,

        // GoRouter configuration
        routerConfig: AppRoutes.router,
      ),
    );
  }
}
