import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lexi_quest/core/theme/app_colors.dart';
import 'package:lexi_quest/core/theme/app_fonts.dart';
import 'package:lexi_quest/core/widgets/app_input_field.dart';
import 'package:lexi_quest/core/widgets/primary_button.dart';
import 'package:lexi_quest/features/auth/ui/widgets/logo_header.dart';
import 'package:lexi_quest/features/auth/ui/widgets/positioned_liney.dart';
import 'package:lexi_quest/features/auth/bloc/auth_bloc.dart';
import 'package:lexi_quest/features/auth/bloc/auth_event.dart';
import 'package:lexi_quest/features/auth/bloc/auth_state.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _handleResetPassword(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;

    context.read<AuthBloc>().add(
      ResetPasswordRequested(email: _emailController.text.trim()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(),
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is PasswordResetSent) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Password reset link sent! Check your email.'),
                backgroundColor: AppColors.secondaryGreen500,
              ),
            );
            context.pop();
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
                            child: SingleChildScrollView(
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Forgot Password?',
                                      style: AppFonts.headlineLarge.copyWith(
                                        color: AppColors.onBackground,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Enter your email and we\'ll send you a link to reset your password.',
                                      style: AppFonts.bodyMedium.copyWith(
                                        color: AppColors.onSurfaceVariant,
                                      ),
                                    ),
                                    const SizedBox(height: 32),
                                    AppInputField(
                                      controller: _emailController,
                                      placeholder: 'Your Email',
                                      keyboardType: TextInputType.emailAddress,
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
                                    const SizedBox(height: 32),
                                    PrimaryButton(
                                      text: isLoading ? 'Sending...' : 'Send Reset Link',
                                      onPressed: isLoading ? null : () => _handleResetPassword(context),
                                    ),
                                    const SizedBox(height: 24),
                                    Center(
                                      child: TextButton(
                                        onPressed: () => context.pop(),
                                        child: Text(
                                          'Back to Login',
                                          style: AppFonts.bodyMedium.copyWith(
                                            color: AppColors.primaryIndigo600,
                                            fontWeight: FontWeight.w600,
                                          ),
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
