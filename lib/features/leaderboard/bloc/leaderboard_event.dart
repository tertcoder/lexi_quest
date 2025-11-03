import 'package:equatable/equatable.dart';

/// Leaderboard events
abstract class LeaderboardEvent extends Equatable {
  const LeaderboardEvent();

  @override
  List<Object?> get props => [];
}

/// Load leaderboard event
class LoadLeaderboard extends LeaderboardEvent {
  final int limit;

  const LoadLeaderboard({this.limit = 50});

  @override
  List<Object?> get props => [limit];
}

/// Refresh leaderboard event
class RefreshLeaderboard extends LeaderboardEvent {
  const RefreshLeaderboard();
}

/// Subscribe to leaderboard event
class SubscribeToLeaderboard extends LeaderboardEvent {
  final int limit;

  const SubscribeToLeaderboard({this.limit = 50});

  @override
  List<Object?> get props => [limit];
}
