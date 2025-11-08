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
      
      // Get user's last active date and current streak
      final userResponse = await client
          .from('users')
          .select('last_active_at, streak')
          .eq('id', userId)
          .single();
      
      final lastActiveAt = userResponse['last_active_at'] != null
          ? DateTime.parse(userResponse['last_active_at'] as String)
          : null;
      final currentStreak = userResponse['streak'] as int;
      
      final today = DateTime.now();
      final todayDate = DateTime(today.year, today.month, today.day);
      
      if (lastActiveAt != null) {
        final lastActiveDate = DateTime(
          lastActiveAt.year,
          lastActiveAt.month,
          lastActiveAt.day,
        );
        final daysDifference = todayDate.difference(lastActiveDate).inDays;
        
        if (daysDifference == 1) {
          // Consecutive day - increment streak
          await client.from('users').update({
            'streak': currentStreak + 1,
            'last_active_at': DateTime.now().toIso8601String(),
          }).eq('id', userId);
        } else if (daysDifference > 1) {
          // Streak broken - reset to 1
          await client.from('users').update({
            'streak': 1,
            'last_active_at': DateTime.now().toIso8601String(),
          }).eq('id', userId);
        }
        // If daysDifference == 0, same day - do nothing
      } else {
        // First time - set streak to 1
        await client.from('users').update({
          'streak': 1,
          'last_active_at': DateTime.now().toIso8601String(),
        }).eq('id', userId);
      }
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
