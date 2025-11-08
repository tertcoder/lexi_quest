import 'package:lexi_quest/core/data/repositories/base_repository.dart';
import 'package:lexi_quest/core/config/supabase_config.dart';

/// Activity repository
class ActivityRepository extends BaseRepository {
  /// Get user activities
  Future<List<Map<String, dynamic>>> getUserActivities({int limit = 10}) async {
    return handleError(() async {
      final userId = SupabaseConfig.currentUserId;
      if (userId == null) throw Exception('No user logged in');
      final response = await client
          .from('activities')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false)
          .limit(limit);
      
      return (response as List).cast<Map<String, dynamic>>();
    });
  }
  
  /// Subscribe to activities (realtime)
  Stream<List<Map<String, dynamic>>> subscribeToActivities({int limit = 10}) {
    final userId = SupabaseConfig.currentUserId;
    if (userId == null) throw Exception('No user logged in');
    
    return client
        .from('activities')
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .order('created_at', ascending: false)
        .limit(limit);
  }
  
  /// Create activity
  Future<void> createActivity({
    required String activityType,
    required String title,
    String? description,
    int xpEarned = 0,
    Map<String, dynamic>? metadata,
  }) async {
    return handleVoidError(() async {
      final userId = SupabaseConfig.currentUserId;
      if (userId == null) throw Exception('No user logged in');
      
      await client.from('activities').insert({
        'user_id': userId,
        'activity_type': activityType,
        'title': title,
        'description': description,
        'xp_earned': xpEarned,
        'metadata': metadata,
      });
    });
  }
}
