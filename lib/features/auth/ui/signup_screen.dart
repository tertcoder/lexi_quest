import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lexi_quest/core/theme/app_colors.dart';
import 'package:lexi_quest/core/theme/app_fonts.dart';
import 'package:lexi_quest/core/utils/app_assets.dart';
import 'package:lexi_quest/core/widgets/app_input_field.dart';
import 'package:lexi_quest/core/widgets/primary_button.dart';
import 'package:lexi_quest/features/auth/ui/widgets/logo_header.dart';
import 'package:lexi_quest/features/auth/ui/widgets/positioned_liney.dart';
import 'package:lexi_quest/routes.dart';
import 'package:lexi_quest/features/auth/bloc/auth_bloc.dart';
import 'package:lexi_quest/features/auth/bloc/auth_event.dart';
import 'package:lexi_quest/features/auth/bloc/auth_state.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _agreedToTerms = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleSignUp(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;
    if (!_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please agree to Terms & Conditions'),
          backgroundColor: AppColors.secondaryRed500,
        ),
      );
      return;
    }

    context.read<AuthBloc>().add(
      SignUpRequested(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        username: _nameController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(),
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Account created successfully!'),
                backgroundColor: AppColors.secondaryGreen500,
              ),
            );
            context.go(AppRoutes.mainNav);
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.secondaryRed500,
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoading;

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
                    const PositionedLiney(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 72),
                          const LogoHeader(),
                          const SizedBox(height: 42),
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
                                      MediaQuery.of(context).viewInsets.bottom +
                                      16,
                                ),
                                child: Form(
                                  key: _formKey,
                                  child: Column(
                                    children: [
                                      // Welcome Badge
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 8,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppColors.primaryIndigo600
                                              .withValues(alpha: 0.1),
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(
                                              Icons.rocket_launch,
                                              color: AppColors.primaryIndigo600,
                                              size: 20,
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              "Start Your Journey",
                                              style: AppFonts.labelMedium
                                                  .copyWith(
                                                    color:
                                                        AppColors
                                                            .primaryIndigo600,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        "Create Account",
                                        style: AppFonts.headlineLarge.copyWith(
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        "Join LexiQuest and start earning XP, unlocking achievements, and contributing to amazing projects",
                                        style: AppFonts.bodyMedium.copyWith(
                                          color: AppColors.onSurfaceVariant,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 32),
                                      AppInputField(
                                        controller: _nameController,
                                        placeholder: "Your Full Name",
                                        keyboardType: TextInputType.name,
                                      ),
                                      SizedBox(height: 12),
                                      AppInputField(
                                        controller: _emailController,
                                        placeholder: "Your Email",
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter your email';
                                          }
                                          if (!value.contains('@')) {
                                            return 'Please enter a valid email';
                                          }
                                          return null;
                                        },
                                      ),
                                      SizedBox(height: 12),
                                      AppInputField(
                                        controller: _passwordController,
                                        placeholder: "Create Password",
                                        isPassword: true,
                                      ),
                                      SizedBox(height: 12),
                                      AppInputField(
                                        controller: _confirmPasswordController,
                                        placeholder: "Confirm Password",
                                        isPassword: true,
                                      ),
                                      const SizedBox(height: 24),
                                      // Terms checkbox
                                      GestureDetector(
                                        onTap:
                                            () => setState(
                                              () =>
                                                  _agreedToTerms =
                                                      !_agreedToTerms,
                                            ),
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 20,
                                              height: 20,
                                              decoration: BoxDecoration(
                                                color:
                                                    _agreedToTerms
                                                        ? AppColors
                                                            .primaryIndigo600
                                                        : Colors.transparent,
                                                border: Border.all(
                                                  color:
                                                      AppColors
                                                          .primaryIndigo600,
                                                  width: 2,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                              child:
                                                  _agreedToTerms
                                                      ? const Icon(
                                                        Icons.check,
                                                        size: 14,
                                                        color: Colors.white,
                                                      )
                                                      : null,
                                            ),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: Text(
                                                "I agree to Terms & Conditions and Privacy Policy",
                                                style: AppFonts.bodySmall
                                                    .copyWith(
                                                      color:
                                                          AppColors
                                                              .onSurfaceVariant,
                                                    ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 24),
                                      PrimaryButton(
                                        text:
                                            isLoading
                                                ? "Creating Account..."
                                                : "Create Account",
                                        onPressed:
                                            isLoading
                                                ? null
                                                : () => _handleSignUp(context),
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
                                                color:
                                                    AppColors
                                                        .neutralSlate600_30,
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 16.0,
                                                  ),
                                              child: Text(
                                                "Or sign up with",
                                                style: AppFonts.bodySmall
                                                    .copyWith(
                                                      color:
                                                          AppColors
                                                              .onSurfaceVariant,
                                                    ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Container(
                                                height: 1,
                                                color:
                                                    AppColors
                                                        .neutralSlate600_30,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          // Google Button
                                          GestureDetector(
                                            onTap: () {
                                              debugPrint(
                                                "Google sign up pressed",
                                              );
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                  color:
                                                      AppColors
                                                          .neutralSlate600_30,
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
                                              debugPrint(
                                                "Facebook sign up pressed",
                                              );
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                  color:
                                                      AppColors
                                                          .neutralSlate600_30,
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
                                              color:
                                                  AppColors.neutralSlate600_30,
                                              width: 1,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              24,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              RichText(
                                                text: TextSpan(
                                                  children: [
                                                    TextSpan(
                                                      text:
                                                          "Already have an account? ",
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
                                                                AppColors
                                                                    .onBackground,
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
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
