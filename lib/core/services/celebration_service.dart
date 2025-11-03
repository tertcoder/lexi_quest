import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lexi_quest/core/widgets/confetti_overlay.dart';
import 'package:lexi_quest/core/theme/app_colors.dart';
import 'package:lexi_quest/core/theme/app_fonts.dart';
import 'package:lexi_quest/core/utils/app_assets.dart';

/// Service to handle celebration animations and dialogs
class CelebrationService {
  /// Show level up celebration
  static Future<void> showLevelUpCelebration({
    required BuildContext context,
    required int newLevel,
    required int xpEarned,
  }) async {
    String badgeAsset = AppAssets.badgeBronze;
    String badgeName = 'Bronze';
    
    if (newLevel >= 50) {
      badgeAsset = AppAssets.badgeDiamond;
      badgeName = 'Diamond';
    } else if (newLevel >= 25) {
      badgeAsset = AppAssets.badgeGold;
      badgeName = 'Gold';
    } else if (newLevel >= 10) {
      badgeAsset = AppAssets.badgeSilver;
      badgeName = 'Silver';
    }

    await showCelebrationDialog(
      context: context,
      title: '🎉 Level Up!',
      subtitle: '$badgeName Tier',
      message: 'Congratulations! You\'ve reached Level $newLevel!',
      icon: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.primaryIndigo600.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: SvgPicture.asset(
          badgeAsset,
          width: 80,
          height: 80,
        ),
      ),
    );
  }

  /// Show task completion celebration
  static Future<void> showTaskCompletionCelebration({
    required BuildContext context,
    required String taskName,
    required int xpEarned,
    String? projectName,
  }) async {
    await showCelebrationDialog(
      context: context,
      title: '✨ Task Complete!',
      subtitle: projectName,
      message: 'Great job! You earned +$xpEarned XP',
      icon: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.secondaryGreen500.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.check_circle,
          size: 80,
          color: AppColors.secondaryGreen500,
        ),
      ),
    );
  }

  /// Show badge unlock celebration
  static Future<void> showBadgeUnlockCelebration({
    required BuildContext context,
    required String badgeName,
    required String badgeDescription,
  }) async {
    String badgeAsset = AppAssets.badgeBronze;
    
    switch (badgeName.toLowerCase()) {
      case 'silver':
        badgeAsset = AppAssets.badgeSilver;
        break;
      case 'gold':
        badgeAsset = AppAssets.badgeGold;
        break;
      case 'diamond':
        badgeAsset = AppAssets.badgeDiamond;
        break;
    }

    await showCelebrationDialog(
      context: context,
      title: '🏆 Badge Unlocked!',
      subtitle: badgeName,
      message: badgeDescription,
      icon: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.secondaryAmber500.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: SvgPicture.asset(
          badgeAsset,
          width: 80,
          height: 80,
        ),
      ),
    );
  }

  /// Show streak milestone celebration
  static Future<void> showStreakMilestoneCelebration({
    required BuildContext context,
    required int streakDays,
  }) async {
    await showCelebrationDialog(
      context: context,
      title: '🔥 Streak Milestone!',
      subtitle: '$streakDays Days',
      message: 'Amazing! You\'ve maintained a $streakDays-day streak!',
      icon: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.secondaryRed500.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: SvgPicture.asset(
          AppAssets.illStreak,
          width: 80,
          height: 80,
        ),
      ),
    );
  }

  /// Show XP milestone celebration
  static Future<void> showXpMilestoneCelebration({
    required BuildContext context,
    required int totalXp,
  }) async {
    await showCelebrationDialog(
      context: context,
      title: '⭐ XP Milestone!',
      subtitle: '$totalXp Total XP',
      message: 'Incredible! You\'ve earned $totalXp experience points!',
      icon: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.secondaryAmber500.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: SvgPicture.asset(
          AppAssets.illXp,
          width: 80,
          height: 80,
        ),
      ),
    );
  }

  /// Check if level up occurred and show celebration
  static Future<void> checkAndCelebrateLevelUp({
    required BuildContext context,
    required int oldLevel,
    required int newLevel,
    required int xpEarned,
  }) async {
    if (newLevel > oldLevel) {
      await showLevelUpCelebration(
        context: context,
        newLevel: newLevel,
        xpEarned: xpEarned,
      );
      
      // Check if badge tier changed
      final oldBadgeTier = _getBadgeTier(oldLevel);
      final newBadgeTier = _getBadgeTier(newLevel);
      
      if (newBadgeTier > oldBadgeTier) {
        String badgeName = 'Bronze';
        String description = 'You\'ve unlocked a new badge tier!';
        
        if (newLevel >= 50) {
          badgeName = 'Diamond';
          description = 'You\'ve reached the highest tier!';
        } else if (newLevel >= 25) {
          badgeName = 'Gold';
          description = 'You\'re among the elite!';
        } else if (newLevel >= 10) {
          badgeName = 'Silver';
          description = 'You\'re making great progress!';
        }
        
        await showBadgeUnlockCelebration(
          context: context,
          badgeName: badgeName,
          badgeDescription: description,
        );
      }
    }
  }

  /// Get badge tier from level
  static int _getBadgeTier(int level) {
    if (level >= 50) return 4; // Diamond
    if (level >= 25) return 3; // Gold
    if (level >= 10) return 2; // Silver
    return 1; // Bronze
  }
}
