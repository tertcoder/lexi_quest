import 'dart:io';
import 'package:lexi_quest/core/data/repositories/base_repository.dart';
import 'package:lexi_quest/features/profile/data/models/user_profile_model.dart';
import 'package:lexi_quest/core/config/supabase_config.dart';

/// User profile repository
class UserRepository extends BaseRepository {
  /// Get user profile by ID
  Future<UserProfile> getUserProfile(String userId) async {
    return handleError(() async {
      final response = await client
          .from('users')
          .select()
          .eq('id', userId)
          .single();
      
      return UserProfile.fromJson(response);
    });
  }
  
  /// Get current user profile
  Future<UserProfile> getCurrentUserProfile() async {
    final userId = SupabaseConfig.currentUserId;
    if (userId == null) throw Exception('No user logged in');
    
    try {
      return await getUserProfile(userId);
    } catch (e) {
      // If profile doesn't exist, create it
      final authUser = SupabaseConfig.client.auth.currentUser;
      if (authUser != null) {
        await client.from('users').insert({
          'id': authUser.id,
          'email': authUser.email ?? '',
          'username': authUser.email?.split('@')[0] ?? 'User',
        });
        return await getUserProfile(userId);
      }
      rethrow;
    }
  }
  
  /// Update user profile
  Future<void> updateUserProfile(UserProfile profile) async {
    return handleVoidError(() async {
      await client
          .from('users')
          .update(profile.toJson())
          .eq('id', profile.userId);
    });
  }
  
  /// Update streak
  Future<void> updateStreak() async {
    return handleVoidError(() async {
      final userId = SupabaseConfig.currentUserId;
      if (userId == null) throw Exception('No user logged in');
      
      await client.rpc('update_user_streak', params: {
        'p_user_id': userId,
      });
    });
  }
  
  /// Upload avatar
  Future<String> uploadAvatar(String filePath) async {
    return handleError(() async {
      final userId = SupabaseConfig.currentUserId;
      if (userId == null) throw Exception('No user logged in');
      
      final file = File(filePath);
      final fileName = '$userId/${DateTime.now().millisecondsSinceEpoch}.jpg';
      
      await client.storage
          .from('avatars')
          .upload(fileName, file);
      
      return client.storage
          .from('avatars')
          .getPublicUrl(fileName);
    });
  }
  
  /// Get user badges
  Future<List<String>> getUserBadges(String userId) async {
    return handleError(() async {
      final response = await client
          .from('badges')
          .select('badge_type')
          .eq('user_id', userId);
      
      return (response as List)
          .map((e) => e['badge_type'] as String)
          .toList();
    });
  }
}
