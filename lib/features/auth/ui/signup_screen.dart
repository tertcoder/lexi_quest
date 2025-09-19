import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lexi_quest/core/theme/app_colors.dart';
import 'package:lexi_quest/core/theme/app_fonts.dart';
import 'package:lexi_quest/core/utils/app_assets.dart';
import 'package:lexi_quest/core/widgets/app_input_field.dart';
import 'package:lexi_quest/core/widgets/primary_button.dart';
import 'package:lexi_quest/features/auth/ui/widgets/logo_header.dart';
import 'package:lexi_quest/features/auth/ui/widgets/positioned_liney.dart';
import 'package:lexi_quest/routes.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

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
        child: SafeArea(
          child: Stack(
            children: [
              PositionedLiney(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 72),
                    LogoHeader(),
                    SizedBox(height: 42),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          border: const Border(
                            top: BorderSide(
                              color: AppColors.primaryVariant,
                              width: 6,
                            ),
                            right: BorderSide(
                              color: AppColors.primaryVariant,
                              width: 6,
                            ),
                            left: BorderSide(
                              color: AppColors.primaryVariant,
                              width: 6,
                            ),
                          ),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(25),
                            topRight: Radius.circular(25),
                          ),
                        ),
                        child: SingleChildScrollView(
                          padding: EdgeInsets.only(
                            bottom:
                                MediaQuery.of(context).viewInsets.bottom + 16,
                          ),
                          child: Column(
                            children: [
                              Text(
                                "Create Account",
                                style: AppFonts.headlineMedium.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                "Join LexiQuest and start your annotation journey to earn XP and unlock achievements",
                                style: AppFonts.bodyMedium.copyWith(
                                  color: AppColors.onBackground,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 32),
                              AppInputField(
                                placeholder: "Your Full Name",
                                keyboardType: TextInputType.name,
                              ),
                              SizedBox(height: 12),
                              AppInputField(
                                placeholder: "Your Email",
                                keyboardType: TextInputType.emailAddress,
                              ),
                              SizedBox(height: 12),
                              AppInputField(
                                placeholder: "Create Password",
                                isPassword: true,
                              ),
                              SizedBox(height: 12),
                              AppInputField(
                                placeholder: "Confirm Password",
                                isPassword: true,
                              ),
                              SizedBox(height: 20),
                              PrimaryButton(
                                text: "Create Account",
                                onPressed: () {
                                  // TODO: Implement sign up logic
                                  debugPrint("Create Account pressed");
                                  AppRoutes.navigateToHome(context);
                                },
                              ),
                              SizedBox(height: 12),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 20.0,
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        height: 1,
                                        color: AppColors.neutralSlate600_30,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0,
                                      ),
                                      child: Text(
                                        "Or sign up with",
                                        style: AppFonts.bodySmall.copyWith(
                                          color: AppColors.onSurfaceVariant,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        height: 1,
                                        color: AppColors.neutralSlate600_30,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Google Button
                                  GestureDetector(
                                    onTap: () {
                                      debugPrint("Google sign up pressed");
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: AppColors.neutralSlate600_30,
                                          width: 1,
                                        ),
                                      ),
                                      child: SvgPicture.asset(
                                        AppAssets.icGoogle,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  // Facebook Button
                                  GestureDetector(
                                    onTap: () {
                                      debugPrint("Facebook sign up pressed");
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: AppColors.neutralSlate600_30,
                                          width: 1,
                                        ),
                                      ),
                                      child: SvgPicture.asset(
                                        AppAssets.icFacebook,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),
                              // Sign In Container
                              GestureDetector(
                                onTap: () {
                                  debugPrint("Sign in pressed");
                                  Navigator.of(context).pop();
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: AppColors.neutralSlate600_30,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: "Already have an account? ",
                                              style: AppFonts.bodyMedium
                                                  .copyWith(
                                                    color:
                                                        AppColors
                                                            .onSurfaceVariant,
                                                  ),
                                            ),
                                            TextSpan(
                                              text: "Sign in",
                                              style: AppFonts.labelLarge
                                                  .copyWith(
                                                    color:
                                                        AppColors.onBackground,
                                                    decoration:
                                                        TextDecoration
                                                            .underline,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SvgPicture.asset(
                                        AppAssets.icArrowRight,
                                        colorFilter: ColorFilter.mode(
                                          AppColors.onBackground,
                                          BlendMode.srcIn,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
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
}
