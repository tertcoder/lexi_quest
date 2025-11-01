import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lexi_quest/core/theme/app_colors.dart';
import 'package:lexi_quest/core/theme/app_fonts.dart';
import 'package:lexi_quest/core/utils/app_assets.dart';
import 'package:lexi_quest/features/leaderboard/data/models/leaderboard_model.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  List<LeaderboardEntry> _entries = [];
  LeaderboardFilter _selectedFilter = LeaderboardFilter.allTime;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLeaderboard();
  }

  Future<void> _loadLeaderboard() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final String response = await rootBundle.loadString('assets/data/leaderboard.json');
      final data = json.decode(response);
      final List<dynamic> leaderboard = data['leaderboard'];

      setState(() {
        _entries = leaderboard
            .map((json) => LeaderboardEntry.fromJson(json))
            .toList();
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading leaderboard: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Color _getRankColor(int rank) {
    switch (rank) {
      case 1:
        return AppColors.secondaryAmber500;
      case 2:
        return const Color(0xFFC0C0C0); // Silver
      case 3:
        return const Color(0xFFCD7F32); // Bronze
      default:
        return AppColors.neutralSlate600;
    }
  }

  IconData _getRankIcon(int rank) {
    switch (rank) {
      case 1:
        return Icons.emoji_events;
      case 2:
        return Icons.emoji_events;
      case 3:
        return Icons.emoji_events;
      default:
        return Icons.person;
    }
  }

  String _getBadgeAsset(int level) {
    if (level >= 10) return AppAssets.badgeDiamond;
    if (level >= 7) return AppAssets.badgeGold;
    if (level >= 4) return AppAssets.badgeSilver;
    return AppAssets.badgeBronze;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Column(
          children: [
            // Header with gradient
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primaryIndigo600, AppColors.primaryIndigo500],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      // IconButton(
                      //   onPressed: () => Navigator.of(context).pop(),
                      //   icon: const Icon(
                      //     Icons.arrow_back,
                      //     color: AppColors.onPrimary,
                      //   ),
                      // ),
                      // const SizedBox(width: 8),
                      Text(
                        'Leaderboard',
                        style: AppFonts.headlineMedium.copyWith(
                          color: AppColors.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Filter Tabs
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppColors.neutralWhite.withValues(alpha:0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        _buildFilterTab('Daily', LeaderboardFilter.daily),
                        _buildFilterTab('Weekly', LeaderboardFilter.weekly),
                        _buildFilterTab('All Time', LeaderboardFilter.allTime),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Leaderboard List
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryIndigo600,
                      ),
                    )
                  : _entries.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.leaderboard_outlined,
                                size: 64,
                                color: AppColors.neutralSlate600,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No leaderboard data',
                                style: AppFonts.titleMedium.copyWith(
                                  color: AppColors.neutralSlate600,
                                ),
                              ),
                            ],
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: _loadLeaderboard,
                          color: AppColors.primaryIndigo600,
                          child: ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: _entries.length,
                            itemBuilder: (context, index) {
                              final entry = _entries[index];
                              final isCurrentUser = entry.username == 'Bon';

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: isCurrentUser
                                        ? AppColors.primaryIndigo600.withValues(alpha:0.1)
                                        : AppColors.background,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: isCurrentUser
                                          ? AppColors.primaryIndigo600
                                          : AppColors.neutralSlate600_30,
                                      width: isCurrentUser ? 2 : 1,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Row(
                                      children: [
                                        // Rank
                                        Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            color: _getRankColor(entry.rank).withValues(alpha:0.1),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Center(
                                            child: entry.rank <= 3
                                                ? Icon(
                                                    _getRankIcon(entry.rank),
                                                    color: _getRankColor(entry.rank),
                                                    size: 24,
                                                  )
                                                : Text(
                                                    '${entry.rank}',
                                                    style: AppFonts.titleMedium.copyWith(
                                                      color: AppColors.onBackground,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),

                                        // Avatar
                                        Container(
                                          width: 48,
                                          height: 48,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: _getRankColor(entry.rank),
                                              width: 2,
                                            ),
                                          ),
                                          child: CircleAvatar(
                                            radius: 22,
                                            backgroundImage: entry.avatarUrl != null
                                                ? NetworkImage(entry.avatarUrl!)
                                                : AssetImage(AppAssets.defaultProfile) as ImageProvider,
                                          ),
                                        ),
                                        const SizedBox(width: 12),

                                        // User Info
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Flexible(
                                                    child: Text(
                                                      entry.username,
                                                      style: AppFonts.titleMedium.copyWith(
                                                        color: AppColors.onBackground,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                  if (isCurrentUser) ...[
                                                    const SizedBox(width: 6),
                                                    Container(
                                                      padding: const EdgeInsets.symmetric(
                                                        horizontal: 8,
                                                        vertical: 2,
                                                      ),
                                                      decoration: BoxDecoration(
                                                        color: AppColors.primaryIndigo600,
                                                        borderRadius: BorderRadius.circular(4),
                                                      ),
                                                      child: Text(
                                                        'You',
                                                        style: AppFonts.labelSmall.copyWith(
                                                          color: AppColors.onPrimary,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ],
                                              ),
                                              const SizedBox(height: 4),
                                              Row(
                                                children: [
                                                  SvgPicture.asset(
                                                    _getBadgeAsset(entry.level),
                                                    width: 16,
                                                    height: 16,
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Flexible(
                                                    child: Text(
                                                      'Level ${entry.level}',
                                                      style: AppFonts.bodySmall.copyWith(
                                                        color: AppColors.onSurfaceVariant,
                                                      ),
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 12),
                                                  const Icon(
                                                    Icons.local_fire_department,
                                                    size: 14,
                                                    color: AppColors.secondaryAmber500,
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    '${entry.streak} days',
                                                    style: AppFonts.bodySmall.copyWith(
                                                      color: AppColors.onSurfaceVariant,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),

                                        // XP
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Row(
                                              children: [
                                                const Icon(
                                                  Icons.star,
                                                  color: AppColors.secondaryAmber500,
                                                  size: 20,
                                                ),
                                                const SizedBox(width: 4),
                                                Text(
                                                  '${entry.totalXp}',
                                                  style: AppFonts.titleMedium.copyWith(
                                                    color: AppColors.secondaryAmber500,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              '${entry.annotationsCompleted} tasks',
                                              style: AppFonts.bodySmall.copyWith(
                                                color: AppColors.onSurfaceVariant,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterTab(String label, LeaderboardFilter filter) {
    final isSelected = _selectedFilter == filter;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedFilter = filter;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.neutralWhite
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: AppFonts.bodyMedium.copyWith(
              color: isSelected
                  ? AppColors.primaryIndigo600
                  : AppColors.neutralWhite,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
