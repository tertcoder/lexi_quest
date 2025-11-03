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

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;

    context.read<AuthBloc>().add(
      SignInRequested(
        email: _emailController.text.trim(),
        password: _passwordController.text,
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
                content: Text('Welcome back!'),
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
                                      MediaQuery.of(context).viewInsets.bottom +
                                      16,
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      "Welcome Back!",
                                      style: AppFonts.headlineMedium.copyWith(
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      "Get connected to your account and start annotating, validating and earn XP ",
                                      style: AppFonts.bodyMedium.copyWith(
                                        color: AppColors.onBackground,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: 32),
                                    Form(
                                      key: _formKey,
                                      child: Column(
                                        children: [
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
                                            placeholder: "Your Password",
                                            isPassword: true,
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 12),
                                    PrimaryButton(
                                      text:
                                          isLoading
                                              ? "Signing In..."
                                              : "Sign In",
                                      onPressed:
                                          isLoading
                                              ? null
                                              : () => _handleLogin(context),
                                    ),
                                    SizedBox(height: 16),
                                    // Forgot Password Link
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: TextButton(
                                        onPressed: () => context.push(AppRoutes.forgotPassword),
                                        child: Text(
                                          'Forgot Password?',
                                          style: AppFonts.bodyMedium.copyWith(
                                            color: AppColors.primaryIndigo600,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
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
                                                  AppColors.neutralSlate600_30,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 16.0,
                                            ),
                                            child: Text(
                                              "Or continue with",
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
                                                  AppColors.neutralSlate600_30,
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
                                            debugPrint("Google login pressed");
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
                                              "Facebook login pressed",
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
                                    // Sign Up Container
                                    GestureDetector(
                                      onTap: () {
                                        debugPrint("Sign up pressed");
                                        context.push(AppRoutes.register);
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
                                                        "Don't have an account yet? ",
                                                    style: AppFonts.bodyMedium
                                                        .copyWith(
                                                          color:
                                                              AppColors
                                                                  .onSurfaceVariant,
                                                        ),
                                                  ),
                                                  TextSpan(
                                                    text: "Sign up",
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
