import 'package:flutter/material.dart';
import 'package:lexi_quest/core/theme/app_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/app_assets.dart';
import '../../../core/widgets/primary_button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 0.5, 1.0],
            colors: [
              AppColors.primaryIndigo600,
              AppColors.primaryIndigo500,
              AppColors.neutralSlate50,
            ],
          ),
        ),
        child: Stack(
          children: [
            // Top right positioned SVG placeholder
            Positioned(
              top: MediaQuery.of(context).padding.top + 16,
              right: 0,
              child: Image.asset(
                AppAssets.illLiney,
                width: 96,
                // height: 32,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  // Fallback to icon if image not found
                  return Icon(
                    Icons.auto_awesome,
                    color: Colors.white.withValues(alpha: 0.8),
                    size: 20,
                  );
                },
              ),
            ),

            // Centered content with logo
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        AppAssets.logo,
                        width: 70,
                        fit: BoxFit.contain,
                      ),
                      SizedBox(width: 25),
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Positioned(
                            bottom: -20,
                            child: Image.asset(AppAssets.illLineWave),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Annotate, Validate, Earn XP! With",
                                style: AppFonts.bodySmall,
                              ),
                              // App name with different colors
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Lexi',
                                      style: AppFonts.headlineLarge.copyWith(
                                        fontSize: 40,
                                      ),
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
                  ),

                  const SizedBox(height: 48),

                  // Get Started Button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: PrimaryButton(
                      text: "Get Started",
                      iconPath: AppAssets.icArrowRight,
                      onPressed: () {
                        // TODO: Navigate to next screen
                        debugPrint("Get Started pressed");
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
