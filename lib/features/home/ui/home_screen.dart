import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:lexi_quest/core/theme/app_colors.dart';
import 'package:lexi_quest/core/theme/app_fonts.dart';
import 'package:lexi_quest/core/utils/app_assets.dart';
import 'package:lexi_quest/core/widgets/stat_card.dart';
import 'package:lexi_quest/routes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
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
                  Row(
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
                          backgroundImage: AssetImage(AppAssets.defaultProfile),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Greeting Column
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${_getTimeBasedGreeting()} Bon",
                            style: AppFonts.titleMedium.copyWith(
                              color: AppColors.onBackground,
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            "Time to annotate!",
                            style: AppFonts.bodyMedium.copyWith(
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ],
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
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primaryIndigo600, AppColors.primaryIndigo500],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryIndigo600.withValues(alpha: 0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Top Stats Row
                    Row(
                      children: [
                        Expanded(
                          child: _buildModernStatCard(
                            icon: Icons.local_fire_department,
                            iconColor: AppColors.secondaryAmber500,
                            number: "1,250",
                            label: "Streaks Day",
                            backgroundColor: AppColors.primaryIndigo500,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildModernStatCard(
                            icon: Icons.stars_rounded,
                            iconColor: AppColors.secondaryGreen500,
                            number: "8,750",
                            label: "Total XP",
                            backgroundColor: AppColors.primaryIndigo500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    // Level Progress Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.neutralWhite,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.neutralSlate900_25.withValues(alpha: 0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          // Trophy Icon
                          Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              color: AppColors.secondaryAmber500.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Icon(
                              Icons.emoji_events,
                              color: AppColors.secondaryAmber500,
                              size: 32,
                            ),
                          ),
                          const SizedBox(width: 12),
                          
                          // Level Info
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "01",
                                style: AppFonts.headlineLarge.copyWith(
                                  color: AppColors.secondaryAmber500,
                                  fontWeight: FontWeight.w900,
                                  height: 1,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                "Level",
                                style: AppFonts.bodySmall.copyWith(
                                  color: AppColors.onSurfaceVariant,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 16),
                          
                          // Progress Bar
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "50%",
                                  style: AppFonts.titleMedium.copyWith(
                                    color: AppColors.secondaryGreen500,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: LinearProgressIndicator(
                                    value: 0.5,
                                    minHeight: 12,
                                    backgroundColor: AppColors.neutralSlate600_30,
                                    valueColor: const AlwaysStoppedAnimation<Color>(
                                      AppColors.secondaryGreen500,
                                    ),
                                  ),
                                ),
                              ],
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
              Container(
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.neutralSlate600_30,
                  ),
                ),
                child: Column(
                  children: [
                    _buildActivityItem(
                      icon: Icons.check_circle,
                      iconColor: AppColors.secondaryGreen500,
                      title: 'Completed Text Annotation',
                      subtitle: 'Sentiment Analysis Dataset',
                      time: '2 hours ago',
                      xp: '+15 XP',
                    ),
                    const Divider(height: 1, color: AppColors.neutralSlate600_30),
                    _buildActivityItem(
                      icon: Icons.image,
                      iconColor: AppColors.secondaryAmber500,
                      title: 'Annotated 5 images',
                      subtitle: 'Street Scene Detection',
                      time: '5 hours ago',
                      xp: '+125 XP',
                    ),
                    const Divider(height: 1, color: AppColors.neutralSlate600_30),
                    _buildActivityItem(
                      icon: Icons.verified,
                      iconColor: AppColors.primaryIndigo600,
                      title: 'Validation Approved',
                      subtitle: 'Medical Image Classification',
                      time: 'Yesterday',
                      xp: '+30 XP',
                    ),
                    const Divider(height: 1, color: AppColors.neutralSlate600_30),
                    _buildActivityItem(
                      icon: Icons.emoji_events,
                      iconColor: AppColors.secondaryAmber500,
                      title: 'Reached Level 7!',
                      subtitle: 'Keep up the great work',
                      time: '2 days ago',
                      xp: null,
                    ),
                  ],
                ),
              ),
              

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModernStatCard({
    required IconData icon,
    required Color iconColor,
    required String number,
    required String label,
    required Color backgroundColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.neutralWhite.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: iconColor,
            size: 32,
          ),
          const SizedBox(height: 12),
          Text(
            number,
            style: AppFonts.headlineMedium.copyWith(
              color: AppColors.neutralWhite,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppFonts.bodySmall.copyWith(
              color: AppColors.neutralWhite.withValues(alpha: 0.9),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
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
              color: iconColor.withValues(alpha:0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 20,
            ),
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
                    color: AppColors.secondaryAmber500.withValues(alpha:0.1),
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
