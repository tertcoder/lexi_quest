class LeaderboardEntry {
  final String userId;
  final String username;
  final String avatarUrl;
  final int totalXP;
  final int level;
  final int tasksCompleted;
  final int rank;
  final bool isCurrentUser;

  const LeaderboardEntry({
    required this.userId,
    required this.username,
    required this.avatarUrl,
    required this.totalXP,
    required this.level,
    required this.tasksCompleted,
    required this.rank,
    this.isCurrentUser = false,
  });

  LeaderboardEntry copyWith({
    String? userId,
    String? username,
    String? avatarUrl,
    int? totalXP,
    int? level,
    int? tasksCompleted,
    int? rank,
    bool? isCurrentUser,
  }) {
    return LeaderboardEntry(
      userId: userId ?? this.userId,
      username: username ?? this.username,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      totalXP: totalXP ?? this.totalXP,
      level: level ?? this.level,
      tasksCompleted: tasksCompleted ?? this.tasksCompleted,
      rank: rank ?? this.rank,
      isCurrentUser: isCurrentUser ?? this.isCurrentUser,
    );
  }
}
