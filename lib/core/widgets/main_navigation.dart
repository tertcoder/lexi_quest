import 'package:flutter/material.dart';
import 'package:lexi_quest/core/theme/app_colors.dart';
import 'package:lexi_quest/core/theme/app_fonts.dart';
import 'package:lexi_quest/features/home/ui/home_screen.dart';
import 'package:lexi_quest/features/projects/ui/projects_screen.dart';
import 'package:lexi_quest/features/leaderboard/ui/leaderboard_screen.dart';
import 'package:lexi_quest/features/profile/ui/profile_screen.dart';

/// Main navigation wrapper with bottom navigation bar
class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const ProjectsScreen(),
    const LeaderboardScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Main content
          IndexedStack(
            index: _currentIndex,
            children: _screens,
          ),
          
          // Floating Bottom Navigation
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: Container(
              height: 70,
              decoration: BoxDecoration(
                color: AppColors.neutralWhite,
                borderRadius: BorderRadius.circular(35),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryIndigo600.withAlpha(38),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                    spreadRadius: 0,
                  ),
                  BoxShadow(
                    color: AppColors.neutralSlate900_25.withAlpha(25),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(Icons.home_rounded, Icons.home_outlined, 'Home', 0),
                  _buildNavItem(Icons.folder_rounded, Icons.folder_outlined, 'Projects', 1),
                  _buildNavItem(Icons.leaderboard_rounded, Icons.leaderboard_outlined, 'Leaderboard', 2),
                  _buildNavItem(Icons.person_rounded, Icons.person_outline, 'Profile', 3),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData activeIcon, IconData inactiveIcon, String label, int index) {
    final isActive = _currentIndex == index;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: isActive ? 16 : 12,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: isActive 
              ? AppColors.primaryIndigo600.withAlpha(25)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isActive ? activeIcon : inactiveIcon,
              color: isActive 
                  ? AppColors.primaryIndigo600 
                  : AppColors.onSurfaceVariant,
              size: 24,
            ),
            if (isActive) ...[
              const SizedBox(width: 8),
              Text(
                label,
                style: AppFonts.labelMedium.copyWith(
                  color: AppColors.primaryIndigo600,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
