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
      userId: json['userId'] as String,
      username: json['username'] as String,
      avatarUrl: json['avatarUrl'] as String?,
      totalXp: json['totalXp'] as int,
      level: json['level'] as int,
      rank: json['rank'] as int,
      annotationsCompleted: json['annotationsCompleted'] as int,
      streak: json['streak'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'username': username,
      'avatarUrl': avatarUrl,
      'totalXp': totalXp,
      'level': level,
      'rank': rank,
      'annotationsCompleted': annotationsCompleted,
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
