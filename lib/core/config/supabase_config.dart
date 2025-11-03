import 'package:supabase_flutter/supabase_flutter.dart';

/// Supabase configuration and client access
class SupabaseConfig {
  // Supabase credentials
  static const String supabaseUrl = 'https://lhxqfazbkjjkokvafmat.supabase.co';
  static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImxoeHFmYXpia2pqa29rdmFmbWF0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjIwMDEwODksImV4cCI6MjA3NzU3NzA4OX0.RqsleDLpEoeTW6-5S8SRWLG72wFeQYy6eZkkkgyrhwU';
  
  /// Initialize Supabase
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
      authOptions: const FlutterAuthClientOptions(
        authFlowType: AuthFlowType.pkce,
      ),
    );
  }
  
  /// Get Supabase client instance
  static SupabaseClient get client => Supabase.instance.client;
  
  /// Get current authenticated user
  static User? get currentUser => client.auth.currentUser;
  
  /// Get current user ID
  static String? get currentUserId => currentUser?.id;
  
  /// Check if user is authenticated
  static bool get isAuthenticated => currentUser != null;
}
