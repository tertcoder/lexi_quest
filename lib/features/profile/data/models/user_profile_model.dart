import 'package:equatable/equatable.dart';

/// Represents a user's profile
class UserProfile extends Equatable {
  final String userId;
  final String username;
  final String email;
  final String? avatarUrl;
  final int totalXp;
  final int level;
  final int currentLevelXp;
  final int nextLevelXp;
  final int streak;
  final int annotationsCompleted;
  final List<String> badges;
  final DateTime joinedAt;
  final DateTime? lastActiveAt;

  const UserProfile({
    required this.userId,
    required this.username,
    required this.email,
    this.avatarUrl,
    required this.totalXp,
    required this.level,
    required this.currentLevelXp,
    required this.nextLevelXp,
    this.streak = 0,
    this.annotationsCompleted = 0,
    this.badges = const [],
    required this.joinedAt,
    this.lastActiveAt,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    // Handle both snake_case (from Supabase) and camelCase
    return UserProfile(
      userId: (json['userId'] ?? json['id'] ?? json['user_id']) as String,
      username: (json['username'] ?? json['display_name'] ?? 'User') as String,
      email: (json['email'] ?? '') as String,
      avatarUrl: json['avatarUrl'] ?? json['avatar_url'] as String?,
      totalXp: (json['totalXp'] ?? json['total_xp'] ?? 0) as int,
      level: (json['level'] ?? 1) as int,
      currentLevelXp: (json['currentLevelXp'] ?? json['current_level_xp'] ?? 0) as int,
      nextLevelXp: (json['nextLevelXp'] ?? json['next_level_xp'] ?? 100) as int,
      streak: (json['streak'] ?? 0) as int,
      annotationsCompleted: (json['annotationsCompleted'] ?? json['annotations_completed'] ?? 0) as int,
      badges: (json['badges'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      joinedAt: json['joinedAt'] != null 
          ? DateTime.parse(json['joinedAt'] as String)
          : (json['joined_at'] != null 
              ? DateTime.parse(json['joined_at'] as String)
              : (json['created_at'] != null 
                  ? DateTime.parse(json['created_at'] as String)
                  : DateTime.now())),
      lastActiveAt: json['lastActiveAt'] != null
          ? DateTime.parse(json['lastActiveAt'] as String)
          : (json['last_active_at'] != null
              ? DateTime.parse(json['last_active_at'] as String)
              : null),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'username': username,
      'email': email,
      'avatarUrl': avatarUrl,
      'totalXp': totalXp,
      'level': level,
      'currentLevelXp': currentLevelXp,
      'nextLevelXp': nextLevelXp,
      'streak': streak,
      'annotationsCompleted': annotationsCompleted,
      'badges': badges,
      'joinedAt': joinedAt.toIso8601String(),
      'lastActiveAt': lastActiveAt?.toIso8601String(),
    };
  }

  /// Calculate progress percentage to next level
  double get levelProgress {
    if (nextLevelXp == 0) return 1.0;
    
    // Calculate based on total XP if current_level_xp is 0 (for new users)
    if (currentLevelXp == 0 && totalXp > 0) {
      // Use total XP to calculate progress within current level
      final xpForCurrentLevel = _calculateXpForLevel(level);
      final xpForNextLevel = _calculateXpForLevel(level + 1);
      final xpInCurrentLevel = totalXp - xpForCurrentLevel;
      final xpNeededForLevel = xpForNextLevel - xpForCurrentLevel;
      
      if (xpNeededForLevel == 0) return 1.0;
      return (xpInCurrentLevel / xpNeededForLevel).clamp(0.0, 1.0);
    }
    
    // For brand new users with 0 XP, show a small progress (2%) for better UX
    final progress = (currentLevelXp / nextLevelXp).clamp(0.0, 1.0);
    if (progress == 0.0 && totalXp == 0) {
      return 0.02; // Show 2% minimum for new users
    }
    
    return progress;
  }
  
  /// Calculate total XP required to reach a specific level
  /// Using formula: XP = 100 * level^1.5 (exponential growth)
  int _calculateXpForLevel(int targetLevel) {
    if (targetLevel <= 1) return 0;
    return (100 * (targetLevel - 1) * (targetLevel - 1) * 0.5).round();
  }
  
  /// Calculate level from total XP
  int get calculatedLevel {
    if (totalXp == 0) return 1;
    
    // Find the level based on total XP
    int calculatedLevel = 1;
    while (_calculateXpForLevel(calculatedLevel + 1) <= totalXp) {
      calculatedLevel++;
    }
    return calculatedLevel;
  }
  
  /// Get XP progress in current level
  int get xpInCurrentLevel {
    final xpForCurrentLevel = _calculateXpForLevel(level);
    return (totalXp - xpForCurrentLevel).clamp(0, nextLevelXp);
  }
  
  /// Get XP needed for next level
  int get xpNeededForNextLevel {
    return nextLevelXp - xpInCurrentLevel;
  }

  @override
  List<Object?> get props => [
        userId,
        username,
        email,
        avatarUrl,
        totalXp,
        level,
        currentLevelXp,
        nextLevelXp,
        streak,
        annotationsCompleted,
        badges,
        joinedAt,
        lastActiveAt,
      ];
}
