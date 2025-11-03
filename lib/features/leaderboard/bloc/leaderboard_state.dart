import 'package:equatable/equatable.dart';
import 'package:lexi_quest/features/leaderboard/data/models/leaderboard_model.dart';

/// Leaderboard states
abstract class LeaderboardState extends Equatable {
  const LeaderboardState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class LeaderboardInitial extends LeaderboardState {
  const LeaderboardInitial();
}

/// Loading state
class LeaderboardLoading extends LeaderboardState {
  const LeaderboardLoading();
}

/// Loaded state
class LeaderboardLoaded extends LeaderboardState {
  final List<LeaderboardEntry> entries;

  const LeaderboardLoaded({required this.entries});

  @override
  List<Object?> get props => [entries];
}

/// Error state
class LeaderboardError extends LeaderboardState {
  final String message;

  const LeaderboardError({required this.message});

  @override
  List<Object?> get props => [message];
}
