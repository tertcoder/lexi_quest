import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../data/models/leaderboard_entry.dart';

class LeaderboardPreview extends StatelessWidget {
  final List<LeaderboardEntry> leaderboard;

  const LeaderboardPreview({super.key, required this.leaderboard});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),
        const SizedBox(height: 16),
        _buildTopThree(),
        const SizedBox(height: 16),
        _buildRankingsList(),
      ],
    );
  }

  Widget _buildHeader() {
    return Text(
      'Leaderboard',
      style: AppFonts.heading2.copyWith(color: AppColors.textPrimary),
    );
  }

  Widget _buildTopThree() {
    final topThree = leaderboard.take(3).toList();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryColor.withValues(alpha: 0.1),
            AppColors.accentColor.withValues(alpha: 0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Column(
        children: [
          Text(
            'Top Performers',
            style: AppFonts.heading3.copyWith(color: AppColors.textPrimary),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              if (topThree.length > 1) _buildPodiumPosition(topThree[1], 2),
              if (topThree.isNotEmpty) _buildPodiumPosition(topThree[0], 1),
              if (topThree.length > 2) _buildPodiumPosition(topThree[2], 3),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPodiumPosition(LeaderboardEntry entry, int position) {
    final colors = [
      const Color(0xFFFFD700), // Gold
      const Color(0xFFC0C0C0), // Silver
      const Color(0xFFCD7F32), // Bronze
    ];

    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            CircleAvatar(
              radius: position == 1 ? 35 : 30,
              backgroundColor: colors[position - 1],
              child: CircleAvatar(
                radius: position == 1 ? 32 : 27,
                backgroundImage: NetworkImage(entry.avatarUrl),
              ),
            ),
            Positioned(
              bottom: -2,
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: colors[position - 1],
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: Center(
                  child: Text(
                    '$position',
                    style: AppFonts.caption.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          entry.username,
          style: AppFonts.bodySmall.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          '${entry.totalXP} XP',
          style: AppFonts.caption.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildRankingsList() {
    return Column(
      children: leaderboard.map((entry) => _buildRankingItem(entry)).toList(),
    );
  }

  Widget _buildRankingItem(LeaderboardEntry entry) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color:
            entry.isCurrentUser
                ? AppColors.primaryColor.withValues(alpha: 0.1)
                : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color:
              entry.isCurrentUser
                  ? AppColors.primaryColor
                  : AppColors.borderColor,
          width: entry.isCurrentUser ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          _buildRankBadge(entry.rank, entry.isCurrentUser),
          const SizedBox(width: 12),
          CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(entry.avatarUrl),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.username,
                  style: AppFonts.bodyMedium.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight:
                        entry.isCurrentUser ? FontWeight.bold : FontWeight.w600,
                  ),
                ),
                Text(
                  'Level ${entry.level} • ${entry.tasksCompleted} tasks',
                  style: AppFonts.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${entry.totalXP}',
                style: AppFonts.bodyMedium.copyWith(
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'XP',
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

  Widget _buildRankBadge(int rank, bool isCurrentUser) {
    Color backgroundColor;
    Color textColor;

    if (rank <= 3) {
      backgroundColor = _getRankColor(rank);
      textColor = Colors.white;
    } else if (isCurrentUser) {
      backgroundColor = AppColors.primaryColor;
      textColor = Colors.white;
    } else {
      backgroundColor = AppColors.borderColor;
      textColor = AppColors.textSecondary;
    }

    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(color: backgroundColor, shape: BoxShape.circle),
      child: Center(
        child: Text(
          '#$rank',
          style: AppFonts.caption.copyWith(
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Color _getRankColor(int rank) {
    switch (rank) {
      case 1:
        return const Color(0xFFFFD700); // Gold
      case 2:
        return const Color(0xFFC0C0C0); // Silver
      case 3:
        return const Color(0xFFCD7F32); // Bronze
      default:
        return AppColors.borderColor;
    }
  }
}
