import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:lexi_quest/core/config/supabase_config.dart';

/// Base repository with common functionality
abstract class BaseRepository {
  /// Get Supabase client
  SupabaseClient get client => SupabaseConfig.client;
  
  /// Handle errors and wrap operations
  Future<T> handleError<T>(Future<T> Function() operation) async {
    try {
      return await operation();
    } on PostgrestException catch (e) {
      throw Exception('Database error: ${e.message}');
    } on AuthException catch (e) {
      throw Exception('Auth error: ${e.message}');
    } on StorageException catch (e) {
      throw Exception('Storage error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
  
  /// Handle errors without return value
  Future<void> handleVoidError(Future<void> Function() operation) async {
    try {
      await operation();
    } on PostgrestException catch (e) {
      throw Exception('Database error: ${e.message}');
    } on AuthException catch (e) {
      throw Exception('Auth error: ${e.message}');
    } on StorageException catch (e) {
      throw Exception('Storage error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}
