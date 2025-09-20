import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_fonts.dart';
import '../bloc/gamification_bloc.dart';
import '../bloc/gamification_event.dart';
import '../bloc/gamification_state.dart';
import 'widgets/xp_progress_card.dart';
import 'widgets/badges_grid.dart';
import 'widgets/streak_display.dart';
import 'widgets/leaderboard_preview.dart';

/// Rewards screen - shows XP, badges, streaks, and leaderboard
class RewardsScreen extends StatefulWidget {
  const RewardsScreen({super.key});

  @override
  State<RewardsScreen> createState() => _RewardsScreenState();
}

class _RewardsScreenState extends State<RewardsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // Load gamification data
    context.read<GamificationBloc>().add(LoadGamificationData());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: Text(
          'Rewards',
          style: AppFonts.heading1.copyWith(color: AppColors.textPrimary),
        ),
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primaryColor,
          unselectedLabelColor: AppColors.textSecondary,
          labelStyle: AppFonts.bodyMedium.copyWith(fontWeight: FontWeight.w600),
          unselectedLabelStyle: AppFonts.bodyMedium,
          indicatorColor: AppColors.primaryColor,
          indicatorWeight: 3,
          tabs: const [
            Tab(text: 'Progress'),
            Tab(text: 'Badges'),
            Tab(text: 'Leaderboard'),
          ],
        ),
      ),
      body: BlocListener<GamificationBloc, GamificationState>(
        listener: (context, state) {
          if (state is BadgeUnlocked) {
            _showBadgeUnlockedDialog(state.badge);
          } else if (state is XPAdded && state.leveledUp) {
            _showLevelUpDialog(state.newLevel!);
          }
        },
        child: BlocBuilder<GamificationBloc, GamificationState>(
          builder: (context, state) {
            if (state is GamificationLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is GamificationError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error, size: 64, color: AppColors.errorColor),
                    const SizedBox(height: 16),
                    Text(
                      'Error loading rewards',
                      style: AppFonts.heading2.copyWith(
                        color: AppColors.errorColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      state.message,
                      style: AppFonts.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<GamificationBloc>().add(
                          LoadGamificationData(),
                        );
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            if (state is GamificationLoaded ||
                state is BadgeUnlocked ||
                state is XPAdded) {
              late GamificationLoaded loadedState;

              if (state is BadgeUnlocked) {
                loadedState = state.previousState;
              } else if (state is XPAdded) {
                loadedState = state.previousState;
              } else {
                loadedState = state as GamificationLoaded;
              }

              return TabBarView(
                controller: _tabController,
                children: [
                  _buildProgressTab(loadedState),
                  _buildBadgesTab(loadedState),
                  _buildLeaderboardTab(loadedState),
                ],
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildProgressTab(GamificationLoaded state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          XPProgressCard(userProgress: state.userProgress),
          const SizedBox(height: 16),
          StreakDisplay(userProgress: state.userProgress),
          const SizedBox(height: 16),
          _buildWeeklyStatsCard(state.weeklyStats),
        ],
      ),
    );
  }

  Widget _buildBadgesTab(GamificationLoaded state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: BadgesGrid(
        allBadges: state.allBadges,
        unlockedBadges: state.unlockedBadges,
      ),
    );
  }

  Widget _buildLeaderboardTab(GamificationLoaded state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: LeaderboardPreview(leaderboard: state.leaderboard),
    );
  }

  Widget _buildWeeklyStatsCard(Map<String, dynamic> weeklyStats) {
    final currentWeekXP = weeklyStats['currentWeekXP'] as int;
    final weeklyGoal = weeklyStats['weeklyGoal'] as int;
    final progress = currentWeekXP / weeklyGoal;

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
          Text(
            'Weekly Progress',
            style: AppFonts.heading3.copyWith(color: AppColors.textPrimary),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$currentWeekXP XP',
                style: AppFonts.bodyLarge.copyWith(
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'Goal: $weeklyGoal XP',
                style: AppFonts.bodyMedium.copyWith(
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
            minHeight: 8,
          ),
          const SizedBox(height: 8),
          Text(
            '${(progress * 100).toInt()}% complete',
            style: AppFonts.caption.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  void _showBadgeUnlockedDialog(badge) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: AppColors.cardBackground,
            title: Text(
              'Badge Unlocked!',
              style: AppFonts.heading2.copyWith(color: AppColors.primaryColor),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.emoji_events,
                  size: 64,
                  color: AppColors.primaryColor,
                ),
                const SizedBox(height: 16),
                Text(
                  badge.name,
                  style: AppFonts.heading3.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  badge.description,
                  style: AppFonts.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'Awesome!',
                  style: AppFonts.bodyMedium.copyWith(
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
            ],
          ),
    );
  }

  void _showLevelUpDialog(int newLevel) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: AppColors.cardBackground,
            title: Text(
              'Level Up!',
              style: AppFonts.heading2.copyWith(color: AppColors.primaryColor),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.trending_up,
                  size: 64,
                  color: AppColors.primaryColor,
                ),
                const SizedBox(height: 16),
                Text(
                  'Level $newLevel',
                  style: AppFonts.heading1.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Congratulations! You\'ve reached a new level!',
                  style: AppFonts.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'Amazing!',
                  style: AppFonts.bodyMedium.copyWith(
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
            ],
          ),
    );
  }
}
