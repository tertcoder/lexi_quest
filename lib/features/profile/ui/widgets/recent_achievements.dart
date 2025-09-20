import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../gamification/data/models/badge.dart' as game_badge;

class RecentAchievements extends StatelessWidget {
  final List<game_badge.Badge> unlockedBadges;

  const RecentAchievements({super.key, required this.unlockedBadges});

  @override
  Widget build(BuildContext context) {
    final sortedUnlockedBadges =
        unlockedBadges.where((badge) => badge.isUnlocked).toList()
          ..sort((a, b) => b.unlockedAt!.compareTo(a.unlockedAt!));

    final displayBadges = sortedUnlockedBadges.take(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Achievements',
              style: AppFonts.heading3.copyWith(color: AppColors.textPrimary),
            ),
            if (sortedUnlockedBadges.isNotEmpty)
              TextButton(
                onPressed:
                    () => _showAllAchievements(context, sortedUnlockedBadges),
                child: Text(
                  'View All',
                  style: AppFonts.bodySmall.copyWith(
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        if (displayBadges.isEmpty)
          _buildEmptyState()
        else
          _buildAchievementsList(displayBadges),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Row(
        children: [
          Icon(
            Icons.emoji_events_outlined,
            size: 40,
            color: AppColors.textSecondary,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'No achievements yet',
                  style: AppFonts.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  'Complete annotation tasks to earn your first badges!',
                  style: AppFonts.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementsList(List<game_badge.Badge> badges) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Column(
        children:
            badges.asMap().entries.map((entry) {
              final index = entry.key;
              final badge = entry.value;
              return Column(
                children: [
                  _buildAchievementItem(badge),
                  if (index < badges.length - 1)
                    Divider(
                      height: 1,
                      color: AppColors.borderColor,
                      indent: 16,
                      endIndent: 16,
                    ),
                ],
              );
            }).toList(),
      ),
    );
  }

  Widget _buildAchievementItem(game_badge.Badge badge) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: _getRarityColor(badge.rarity).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: _getRarityColor(badge.rarity).withValues(alpha: 0.3),
              ),
            ),
            child: Icon(
              _getBadgeIcon(badge.category),
              color: _getRarityColor(badge.rarity),
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  badge.name,
                  style: AppFonts.bodyMedium.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  badge.description,
                  style: AppFonts.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: _getRarityColor(badge.rarity).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  badge.rarity.displayName,
                  style: AppFonts.caption.copyWith(
                    color: _getRarityColor(badge.rarity),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                badge.unlockedAt != null
                    ? _formatDate(badge.unlockedAt!)
                    : 'Unknown',
                style: AppFonts.caption.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showAllAchievements(
    BuildContext context,
    List<game_badge.Badge> sortedBadges,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cardBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder:
          (context) => Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'All Achievements',
                      style: AppFonts.heading3.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(Icons.close, color: AppColors.textSecondary),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.separated(
                    itemCount: sortedBadges.length,
                    separatorBuilder:
                        (context, index) =>
                            Divider(color: AppColors.borderColor, height: 1),
                    itemBuilder: (context, index) {
                      return _buildAchievementItem(sortedBadges[index]);
                    },
                  ),
                ),
              ],
            ),
          ),
    );
  }

  IconData _getBadgeIcon(game_badge.BadgeCategory category) {
    switch (category) {
      case game_badge.BadgeCategory.achievement:
        return Icons.emoji_events;
      case game_badge.BadgeCategory.milestone:
        return Icons.flag;
      case game_badge.BadgeCategory.streak:
        return Icons.local_fire_department;
      case game_badge.BadgeCategory.special:
        return Icons.star;
    }
  }

  Color _getRarityColor(game_badge.BadgeRarity rarity) {
    switch (rarity) {
      case game_badge.BadgeRarity.common:
        return AppColors.neutralSlate600;
      case game_badge.BadgeRarity.rare:
        return AppColors.primaryIndigo600;
      case game_badge.BadgeRarity.epic:
        return AppColors.warningColor;
      case game_badge.BadgeRarity.legendary:
        return AppColors.errorColor;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
