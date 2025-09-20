import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../data/models/user_progress.dart';

class StreakDisplay extends StatelessWidget {
  final UserProgress userProgress;

  const StreakDisplay({super.key, required this.userProgress});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.local_fire_department,
                color: _getStreakColor(),
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'Activity Streak',
                style: AppFonts.heading3.copyWith(color: AppColors.textPrimary),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStreakStat(
                  'Current Streak',
                  '${userProgress.currentStreak}',
                  'days',
                  _getStreakColor(),
                ),
              ),
              Container(
                width: 1,
                height: 40,
                color: AppColors.borderColor,
                margin: const EdgeInsets.symmetric(horizontal: 16),
              ),
              Expanded(
                child: _buildStreakStat(
                  'Best Streak',
                  '${userProgress.bestStreak}',
                  'days',
                  AppColors.accentColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildStreakProgress(),
        ],
      ),
    );
  }

  Widget _buildStreakStat(
    String label,
    String value,
    String unit,
    Color color,
  ) {
    return Column(
      children: [
        Text(
          label,
          style: AppFonts.caption.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: 4),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: value,
                style: AppFonts.heading2.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text: ' $unit',
                style: AppFonts.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStreakProgress() {
    final nextMilestone = _getNextStreakMilestone();
    final progress = userProgress.currentStreak / nextMilestone;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Next milestone',
              style: AppFonts.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            Text(
              '$nextMilestone days',
              style: AppFonts.bodyMedium.copyWith(
                color: AppColors.primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: progress.clamp(0.0, 1.0),
          backgroundColor: AppColors.borderColor,
          valueColor: AlwaysStoppedAnimation<Color>(_getStreakColor()),
          minHeight: 6,
        ),
        const SizedBox(height: 4),
        Text(
          '${nextMilestone - userProgress.currentStreak} days to go',
          style: AppFonts.caption.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Color _getStreakColor() {
    if (userProgress.currentStreak >= 30) {
      return const Color(0xFFFF6B00); // Orange for 30+ days
    } else if (userProgress.currentStreak >= 15) {
      return const Color(0xFFFF8F00); // Amber for 15+ days
    } else if (userProgress.currentStreak >= 7) {
      return const Color(0xFFFFC107); // Yellow for 7+ days
    } else if (userProgress.currentStreak >= 3) {
      return AppColors.primaryColor; // Primary for 3+ days
    } else {
      return AppColors.textSecondary; // Gray for less than 3 days
    }
  }

  int _getNextStreakMilestone() {
    final streakMilestones = [5, 7, 10, 15, 20, 30, 50, 100];

    for (final milestone in streakMilestones) {
      if (userProgress.currentStreak < milestone) {
        return milestone;
      }
    }

    // If beyond all milestones, show next 50-day increment
    return ((userProgress.currentStreak ~/ 50) + 1) * 50;
  }
}
