import 'package:lexi_quest/core/data/repositories/base_repository.dart';
import 'package:lexi_quest/features/leaderboard/data/models/leaderboard_model.dart';

/// Leaderboard repository
class LeaderboardRepository extends BaseRepository {
  /// Get leaderboard
  Future<List<LeaderboardEntry>> getLeaderboard({int limit = 50}) async {
    return handleError(() async {
      final response = await client
          .from('leaderboard')
          .select()
          .order('rank')
          .limit(limit);
      
      return (response as List)
          .map((json) => LeaderboardEntry.fromJson(json as Map<String, dynamic>))
          .toList();
    });
  }
  
  /// Refresh leaderboard
  Future<void> refreshLeaderboard() async {
    return handleVoidError(() async {
      // Instead of calling RPC function, manually rebuild leaderboard
      // 1. Clear existing leaderboard
      await client.from('leaderboard').delete().neq('user_id', '00000000-0000-0000-0000-000000000000');
      
      // 2. Get all users ordered by total_xp
      final users = await client
          .from('users')
          .select('id, username, avatar_url, total_xp, level, annotations_completed, streak')
          .order('total_xp', ascending: false);
      
      // 3. Insert into leaderboard with ranks
      int rank = 1;
      for (var user in users) {
        await client.from('leaderboard').insert({
          'user_id': user['id'],
          'username': user['username'],
          'avatar_url': user['avatar_url'],
          'total_xp': user['total_xp'],
          'level': user['level'],
          'rank': rank++,
          'annotations_completed': user['annotations_completed'],
          'streak': user['streak'],
        });
      }
    });
  }
  
  /// Subscribe to leaderboard changes (realtime)
  Stream<List<LeaderboardEntry>> subscribeToLeaderboard({int limit = 50}) {
    return client
        .from('leaderboard')
        .stream(primaryKey: ['user_id'])
        .order('rank')
        .limit(limit)
        .map((data) => data
            .map((json) => LeaderboardEntry.fromJson(json as Map<String, dynamic>))
            .toList());
  }
  
  /// Get user rank
  Future<int?> getUserRank(String userId) async {
    return handleError(() async {
      final response = await client
          .from('leaderboard')
          .select('rank')
          .eq('user_id', userId)
          .maybeSingle();
      
      if (response == null) return null;
      return response['rank'] as int;
    });
  }
}
