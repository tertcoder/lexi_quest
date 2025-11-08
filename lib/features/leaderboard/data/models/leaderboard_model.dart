import 'package:equatable/equatable.dart';

/// Represents a user's leaderboard entry
class LeaderboardEntry extends Equatable {
  final String userId;
  final String username;
  final String? avatarUrl;
  final int totalXp;
  final int level;
  final int rank;
  final int annotationsCompleted;
  final int streak;

  const LeaderboardEntry({
    required this.userId,
    required this.username,
    this.avatarUrl,
    required this.totalXp,
    required this.level,
    required this.rank,
    required this.annotationsCompleted,
    this.streak = 0,
  });

  factory LeaderboardEntry.fromJson(Map<String, dynamic> json) {
    return LeaderboardEntry(
      userId: json['user_id'] as String,
      username: json['username'] as String,
      avatarUrl: json['avatar_url'] as String?,
      totalXp: json['total_xp'] as int,
      level: json['level'] as int,
      rank: json['rank'] as int,
      annotationsCompleted: json['annotations_completed'] as int,
      streak: json['streak'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'username': username,
      'avatar_url': avatarUrl,
      'total_xp': totalXp,
      'level': level,
      'rank': rank,
      'annotations_completed': annotationsCompleted,
      'streak': streak,
    };
  }

  @override
  List<Object?> get props => [
        userId,
        username,
        avatarUrl,
        totalXp,
        level,
        rank,
        annotationsCompleted,
        streak,
      ];
}

/// Leaderboard filter options
enum LeaderboardFilter {
  daily,
  weekly,
  allTime,
}
