import 'package:flutter/material.dart';
import 'package:lexi_quest/core/theme/app_colors.dart';
import 'package:lexi_quest/core/theme/app_fonts.dart';

/// Custom app bar for annotation screens
class AnnotationAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final int currentXp;
  final VoidCallback? onBack;

  const AnnotationAppBar({
    super.key,
    required this.title,
    this.currentXp = 0,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primaryIndigo600, AppColors.primaryIndigo500],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              // Back Button
              IconButton(
                onPressed: onBack ?? () => Navigator.of(context).pop(),
                icon: const Icon(
                  Icons.arrow_back,
                  color: AppColors.onPrimary,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(width: 12),

              // Title
              Expanded(
                child: Text(
                  title,
                  style: AppFonts.titleLarge.copyWith(
                    color: AppColors.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // XP Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.secondaryAmber500,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.star,
                      color: AppColors.neutralWhite,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '$currentXp XP',
                      style: AppFonts.labelMedium.copyWith(
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
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(70);
}
