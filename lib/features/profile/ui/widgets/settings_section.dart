import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_fonts.dart';

class SettingsSection extends StatelessWidget {
  const SettingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Settings',
          style: AppFonts.heading3.copyWith(color: AppColors.textPrimary),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.borderColor),
          ),
          child: Column(
            children: [
              _buildSettingsItem(
                Icons.notifications,
                'Notifications',
                'Manage your notification preferences',
                () => _showNotificationSettings(context),
              ),
              _buildDivider(),
              _buildSettingsItem(
                Icons.security,
                'Privacy & Security',
                'Manage your privacy settings',
                () => _showPrivacySettings(context),
              ),
              _buildDivider(),
              _buildSettingsItem(
                Icons.help,
                'Help & Support',
                'Get help and contact support',
                () => _showHelpDialog(context),
              ),
              _buildDivider(),
              _buildSettingsItem(
                Icons.info,
                'About',
                'App version and information',
                () => _showAboutDialog(context),
              ),
              _buildDivider(),
              _buildSettingsItem(
                Icons.logout,
                'Logout',
                'Sign out of your account',
                () => _showLogoutDialog(context),
                isDestructive: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsItem(
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap, {
    bool isDestructive = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color:
                    isDestructive
                        ? AppColors.errorColor.withValues(alpha: 0.1)
                        : AppColors.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color:
                    isDestructive
                        ? AppColors.errorColor
                        : AppColors.primaryColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppFonts.bodyMedium.copyWith(
                      color:
                          isDestructive
                              ? AppColors.errorColor
                              : AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: AppFonts.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: AppColors.textSecondary, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      color: AppColors.borderColor,
      indent: 16,
      endIndent: 16,
    );
  }

  void _showNotificationSettings(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: AppColors.cardBackground,
            title: Text(
              'Notification Settings',
              style: AppFonts.heading3.copyWith(color: AppColors.textPrimary),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildSwitchTile('Task Reminders', true),
                _buildSwitchTile('Achievement Notifications', true),
                _buildSwitchTile('Weekly Progress', false),
                _buildSwitchTile('Streak Alerts', true),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'Save',
                  style: AppFonts.bodyMedium.copyWith(
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
            ],
          ),
    );
  }

  Widget _buildSwitchTile(String title, bool initialValue) {
    return StatefulBuilder(
      builder:
          (context, setState) => SwitchListTile(
            title: Text(
              title,
              style: AppFonts.bodyMedium.copyWith(color: AppColors.textPrimary),
            ),
            value: initialValue,
            onChanged: (value) => setState(() {}),
            activeColor: AppColors.primaryColor,
            contentPadding: EdgeInsets.zero,
          ),
    );
  }

  void _showPrivacySettings(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: AppColors.cardBackground,
            title: Text(
              'Privacy & Security',
              style: AppFonts.heading3.copyWith(color: AppColors.textPrimary),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildPrivacyOption(
                  'Data Collection',
                  'Manage how we collect your data',
                ),
                const SizedBox(height: 16),
                _buildPrivacyOption(
                  'Account Security',
                  'Change password and security settings',
                ),
                const SizedBox(height: 16),
                _buildPrivacyOption(
                  'Data Export',
                  'Download your annotation data',
                ),
                const SizedBox(height: 16),
                _buildPrivacyOption(
                  'Delete Account',
                  'Permanently delete your account',
                ),
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

  Widget _buildPrivacyOption(String title, String subtitle) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppFonts.bodyMedium.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: AppFonts.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: AppColors.textSecondary, size: 16),
          ],
        ),
      ),
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: AppColors.cardBackground,
            title: Text(
              'Help & Support',
              style: AppFonts.heading3.copyWith(color: AppColors.textPrimary),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Need help? Contact our support team:',
                  style: AppFonts.bodyMedium.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Email: support@lexiquest.com',
                  style: AppFonts.bodyMedium.copyWith(
                    color: AppColors.primaryColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'FAQ: lexiquest.com/help',
                  style: AppFonts.bodyMedium.copyWith(
                    color: AppColors.primaryColor,
                  ),
                ),
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

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: AppColors.cardBackground,
            title: Text(
              'About LexiQuest',
              style: AppFonts.heading3.copyWith(color: AppColors.textPrimary),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'LexiQuest v1.0.0',
                  style: AppFonts.bodyLarge.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'A learning and productivity app for annotation and labeling skills with gamification features.',
                  style: AppFonts.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  '© 2024 LexiQuest. All rights reserved.',
                  style: AppFonts.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
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

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: AppColors.cardBackground,
            title: Text(
              'Logout',
              style: AppFonts.heading3.copyWith(color: AppColors.textPrimary),
            ),
            content: Text(
              'Are you sure you want to logout?',
              style: AppFonts.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'Cancel',
                  style: AppFonts.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  context.go('/welcome');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.errorColor,
                ),
                child: const Text(
                  'Logout',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
    );
  }
}
