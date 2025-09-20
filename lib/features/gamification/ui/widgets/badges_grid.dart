import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../data/models/badge.dart' as game_badge;

class BadgesGrid extends StatefulWidget {
  final List<game_badge.Badge> allBadges;
  final List<game_badge.Badge> unlockedBadges;

  const BadgesGrid({
    super.key,
    required this.allBadges,
    required this.unlockedBadges,
  });

  @override
  State<BadgesGrid> createState() => _BadgesGridState();
}

class _BadgesGridState extends State<BadgesGrid> {
  game_badge.BadgeCategory? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),
        const SizedBox(height: 16),
        _buildCategoryFilter(),
        const SizedBox(height: 16),
        _buildBadgesGrid(),
      ],
    );
  }

  Widget _buildHeader() {
    final unlockedCount = widget.unlockedBadges.length;
    final totalCount = widget.allBadges.length;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Badges',
          style: AppFonts.heading2.copyWith(color: AppColors.textPrimary),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.primaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            '$unlockedCount / $totalCount',
            style: AppFonts.bodyMedium.copyWith(
              color: AppColors.primaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryFilter() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildCategoryChip('All', null),
          const SizedBox(width: 8),
          ...game_badge.BadgeCategory.values.map(
            (category) => Padding(
              padding: const EdgeInsets.only(right: 8),
              child: _buildCategoryChip(category.displayName, category),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String label, game_badge.BadgeCategory? category) {
    final isSelected = _selectedCategory == category;

    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedCategory = selected ? category : null;
        });
      },
      backgroundColor: AppColors.cardBackground,
      selectedColor: AppColors.primaryColor.withValues(alpha: 0.1),
      labelStyle: AppFonts.bodySmall.copyWith(
        color: isSelected ? AppColors.primaryColor : AppColors.textSecondary,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
      ),
      side: BorderSide(
        color: isSelected ? AppColors.primaryColor : AppColors.borderColor,
      ),
    );
  }

  Widget _buildBadgesGrid() {
    final filteredBadges =
        _selectedCategory == null
            ? widget.allBadges
            : widget.allBadges
                .where((badge) => badge.category == _selectedCategory)
                .toList();

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.1,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: filteredBadges.length,
      itemBuilder: (context, index) {
        final badge = filteredBadges[index];
        return _buildBadgeCard(badge);
      },
    );
  }

  Widget _buildBadgeCard(game_badge.Badge badge) {
    final isUnlocked = widget.unlockedBadges.any((b) => b.id == badge.id);

    return GestureDetector(
      onTap: () => _showBadgeDetails(badge, isUnlocked),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color:
                isUnlocked
                    ? _getRarityColor(badge.rarity)
                    : AppColors.borderColor,
            width: isUnlocked ? 2 : 1,
          ),
          boxShadow:
              isUnlocked
                  ? [
                    BoxShadow(
                      color: _getRarityColor(
                        badge.rarity,
                      ).withValues(alpha: 0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                  : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                Icon(
                  _getBadgeIcon(badge.category),
                  size: 40,
                  color:
                      isUnlocked
                          ? _getRarityColor(badge.rarity)
                          : AppColors.textSecondary.withValues(alpha: 0.3),
                ),
                if (!isUnlocked)
                  Positioned.fill(
                    child: Icon(
                      Icons.lock,
                      size: 20,
                      color: AppColors.textSecondary.withValues(alpha: 0.5),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              badge.name,
              style: AppFonts.bodyMedium.copyWith(
                color:
                    isUnlocked
                        ? AppColors.textPrimary
                        : AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: _getRarityColor(badge.rarity).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                badge.rarity.displayName,
                style: AppFonts.caption.copyWith(
                  color: _getRarityColor(badge.rarity),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showBadgeDetails(game_badge.Badge badge, bool isUnlocked) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: AppColors.cardBackground,
            title: Row(
              children: [
                Icon(
                  _getBadgeIcon(badge.category),
                  color:
                      isUnlocked
                          ? _getRarityColor(badge.rarity)
                          : AppColors.textSecondary,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    badge.name,
                    style: AppFonts.heading3.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  badge.description,
                  style: AppFonts.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 12),
                _buildDetailRow('Category', badge.category.displayName),
                _buildDetailRow('Rarity', badge.rarity.displayName),
                _buildDetailRow('Requirement', badge.requirement),
                if (isUnlocked && badge.unlockedAt != null)
                  _buildDetailRow('Unlocked', _formatDate(badge.unlockedAt!)),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'Close',
                  style: AppFonts.bodyMedium.copyWith(
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
            ],
          ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: AppFonts.bodySmall.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppFonts.bodySmall.copyWith(color: AppColors.textPrimary),
            ),
          ),
        ],
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
