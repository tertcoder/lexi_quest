import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../gamification/data/models/user_progress.dart';

class StatsSummary extends StatelessWidget {
  final UserProgress userProgress;
  final Map<String, dynamic> weeklyStats;

  const StatsSummary({
    super.key,
    required this.userProgress,
    required this.weeklyStats,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Statistics',
          style: AppFonts.heading3.copyWith(color: AppColors.textPrimary),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.borderColor),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      'Total XP',
                      '${userProgress.totalXP}',
                      Icons.star,
                      AppColors.primaryColor,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      'Current Level',
                      '${userProgress.level}',
                      Icons.trending_up,
                      AppColors.accentColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      'Tasks Completed',
                      '${userProgress.tasksCompleted}',
                      Icons.task_alt,
                      AppColors.successColor,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      'Best Streak',
                      '${userProgress.bestStreak} days',
                      Icons.local_fire_department,
                      AppColors.warningColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildWeeklyProgress(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Icon(icon, size: 24, color: color),
          const SizedBox(height: 8),
          Text(
            value,
            style: AppFonts.heading3.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            title,
            style: AppFonts.caption.copyWith(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyProgress() {
    final currentWeekXP = weeklyStats['currentWeekXP'] as int;
    final weeklyGoal = weeklyStats['weeklyGoal'] as int;
    final progress = currentWeekXP / weeklyGoal;
    final tasksThisWeek = weeklyStats['tasksThisWeek'] as int;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'This Week',
                style: AppFonts.bodyMedium.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '$tasksThisWeek tasks',
                style: AppFonts.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$currentWeekXP XP',
                style: AppFonts.bodyLarge.copyWith(
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Goal: $weeklyGoal XP',
                style: AppFonts.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: progress.clamp(0.0, 1.0),
            backgroundColor: AppColors.borderColor,
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
            minHeight: 6,
          ),
          const SizedBox(height: 4),
          Text(
            '${(progress * 100).toInt()}% of weekly goal',
            style: AppFonts.caption.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
