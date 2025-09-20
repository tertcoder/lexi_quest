import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lexi_quest/core/theme/app_colors.dart';
import 'package:lexi_quest/core/theme/app_fonts.dart';

/// A reusable stat card widget that displays an icon, number, and label
class StatCard extends StatelessWidget {
  final String iconPath;
  final String number;
  final String label;
  final Color? numberColor;
  final Color? labelColor;

  const StatCard({
    super.key,
    required this.iconPath,
    required this.number,
    required this.label,
    this.numberColor,
    this.labelColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.neutralSlate50_10,
        border: Border.all(color: AppColors.neutralSlate900_25),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          SvgPicture.asset(iconPath, width: 32, height: 32),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                number,
                style: AppFonts.headlineMedium.copyWith(
                  color: numberColor ?? AppColors.secondaryAmber500,
                  fontWeight: FontWeight.w900,
                  height: 1,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: AppFonts.bodyMedium.copyWith(
                  color: labelColor ?? AppColors.neutralSlate50_70,
                  fontWeight: FontWeight.w600,
                  height: 1,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
