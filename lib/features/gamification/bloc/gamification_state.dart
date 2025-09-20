import 'package:equatable/equatable.dart';
import '../data/models/user_progress.dart';
import '../data/models/badge.dart';
import '../data/models/leaderboard_entry.dart';

abstract class GamificationState extends Equatable {
  const GamificationState();

  @override
  List<Object?> get props => [];
}

class GamificationInitial extends GamificationState {}

class GamificationLoading extends GamificationState {}

class GamificationLoaded extends GamificationState {
  final UserProgress userProgress;
  final List<Badge> allBadges;
  final List<Badge> unlockedBadges;
  final List<LeaderboardEntry> leaderboard;
  final Map<String, dynamic> weeklyStats;

  const GamificationLoaded({
    required this.userProgress,
    required this.allBadges,
    required this.unlockedBadges,
    required this.leaderboard,
    required this.weeklyStats,
  });

  @override
  List<Object?> get props => [
    userProgress,
    allBadges,
    unlockedBadges,
    leaderboard,
    weeklyStats,
  ];

  GamificationLoaded copyWith({
    UserProgress? userProgress,
    List<Badge>? allBadges,
    List<Badge>? unlockedBadges,
    List<LeaderboardEntry>? leaderboard,
    Map<String, dynamic>? weeklyStats,
  }) {
    return GamificationLoaded(
      userProgress: userProgress ?? this.userProgress,
      allBadges: allBadges ?? this.allBadges,
      unlockedBadges: unlockedBadges ?? this.unlockedBadges,
      leaderboard: leaderboard ?? this.leaderboard,
      weeklyStats: weeklyStats ?? this.weeklyStats,
    );
  }
}

class GamificationError extends GamificationState {
  final String message;

  const GamificationError(this.message);

  @override
  List<Object> get props => [message];
}

class BadgeUnlocked extends GamificationState {
  final Badge badge;
  final GamificationLoaded previousState;

  const BadgeUnlocked({required this.badge, required this.previousState});

  @override
  List<Object> get props => [badge, previousState];
}

class XPAdded extends GamificationState {
  final int xpAmount;
  final bool leveledUp;
  final int? newLevel;
  final GamificationLoaded previousState;

  const XPAdded({
    required this.xpAmount,
    required this.leveledUp,
    this.newLevel,
    required this.previousState,
  });

  @override
  List<Object?> get props => [xpAmount, leveledUp, newLevel, previousState];
}
