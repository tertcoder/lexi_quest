import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lexi_quest/core/theme/app_colors.dart';
import 'package:lexi_quest/core/theme/app_fonts.dart';
import 'package:lexi_quest/core/utils/app_assets.dart';
import 'package:lexi_quest/core/widgets/stat_card.dart';

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
        child: Padding(
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
                padding: EdgeInsets.all(16),
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
                            number: "1,250",
                            label: "Streaks Day",
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: StatCard(
                            iconPath: AppAssets.illXp,
                            number: "8,750",
                            label: "Total XP",
                            numberColor: AppColors.secondaryGreen500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        border: Border.all(color: AppColors.neutralSlate900_25),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            // badgeBronze | badgeSilver | badgeGold | badgeDiamond
                            AppAssets.badgeBronze,
                            width: 40,
                            height: 40,
                          ),
                          const SizedBox(width: 4),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "01",
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
                              padding: EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: AppColors.onSurfaceVariant,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Stack(
                                children: [
                                  Container(
                                    width: 110, // Example progress width
                                    decoration: BoxDecoration(
                                      color: AppColors.secondaryGreen500,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                  ),
                                  Center(
                                    child: Text(
                                      "50%",
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
                            debugPrint("Audio Annotation tapped");
                            // TODO: Navigate to audio annotation
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
                            debugPrint("Text Annotation tapped");
                            // TODO: Navigate to text annotation
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
                            debugPrint("Image Annotation tapped");
                            // TODO: Navigate to image annotation
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
                            debugPrint("Leaderboard tapped");
                            // TODO: Navigate to leaderboard
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
            ],
          ),
        ),
      ),
    );
  }
}
