import 'package:flutter/material.dart';
import 'package:lexi_quest/core/theme/app_colors.dart';
import 'package:lexi_quest/core/theme/app_fonts.dart';

/// Dialog showing XP reward after completing an annotation
class XpRewardDialog extends StatelessWidget {
  final int xpEarned;
  final int currentStreak;
  final VoidCallback onContinue;

  const XpRewardDialog({
    super.key,
    required this.xpEarned,
    required this.currentStreak,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Success Icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.secondaryGreen500.withValues(alpha:0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle,
                color: AppColors.secondaryGreen500,
                size: 48,
              ),
            ),
            const SizedBox(height: 16),

            // Title
            Text(
              'Great Job!',
              style: AppFonts.headlineMedium.copyWith(
                color: AppColors.onBackground,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            // XP Earned
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.secondaryAmber500.withValues(alpha:0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.star,
                    color: AppColors.secondaryAmber500,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '+$xpEarned XP',
                    style: AppFonts.titleLarge.copyWith(
                      color: AppColors.secondaryAmber500,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Streak Info
            if (currentStreak > 0)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primaryIndigo600.withValues(alpha:0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.local_fire_department,
                      color: AppColors.primaryIndigo600,
                      size: 20,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '$currentStreak day streak!',
                      style: AppFonts.bodyMedium.copyWith(
                        color: AppColors.primaryIndigo600,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 24),

            // Continue Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onContinue,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryIndigo600,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Continue',
                  style: AppFonts.buttonText.copyWith(
                    color: AppColors.onPrimary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Show the XP reward dialog
  static Future<void> show(
    BuildContext context, {
    required int xpEarned,
    required int currentStreak,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => XpRewardDialog(
        xpEarned: xpEarned,
        currentStreak: currentStreak,
        onContinue: () => Navigator.of(context).pop(),
      ),
    );
  }
}
