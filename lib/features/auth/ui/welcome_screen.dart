import 'package:flutter/material.dart';
import 'package:lexi_quest/features/auth/ui/widgets/logo_header.dart';
import 'package:lexi_quest/features/auth/ui/widgets/positioned_liney.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/app_assets.dart';
import '../../../core/widgets/primary_button.dart';
import 'package:go_router/go_router.dart';
import '../../../routes.dart';

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
            PositionedLiney(),
            // Centered content with logo
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  LogoHeader(),

                  const SizedBox(height: 48),

                  // Get Started Button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: PrimaryButton(
                      text: "Get Started",
                      iconPath: AppAssets.icArrowRight,
                      onPressed: () {
                        context.go(AppRoutes.login);
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
