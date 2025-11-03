import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lexi_quest/core/config/supabase_config.dart';
import 'package:lexi_quest/core/widgets/celebration_manager.dart';
import 'package:lexi_quest/features/profile/bloc/profile_bloc.dart';
import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Supabase
  await SupabaseConfig.initialize();
  
  runApp(
    // Provide ProfileBloc at the root level
    BlocProvider(
      create: (context) => ProfileBloc(),
      child: const CelebrationManager(
        child: LexiQuestApp(),
      ),
    ),
  );
}
