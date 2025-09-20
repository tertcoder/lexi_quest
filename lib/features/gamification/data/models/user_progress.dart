class UserProgress {
  final int currentXP;
  final int level;
  final int xpToNextLevel;
  final int totalXP;
  final int tasksCompleted;
  final int currentStreak;
  final int bestStreak;
  final DateTime lastActivityDate;
  final List<String> unlockedBadgeIds;

  const UserProgress({
    required this.currentXP,
    required this.level,
    required this.xpToNextLevel,
    required this.totalXP,
    required this.tasksCompleted,
    required this.currentStreak,
    required this.bestStreak,
    required this.lastActivityDate,
    required this.unlockedBadgeIds,
  });

  double get progressToNextLevel {
    final levelXP = _getXPForLevel(level);
    final nextLevelXP = _getXPForLevel(level + 1);
    final currentProgress = totalXP - levelXP;
    final requiredProgress = nextLevelXP - levelXP;
    return currentProgress / requiredProgress;
  }

  int _getXPForLevel(int level) {
    return (level * level * 100) + (level * 50);
  }

  UserProgress copyWith({
    int? currentXP,
    int? level,
    int? xpToNextLevel,
    int? totalXP,
    int? tasksCompleted,
    int? currentStreak,
    int? bestStreak,
    DateTime? lastActivityDate,
    List<String>? unlockedBadgeIds,
  }) {
    return UserProgress(
      currentXP: currentXP ?? this.currentXP,
      level: level ?? this.level,
      xpToNextLevel: xpToNextLevel ?? this.xpToNextLevel,
      totalXP: totalXP ?? this.totalXP,
      tasksCompleted: tasksCompleted ?? this.tasksCompleted,
      currentStreak: currentStreak ?? this.currentStreak,
      bestStreak: bestStreak ?? this.bestStreak,
      lastActivityDate: lastActivityDate ?? this.lastActivityDate,
      unlockedBadgeIds: unlockedBadgeIds ?? this.unlockedBadgeIds,
    );
  }
}
