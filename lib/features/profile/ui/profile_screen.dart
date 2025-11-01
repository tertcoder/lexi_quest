import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:lexi_quest/core/theme/app_colors.dart';
import 'package:lexi_quest/core/theme/app_fonts.dart';
import 'package:lexi_quest/core/utils/app_assets.dart';
import 'package:lexi_quest/routes.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock user data
    const String username = 'Bon';
    const int totalXp = 8750;
    const int level = 7;
    const int currentLevelXp = 750;
    const int nextLevelXp = 1000;
    const int streak = 15;
    const int annotationsCompleted = 875;
    final double levelProgress = currentLevelXp / nextLevelXp;

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: SingleChildScrollView(
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Profile',
                          style: AppFonts.headlineMedium.copyWith(
                            color: AppColors.onPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            context.push(AppRoutes.settings);
                          },
                          icon: const Icon(
                            Icons.settings,
                            color: AppColors.onPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Profile Avatar with Edit Button
                    Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.secondaryAmber500,
                              width: 4,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.secondaryAmber500.withValues(alpha: 0.3),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            radius: 50,
                            backgroundImage: AssetImage(AppAssets.defaultProfile),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.neutralWhite,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.neutralSlate900_25.withValues(alpha: 0.2),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.edit,
                              color: AppColors.primaryIndigo600,
                              size: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Username with verified badge
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          username,
                          style: AppFonts.headlineMedium.copyWith(
                            color: AppColors.onPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: AppColors.secondaryGreen500,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check,
                            color: AppColors.neutralWhite,
                            size: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Level Badge with gradient
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.secondaryAmber500.withValues(alpha: 0.2),
                            AppColors.secondaryAmber500.withValues(alpha: 0.1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppColors.secondaryAmber500.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(
                            AppAssets.badgeGold,
                            width: 20,
                            height: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Level $level',
                            style: AppFonts.titleSmall.copyWith(
                              color: AppColors.neutralWhite,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Stats Cards
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            icon: Icons.star,
                            iconColor: AppColors.secondaryAmber500,
                            value: totalXp.toString(),
                            label: 'Total XP',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildStatCard(
                            icon: Icons.local_fire_department,
                            iconColor: AppColors.secondaryRed500,
                            value: streak.toString(),
                            label: 'Day Streak',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            icon: Icons.check_circle,
                            iconColor: AppColors.secondaryGreen500,
                            value: annotationsCompleted.toString(),
                            label: 'Completed',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildStatCard(
                            icon: Icons.emoji_events,
                            iconColor: AppColors.primaryIndigo600,
                            value: '6th',
                            label: 'Rank',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Level Progress
                    Text(
                      'Level Progress',
                      style: AppFonts.titleMedium.copyWith(
                        color: AppColors.onBackground,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.neutralSlate600_30,
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Level $level',
                                style: AppFonts.bodyMedium.copyWith(
                                  color: AppColors.onSurfaceVariant,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                'Level ${level + 1}',
                                style: AppFonts.bodyMedium.copyWith(
                                  color: AppColors.onSurfaceVariant,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Stack(
                            children: [
                              Container(
                                height: 12,
                                decoration: BoxDecoration(
                                  color: AppColors.neutralSlate600_30,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                              FractionallySizedBox(
                                widthFactor: levelProgress,
                                child: Container(
                                  height: 12,
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        AppColors.secondaryGreen500,
                                        AppColors.secondaryAmber500,
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '$currentLevelXp / $nextLevelXp XP',
                            style: AppFonts.bodySmall.copyWith(
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Edit Profile Button
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppColors.primaryIndigo600, AppColors.primaryIndigo500],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryIndigo600.withValues(alpha: 0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: AppColors.neutralWhite.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.person,
                                  color: AppColors.neutralWhite,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Edit Profile',
                                    style: AppFonts.titleMedium.copyWith(
                                      color: AppColors.neutralWhite,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'Update your information',
                                    style: AppFonts.bodySmall.copyWith(
                                      color: AppColors.neutralWhite.withValues(alpha: 0.8),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const Icon(
                            Icons.arrow_forward_ios,
                            color: AppColors.neutralWhite,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Badges Section
                    Text(
                      'Badges',
                      style: AppFonts.titleMedium.copyWith(
                        color: AppColors.onBackground,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.neutralSlate600_30,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildBadge(AppAssets.badgeBronze, 'Bronze', true),
                          _buildBadge(AppAssets.badgeSilver, 'Silver', true),
                          _buildBadge(AppAssets.badgeGold, 'Gold', true),
                          _buildBadge(AppAssets.badgeDiamond, 'Diamond', false),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Settings Options
                    Text(
                      'Settings',
                      style: AppFonts.titleMedium.copyWith(
                        color: AppColors.onBackground,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildSettingsTile(
                      icon: Icons.person_outline,
                      title: 'Edit Profile',
                      onTap: () {
                        // TODO: Navigate to edit profile
                      },
                    ),
                    _buildSettingsTile(
                      icon: Icons.notifications_outlined,
                      title: 'Notifications',
                      onTap: () {
                        // TODO: Navigate to notifications settings
                      },
                    ),
                    _buildSettingsTile(
                      icon: Icons.language_outlined,
                      title: 'Language',
                      trailing: Text(
                        'English',
                        style: AppFonts.bodyMedium.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                      onTap: () {
                        // TODO: Navigate to language settings
                      },
                    ),
                    _buildSettingsTile(
                      icon: Icons.dark_mode_outlined,
                      title: 'Dark Mode',
                      trailing: Switch(
                        value: false,
                        onChanged: (value) {
                          // TODO: Toggle dark mode
                        },
                        activeColor: AppColors.primaryIndigo600,
                      ),
                      onTap: null,
                    ),
                    _buildSettingsTile(
                      icon: Icons.help_outline,
                      title: 'Help & Support',
                      onTap: () {
                        // TODO: Navigate to help
                      },
                    ),
                    _buildSettingsTile(
                      icon: Icons.info_outline,
                      title: 'About',
                      onTap: () {
                        // TODO: Navigate to about
                      },
                    ),
                    const SizedBox(height: 12),
                    _buildSettingsTile(
                      icon: Icons.logout,
                      title: 'Logout',
                      iconColor: AppColors.secondaryRed500,
                      titleColor: AppColors.secondaryRed500,
                      onTap: () {
                        _showLogoutDialog(context);
                      },
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required Color iconColor,
    required String value,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.neutralSlate600_30,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: iconColor,
            size: 32,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: AppFonts.titleLarge.copyWith(
              color: AppColors.onBackground,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppFonts.bodySmall.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(String assetPath, String label, bool isUnlocked) {
    return Column(
      children: [
        Opacity(
          opacity: isUnlocked ? 1.0 : 0.3,
          child: SvgPicture.asset(
            assetPath,
            width: 48,
            height: 48,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: AppFonts.bodySmall.copyWith(
            color: isUnlocked
                ? AppColors.onBackground
                : AppColors.onSurfaceVariant,
            fontWeight: isUnlocked ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    Widget? trailing,
    Color? iconColor,
    Color? titleColor,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.neutralSlate600_30,
        ),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(
          icon,
          color: iconColor ?? AppColors.onSurfaceVariant,
        ),
        title: Text(
          title,
          style: AppFonts.bodyMedium.copyWith(
            color: titleColor ?? AppColors.onBackground,
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing: trailing ??
            (onTap != null
                ? const Icon(
                    Icons.chevron_right,
                    color: AppColors.onSurfaceVariant,
                  )
                : null),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Logout',
          style: AppFonts.titleLarge.copyWith(
            color: AppColors.onBackground,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Are you sure you want to logout?',
          style: AppFonts.bodyMedium.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: AppFonts.buttonText.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // TODO: Implement logout
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.secondaryRed500,
            ),
            child: Text(
              'Logout',
              style: AppFonts.buttonText.copyWith(
                color: AppColors.onPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
