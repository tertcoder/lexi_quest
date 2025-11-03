import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:lexi_quest/core/data/repositories/base_repository.dart';

/// Authentication repository
class AuthRepository extends BaseRepository {
  /// Sign up with email and password
  Future<User> signUp({
    required String email,
    required String password,
    required String username,
  }) async {
    return handleError(() async {
      final response = await client.auth.signUp(
        email: email,
        password: password,
      );
      
      if (response.user == null) {
        throw Exception('Sign up failed');
      }
      
      // Create user profile in database
      await client.from('users').insert({
        'id': response.user!.id,
        'email': email,
        'username': username,
      });
      
      return response.user!;
    });
  }
  
  /// Sign in with email and password
  Future<User> signIn({
    required String email,
    required String password,
  }) async {
    return handleError(() async {
      final response = await client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      
      if (response.user == null) {
        throw Exception('Sign in failed');
      }
      
      return response.user!;
    });
  }
  
  /// Sign out
  Future<void> signOut() async {
    return handleVoidError(() async {
      await client.auth.signOut();
    });
  }
  
  /// Get current user
  User? getCurrentUser() {
    return client.auth.currentUser;
  }
  
  /// Auth state stream
  Stream<AuthState> get authStateChanges {
    return client.auth.onAuthStateChange;
  }
  
  /// Reset password
  Future<void> resetPassword(String email) async {
    return handleVoidError(() async {
      await client.auth.resetPasswordForEmail(email);
    });
  }
  
  /// Change password
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    return handleVoidError(() async {
      await client.auth.updateUser(
        UserAttributes(
          password: newPassword,
        ),
      );
    });
  }
  
  /// Check if user is authenticated
  bool isAuthenticated() {
    return client.auth.currentUser != null;
  }
}
