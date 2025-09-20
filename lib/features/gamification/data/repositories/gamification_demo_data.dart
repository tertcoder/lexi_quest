import '../models/user_progress.dart';
import '../models/badge.dart';
import '../models/leaderboard_entry.dart';

class GamificationDemoData {
  static UserProgress getUserProgress() {
    return UserProgress(
      currentXP: 1250,
      level: 7,
      xpToNextLevel: 350,
      totalXP: 3850,
      tasksCompleted: 47,
      currentStreak: 12,
      bestStreak: 18,
      lastActivityDate: DateTime.now().subtract(const Duration(hours: 2)),
      unlockedBadgeIds: [
        'first_annotation',
        'streak_5',
        'milestone_10',
        'sentiment_master',
        'speed_demon',
      ],
    );
  }

  static List<Badge> getAllBadges() {
    return [
      // Achievement Badges
      const Badge(
        id: 'first_annotation',
        name: 'First Steps',
        description: 'Complete your first annotation task',
        iconPath: 'assets/icons/badge_first.svg',
        category: BadgeCategory.achievement,
        rarity: BadgeRarity.common,
        requiredValue: 1,
        requirement: 'Complete 1 annotation',
        unlockedAt: null,
      ),
      const Badge(
        id: 'sentiment_master',
        name: 'Sentiment Master',
        description: 'Complete 20 sentiment analysis tasks',
        iconPath: 'assets/icons/badge_sentiment.svg',
        category: BadgeCategory.achievement,
        rarity: BadgeRarity.rare,
        requiredValue: 20,
        requirement: 'Complete 20 sentiment tasks',
        unlockedAt: null,
      ),
      const Badge(
        id: 'ner_expert',
        name: 'Entity Expert',
        description: 'Complete 15 named entity recognition tasks',
        iconPath: 'assets/icons/badge_ner.svg',
        category: BadgeCategory.achievement,
        rarity: BadgeRarity.rare,
        requiredValue: 15,
        requirement: 'Complete 15 NER tasks',
      ),
      const Badge(
        id: 'classification_pro',
        name: 'Classification Pro',
        description: 'Complete 25 text classification tasks',
        iconPath: 'assets/icons/badge_classification.svg',
        category: BadgeCategory.achievement,
        rarity: BadgeRarity.epic,
        requiredValue: 25,
        requirement: 'Complete 25 classification tasks',
      ),

      // Milestone Badges
      const Badge(
        id: 'milestone_10',
        name: 'Getting Started',
        description: 'Complete 10 annotation tasks',
        iconPath: 'assets/icons/badge_milestone_10.svg',
        category: BadgeCategory.milestone,
        rarity: BadgeRarity.common,
        requiredValue: 10,
        requirement: 'Complete 10 tasks',
        unlockedAt: null,
      ),
      const Badge(
        id: 'milestone_50',
        name: 'Dedicated Annotator',
        description: 'Complete 50 annotation tasks',
        iconPath: 'assets/icons/badge_milestone_50.svg',
        category: BadgeCategory.milestone,
        rarity: BadgeRarity.rare,
        requiredValue: 50,
        requirement: 'Complete 50 tasks',
      ),
      const Badge(
        id: 'milestone_100',
        name: 'Annotation Hero',
        description: 'Complete 100 annotation tasks',
        iconPath: 'assets/icons/badge_milestone_100.svg',
        category: BadgeCategory.milestone,
        rarity: BadgeRarity.epic,
        requiredValue: 100,
        requirement: 'Complete 100 tasks',
      ),
      const Badge(
        id: 'milestone_500',
        name: 'Legend',
        description: 'Complete 500 annotation tasks',
        iconPath: 'assets/icons/badge_milestone_500.svg',
        category: BadgeCategory.milestone,
        rarity: BadgeRarity.legendary,
        requiredValue: 500,
        requirement: 'Complete 500 tasks',
      ),

      // Streak Badges
      const Badge(
        id: 'streak_5',
        name: 'On Fire',
        description: 'Maintain a 5-day activity streak',
        iconPath: 'assets/icons/badge_streak_5.svg',
        category: BadgeCategory.streak,
        rarity: BadgeRarity.common,
        requiredValue: 5,
        requirement: 'Maintain 5-day streak',
        unlockedAt: null,
      ),
      const Badge(
        id: 'streak_15',
        name: 'Unstoppable',
        description: 'Maintain a 15-day activity streak',
        iconPath: 'assets/icons/badge_streak_15.svg',
        category: BadgeCategory.streak,
        rarity: BadgeRarity.rare,
        requiredValue: 15,
        requirement: 'Maintain 15-day streak',
      ),
      const Badge(
        id: 'streak_30',
        name: 'Consistency King',
        description: 'Maintain a 30-day activity streak',
        iconPath: 'assets/icons/badge_streak_30.svg',
        category: BadgeCategory.streak,
        rarity: BadgeRarity.epic,
        requiredValue: 30,
        requirement: 'Maintain 30-day streak',
      ),

      // Special Badges
      const Badge(
        id: 'speed_demon',
        name: 'Speed Demon',
        description: 'Complete 5 tasks in under 2 minutes each',
        iconPath: 'assets/icons/badge_speed.svg',
        category: BadgeCategory.special,
        rarity: BadgeRarity.rare,
        requiredValue: 5,
        requirement: 'Complete 5 fast tasks',
        unlockedAt: null,
      ),
      const Badge(
        id: 'perfectionist',
        name: 'Perfectionist',
        description: 'Achieve 100% accuracy on 10 consecutive tasks',
        iconPath: 'assets/icons/badge_perfect.svg',
        category: BadgeCategory.special,
        rarity: BadgeRarity.epic,
        requiredValue: 10,
        requirement: 'Perfect accuracy streak',
      ),
      const Badge(
        id: 'early_bird',
        name: 'Early Bird',
        description: 'Complete tasks before 8 AM on 7 different days',
        iconPath: 'assets/icons/badge_early.svg',
        category: BadgeCategory.special,
        rarity: BadgeRarity.rare,
        requiredValue: 7,
        requirement: 'Early morning sessions',
      ),
    ];
  }

