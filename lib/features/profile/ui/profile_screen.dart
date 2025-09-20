import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_fonts.dart';
import '../../gamification/bloc/gamification_bloc.dart';
import '../../gamification/bloc/gamification_event.dart';
import '../../gamification/bloc/gamification_state.dart';
import 'widgets/profile_header.dart';
import 'widgets/stats_summary.dart';
import 'widgets/recent_achievements.dart';
import 'widgets/settings_section.dart';

/// Profile screen - shows user info, stats, and settings
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    // Load gamification data for stats
    context.read<GamificationBloc>().add(LoadGamificationData());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: BlocBuilder<GamificationBloc, GamificationState>(
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
                    'Error loading profile',
                    style: AppFonts.heading2.copyWith(
                      color: AppColors.errorColor,
                    ),
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

            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 120,
                  pinned: true,
                  backgroundColor: AppColors.backgroundColor,
                  foregroundColor: AppColors.textPrimary,
                  elevation: 0,
                  flexibleSpace: FlexibleSpaceBar(
                    title: Text(
                      'Profile',
                      style: AppFonts.heading1.copyWith(
                        color: AppColors.textPrimary,
                        fontSize: 20,
                      ),
                    ),
                    centerTitle: false,
                    titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ProfileHeader(userProgress: loadedState.userProgress),
                        const SizedBox(height: 20),
                        StatsSummary(
                          userProgress: loadedState.userProgress,
                          weeklyStats: loadedState.weeklyStats,
                        ),
                        const SizedBox(height: 20),
                        RecentAchievements(
                          unlockedBadges: loadedState.unlockedBadges,
                        ),
                        const SizedBox(height: 20),
                        const SettingsSection(),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
