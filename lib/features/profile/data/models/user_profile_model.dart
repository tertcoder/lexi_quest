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
    return UserProfile(
      userId: json['userId'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      avatarUrl: json['avatarUrl'] as String?,
      totalXp: json['totalXp'] as int,
      level: json['level'] as int,
      currentLevelXp: json['currentLevelXp'] as int,
      nextLevelXp: json['nextLevelXp'] as int,
      streak: json['streak'] as int? ?? 0,
      annotationsCompleted: json['annotationsCompleted'] as int? ?? 0,
      badges: (json['badges'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      joinedAt: DateTime.parse(json['joinedAt'] as String),
      lastActiveAt: json['lastActiveAt'] != null
          ? DateTime.parse(json['lastActiveAt'] as String)
          : null,
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
    return currentLevelXp / nextLevelXp;
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
