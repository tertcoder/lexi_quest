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
      await client.rpc('refresh_leaderboard');
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
