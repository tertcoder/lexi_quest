import 'package:flutter/material.dart';
import 'package:lexi_quest/core/theme/app_colors.dart';
import 'package:lexi_quest/core/theme/app_fonts.dart';
import 'package:lexi_quest/core/utils/app_assets.dart';

class LogoHeader extends StatelessWidget {
  const LogoHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      // mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(AppAssets.logo, width: 70, fit: BoxFit.contain),
        SizedBox(width: 25),
        Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(bottom: -20, child: Image.asset(AppAssets.illLineWave)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Annotate, Validate, Earn XP! With",
                  style: AppFonts.bodySmall.copyWith(
                    color: AppColors.neutralSlate50,
                  ),
                ),
                // App name with different colors
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Lexi',
                        style: AppFonts.headlineLarge.copyWith(fontSize: 40),
                      ),
                      TextSpan(
                        text: 'Quest',
                        style: AppFonts.headlineLarge.copyWith(
                          fontSize: 40,
                          color: AppColors.secondaryAmber500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
