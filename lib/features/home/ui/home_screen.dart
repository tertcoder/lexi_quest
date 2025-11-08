import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import 'package:lexi_quest/core/theme/app_colors.dart';
import 'package:lexi_quest/core/theme/app_fonts.dart';
import 'package:lexi_quest/core/utils/app_assets.dart';
import 'package:lexi_quest/core/widgets/stat_card.dart';
import 'package:lexi_quest/routes.dart';
import 'package:lexi_quest/features/profile/bloc/profile_bloc.dart';
import 'package:lexi_quest/features/profile/bloc/profile_event.dart';
import 'package:lexi_quest/features/profile/bloc/profile_state.dart';
import 'package:lexi_quest/features/home/bloc/activity_bloc.dart';
import 'package:lexi_quest/features/home/bloc/activity_event.dart';
import 'package:lexi_quest/features/home/bloc/activity_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Load profile and activities once when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileBloc>().add(const LoadProfile());
      context.read<ActivityBloc>().add(const LoadActivities());
    });
  }

  /// Returns greeting based on current time
  String _getTimeBasedGreeting() {
    final hour = DateTime.now().hour;

    if (hour >= 5 && hour < 12) {
      return "Good Morning";
    } else if (hour >= 12 && hour < 17) {
      return "Good Afternoon";
    } else if (hour >= 17 && hour < 21) {
      return "Good Evening";
    } else {
      return "Good Night";
    }
  }

  /// Format timestamp to relative time
  String _formatTime(dynamic timestamp) {
    if (timestamp == null) return 'Just now';
    
    try {
      final DateTime dateTime = timestamp is DateTime 
          ? timestamp 
          : DateTime.parse(timestamp.toString());
      
      final Duration diff = DateTime.now().difference(dateTime);
      
      if (diff.inMinutes < 1) return 'Just now';
      if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
      if (diff.inHours < 24) return '${diff.inHours}h ago';
      if (diff.inDays < 7) return '${diff.inDays}d ago';
      return '${(diff.inDays / 7).floor()}w ago';
    } catch (e) {
      return 'Just now';
    }
  }

  /// Get badge asset based on level
  String _getBadgeForLevel(int level) {
    if (level >= 50) return AppAssets.badgeDiamond;
    if (level >= 25) return AppAssets.badgeGold;
    if (level >= 10) return AppAssets.badgeSilver;
    return AppAssets.badgeBronze;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        // Default values
        String username = 'User';
        int totalXp = 0;
        int streak = 0;
        int level = 1;
        double levelProgress = 0.0;

        if (state is ProfileLoaded) {
          username = state.profile.username;
          totalXp = state.profile.totalXp;
          streak = state.profile.streak;
          level = state.profile.level;
          levelProgress = state.profile.levelProgress;
        }

        return Scaffold(
          backgroundColor: AppColors.surface,
          body: SafeArea(
            child: RefreshIndicator(
              onRefresh: () async {
                context.read<ProfileBloc>().add(LoadProfile());
                context.read<ActivityBloc>().add(const LoadActivities());
                await Future.wait([
                  context.read<ProfileBloc>().stream.firstWhere(
                    (s) => s is ProfileLoaded || s is ProfileError,
                  ),
                  context.read<ActivityBloc>().stream.firstWhere(
                    (s) => s is ActivityLoaded || s is ActivityError,
                  ),
                ]);
              },
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                children: [
                  const SizedBox(height: 16),
                  // Header Row with Profile and Notification
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Profile Section
                      Expanded(
                        child: Row(
                          children: [
                            // Profile Image with border
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.secondaryAmber500,
                                  width: 2,
                                ),
                              ),
                              child: CircleAvatar(
                                radius: 28,
                                backgroundImage: AssetImage(
                                  AppAssets.defaultProfile,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            // Greeting Column
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Show skeleton loading if profile is loading
                                  if (state is ProfileLoading)
                                    Shimmer.fromColors(
                                      baseColor: Colors.grey[300]!,
                                      highlightColor: Colors.grey[100]!,
                                      child: Container(
                                        height: 20,
                                        width: 150,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                      ),
                                    )
                                  else
                                    Text(
                                      state is ProfileLoaded 
                                          ? "${_getTimeBasedGreeting()}, ${state.profile.username}!"
                                          : _getTimeBasedGreeting(),
                                      style: AppFonts.titleMedium.copyWith(
                                        color: AppColors.onBackground,
                                        fontSize: 18,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Time to annotate!",
                                    style: AppFonts.bodyMedium.copyWith(
                                      color: AppColors.onSurfaceVariant,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Notification Bell
                      GestureDetector(
                        onTap: () {
                          debugPrint("Notification bell tapped");
                          // TODO: Handle notification tap
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          child: SvgPicture.asset(
                            AppAssets.icBell,
                            width: 24,
                            height: 24,
                            colorFilter: ColorFilter.mode(
                              AppColors.onBackground,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.neutralSlate900_25),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: StatCard(
                                iconPath: AppAssets.illStreak,
                                number: streak.toString(),
                                label: "Streaks Day",
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: StatCard(
                                iconPath: AppAssets.illXp,
                                number: totalXp.toString(),
                                label: "Total XP",
                                numberColor: AppColors.secondaryGreen500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            border: Border.all(
                              color: AppColors.neutralSlate900_25,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                _getBadgeForLevel(level),
                                width: 40,
                                height: 40,
                              ),
                              const SizedBox(width: 4),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    level.toString().padLeft(2, '0'),
                                    style: AppFonts.headlineMedium.copyWith(
                                      color: AppColors.secondaryAmber500,
                                      fontWeight: FontWeight.w900,
                                      height: 1,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Level",
                                    style: AppFonts.bodyMedium.copyWith(
                                      color: AppColors.neutralSlate600_70,
                                      fontWeight: FontWeight.w600,
                                      height: 1,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Container(
                                  height: 48,
                                  padding: const EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    color: AppColors.onSurfaceVariant,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Stack(
                                    children: [
                                      LayoutBuilder(
                                        builder: (context, constraints) {
                                          return Container(
                                            width:
                                                constraints.maxWidth *
                                                levelProgress,
                                            decoration: BoxDecoration(
                                              color:
                                                  AppColors.secondaryGreen500,
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                          );
                                        },
                                      ),
                                      Center(
                                        child: Text(
                                          "${(levelProgress * 100).toInt()}%",
                                          style: AppFonts.titleMedium.copyWith(
                                            color: AppColors.onPrimary,
                                            fontWeight: FontWeight.w700,
                                            height: 1,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Quick Actions Title
                  Text(
                    "Quick Actions",
                    style: AppFonts.titleMedium.copyWith(
                      color: AppColors.onBackground,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Annotation Options Grid
                  Row(
                    children: [
                      // First Column
                      Expanded(
                        child: Column(
                          children: [
                            // Audio Annotation
                            GestureDetector(
                              onTap: () {
                                context.push(AppRoutes.audioAnnotation);
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 16,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.background,
                                  border: Border.all(
                                    color: AppColors.neutralSlate600_30,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Row(
                                  children: [
                                    SvgPicture.asset(AppAssets.icAudio),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        "Audio Annotation",
                                        style: AppFonts.bodyMedium.copyWith(
                                          color: AppColors.onSurfaceVariant,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            // Text Annotation
                            GestureDetector(
                              onTap: () {
                                context.push(AppRoutes.textAnnotation);
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 16,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.background,
                                  border: Border.all(
                                    color: AppColors.neutralSlate600_30,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Row(
                                  children: [
                                    SvgPicture.asset(AppAssets.icText),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        "Text Annotation",
                                        style: AppFonts.bodyMedium.copyWith(
                                          color: AppColors.onSurfaceVariant,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Second Column
                      Expanded(
                        child: Column(
                          children: [
                            // Image Annotation
                            GestureDetector(
                              onTap: () {
                                context.push(AppRoutes.imageAnnotation);
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 16,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.background,
                                  border: Border.all(
                                    color: AppColors.neutralSlate600_30,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Row(
                                  children: [
                                    SvgPicture.asset(AppAssets.icImage),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        "Image Annotation",
                                        style: AppFonts.bodyMedium.copyWith(
                                          color: AppColors.onSurfaceVariant,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            // Leaderboard
                            GestureDetector(
                              onTap: () {
                                context.push(AppRoutes.leaderboard);
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 16,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.background,
                                  border: Border.all(
                                    color: AppColors.neutralSlate600_30,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Row(
                                  children: [
                                    SvgPicture.asset(AppAssets.icLeaderboard),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        "Leaderboard",
                                        style: AppFonts.bodyMedium.copyWith(
                                          color: AppColors.onSurfaceVariant,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Recent Activities Section
                  Text(
                    "Recent Activities",
                    style: AppFonts.titleMedium.copyWith(
                      color: AppColors.onBackground,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Activities List
                  BlocBuilder<ActivityBloc, ActivityState>(
                    builder: (context, activityState) {
                      if (activityState is ActivityLoading) {
                        return Container(
                          padding: const EdgeInsets.all(32),
                          child: const Center(child: CircularProgressIndicator()),
                        );
                      }
                      
                      if (activityState is ActivityLoaded && activityState.activities.isNotEmpty) {
                        return Container(
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.neutralSlate600_30),
                          ),
                          child: Column(
                            children: activityState.activities.map((activity) {
                              return _buildActivityItem(
                                icon: Icons.check_circle,
                                iconColor: AppColors.success,
                                title: activity['title'] ?? 'Activity',
                                subtitle: activity['activity_type'] ?? '',
                                time: _formatTime(activity['created_at']),
                                xp: activity['xp_earned'] != null ? '+${activity['xp_earned']} XP' : null,
                              );
                            }).toList(),
                          ),
                        );
                      }
                      
                      return Container(
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.neutralSlate600_30),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(32),
                          child: Column(
                            children: [
                              Icon(Icons.history, size: 48, color: AppColors.onSurfaceVariant.withValues(alpha: 0.5)),
                              const SizedBox(height: 16),
                              Text('No recent activities', style: AppFonts.bodyMedium.copyWith(color: AppColors.onSurfaceVariant)),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 100),
                ],
              ), // Column
            ), // SingleChildScrollView
            ), // RefreshIndicator
          ), // SafeArea
        ); // Scaffold
      },
    );
  }

  Widget _buildActivityItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required String time,
    String? xp,
  }) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          // Icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 12),

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppFonts.bodyMedium.copyWith(
                    color: AppColors.onBackground,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: AppFonts.bodySmall.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),

          // Time and XP
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                time,
                style: AppFonts.labelSmall.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              if (xp != null) ...[
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.secondaryAmber500.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    xp,
                    style: AppFonts.labelSmall.copyWith(
                      color: AppColors.secondaryAmber500,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