  static List<Badge> getUnlockedBadges() {
    final allBadges = getAllBadges();
    final unlockedIds = getUserProgress().unlockedBadgeIds;

    return allBadges.map((badge) {
      if (unlockedIds.contains(badge.id)) {
        return badge.copyWith(
          unlockedAt: DateTime.now().subtract(
            Duration(days: unlockedIds.indexOf(badge.id) * 2),
          ),
        );
      }
      return badge;
    }).toList();
  }

  static List<LeaderboardEntry> getLeaderboard() {
    return [
      const LeaderboardEntry(
        userId: '1',
        username: 'DataWizard',
        avatarUrl: 'https://i.pravatar.cc/150?img=1',
        totalXP: 8950,
        level: 12,
        tasksCompleted: 167,
        rank: 1,
      ),
      const LeaderboardEntry(
        userId: '2',
        username: 'AnnotationQueen',
        avatarUrl: 'https://i.pravatar.cc/150?img=2',
        totalXP: 7200,
        level: 10,
        tasksCompleted: 134,
        rank: 2,
      ),
      const LeaderboardEntry(
        userId: '3',
        username: 'LabelMaster',
        avatarUrl: 'https://i.pravatar.cc/150?img=3',
        totalXP: 6850,
        level: 10,
        tasksCompleted: 128,
        rank: 3,
      ),
      const LeaderboardEntry(
        userId: '4',
        username: 'AITrainer',
        avatarUrl: 'https://i.pravatar.cc/150?img=4',
        totalXP: 5900,
        level: 9,
        tasksCompleted: 112,
        rank: 4,
      ),
      const LeaderboardEntry(
        userId: 'current',
        username: 'You',
        avatarUrl: 'https://i.pravatar.cc/150?img=5',
        totalXP: 3850,
        level: 7,
        tasksCompleted: 47,
        rank: 5,
        isCurrentUser: true,
      ),
      const LeaderboardEntry(
        userId: '6',
        username: 'TextAnalyst',
        avatarUrl: 'https://i.pravatar.cc/150?img=6',
        totalXP: 3200,
        level: 6,
        tasksCompleted: 41,
        rank: 6,
      ),
      const LeaderboardEntry(
        userId: '7',
        username: 'DataScientist',
        avatarUrl: 'https://i.pravatar.cc/150?img=7',
        totalXP: 2800,
        level: 6,
        tasksCompleted: 38,
        rank: 7,
      ),
      const LeaderboardEntry(
        userId: '8',
        username: 'MLEnthusiast',
        avatarUrl: 'https://i.pravatar.cc/150?img=8',
        totalXP: 2350,
        level: 5,
        tasksCompleted: 32,
        rank: 8,
      ),
      const LeaderboardEntry(
        userId: '9',
        username: 'AnnotationRookie',
        avatarUrl: 'https://i.pravatar.cc/150?img=9',
        totalXP: 1950,
        level: 5,
        tasksCompleted: 28,
        rank: 9,
      ),
      const LeaderboardEntry(
        userId: '10',
        username: 'Beginner',
        avatarUrl: 'https://i.pravatar.cc/150?img=10',
        totalXP: 1200,
        level: 4,
        tasksCompleted: 18,
        rank: 10,
      ),
    ];
  }

  static Map<String, dynamic> getWeeklyStats() {
    return {
      'currentWeekXP': 580,
      'lastWeekXP': 420,
      'weeklyGoal': 700,
      'tasksThisWeek': 8,
      'averageTasksPerDay': 1.1,
      'bestDay': 'Tuesday',
      'dailyXP': [
        {'day': 'Mon', 'xp': 125},
        {'day': 'Tue', 'xp': 180},
        {'day': 'Wed', 'xp': 95},
        {'day': 'Thu', 'xp': 140},
        {'day': 'Fri', 'xp': 40},
        {'day': 'Sat', 'xp': 0},
        {'day': 'Sun', 'xp': 0},
      ],
    };
  }
}
