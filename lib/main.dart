import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lexi_quest/core/config/supabase_config.dart';
import 'package:lexi_quest/core/widgets/celebration_manager.dart';
import 'package:lexi_quest/features/profile/bloc/profile_bloc.dart';
import 'package:lexi_quest/features/home/bloc/activity_bloc.dart';
import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Make status bar transparent
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  );
  
  // Initialize Supabase
  await SupabaseConfig.initialize();
  
  runApp(
    // Provide blocs at the root level
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ProfileBloc()),
        BlocProvider(create: (context) => ActivityBloc()),
      ],
      child: const CelebrationManager(
        child: LexiQuestApp(),
      ),
    ),
  );
}
