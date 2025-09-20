import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lexi_quest/core/theme/app_colors.dart';
import 'package:lexi_quest/core/theme/app_fonts.dart';
import 'package:lexi_quest/core/utils/app_assets.dart';
import 'package:lexi_quest/features/home/ui/home_screen.dart';
import 'package:lexi_quest/features/annotation/ui/annotation_list_screen.dart';
import 'package:lexi_quest/features/gamification/ui/rewards_screen.dart';
import 'package:lexi_quest/features/profile/ui/profile_screen.dart';

/// Main navigation shell with bottom navigation bar
/// Contains all main app screens: Home, Annotation, Rewards, Profile
class MainNavigationShell extends StatefulWidget {
  final int initialIndex;

  const MainNavigationShell({super.key, this.initialIndex = 0});

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  late int _currentIndex;
  late PageController _pageController;

  final List<Widget> _screens = [
    const HomeScreen(),
    const AnnotationListScreen(),
    const RewardsScreen(),
    const ProfileScreen(),
  ];

  final List<BottomNavigationItem> _navItems = [
    BottomNavigationItem(icon: AppAssets.icHome, label: 'Home'),
    BottomNavigationItem(icon: AppAssets.icAnnotation, label: 'Annotate'),
    BottomNavigationItem(icon: AppAssets.icStatistics, label: 'Rewards'),
    BottomNavigationItem(icon: AppAssets.icProfile, label: 'Profile'),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: _screens,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.background,
          boxShadow: [
            BoxShadow(
              color: AppColors.neutralSlate900_25,
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children:
                  _navItems.asMap().entries.map((entry) {
                    final index = entry.key;
                    final item = entry.value;
                    final isSelected = index == _currentIndex;

                    return GestureDetector(
                      onTap: () => _onTabTapped(index),
                      behavior: HitTestBehavior.opaque,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color:
                              isSelected
                                  ? AppColors.primaryIndigo600.withValues(
                                    alpha: 0.1,
                                  )
                                  : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SvgPicture.asset(
                              item.icon,
                              width: 24,
                              height: 24,
                              colorFilter: ColorFilter.mode(
                                isSelected
                                    ? AppColors.primaryIndigo600
                                    : AppColors.onSurfaceVariant,
                                BlendMode.srcIn,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item.label,
                              style: AppFonts.labelSmall.copyWith(
                                color:
                                    isSelected
                                        ? AppColors.primaryIndigo600
                                        : AppColors.onSurfaceVariant,
                                fontWeight:
                                    isSelected
                                        ? FontWeight.w600
                                        : FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}

/// Data class for bottom navigation items
class BottomNavigationItem {
  final String icon;
  final String label;

  BottomNavigationItem({required this.icon, required this.label});
}
