import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:lexi_quest/core/theme/app_colors.dart';
import 'package:lexi_quest/core/theme/app_fonts.dart';
import 'package:lexi_quest/core/utils/app_assets.dart';
import 'package:lexi_quest/core/config/supabase_config.dart';
import 'package:lexi_quest/features/auth/ui/widgets/logo_header.dart';
import 'package:lexi_quest/routes.dart';

/// Splash screen shown during app initialization
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  String _loadingMessage = 'Initializing...';

  @override
  void initState() {
    super.initState();
    
    // Setup animations
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutBack),
      ),
    );

    _animationController.forward();

    // Initialize app
    _initializeApp();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _initializeApp() async {
    try {
      // Update loading message
      setState(() => _loadingMessage = 'Connecting to services...');
      
      // Wait for animation to complete
      await Future.delayed(const Duration(milliseconds: 800));
      
      // Check authentication status
      setState(() => _loadingMessage = 'Checking authentication...');
      await Future.delayed(const Duration(milliseconds: 500));
      
      final isAuthenticated = SupabaseConfig.client.auth.currentUser != null;
      
      setState(() => _loadingMessage = 'Loading your data...');
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Navigate to appropriate screen
      if (!mounted) return;
      
      if (isAuthenticated) {
        context.go(AppRoutes.mainNav);
      } else {
        context.go(AppRoutes.welcome);
      }
    } catch (e) {
      setState(() => _loadingMessage = 'Something went wrong...');
      await Future.delayed(const Duration(seconds: 2));
      
      if (!mounted) return;
      context.go(AppRoutes.welcome);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primaryIndigo600,
              AppColors.primaryIndigo500,
              AppColors.primary,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),
              
              // Animated Logo
              FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: LogoHeader(),
                ),
              ),
              
              const Spacer(flex: 2),
              
              // Loading Indicator
              FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  children: [
                    // Circular Progress Indicator
                    SizedBox(
                      width: 40,
                      height: 40,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.neutralWhite.withValues(alpha: 0.9),
                        ),
                        strokeWidth: 3,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Loading Message
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: Text(
                        _loadingMessage,
                        key: ValueKey(_loadingMessage),
                        style: AppFonts.bodyMedium.copyWith(
                          color: AppColors.neutralWhite.withValues(alpha: 0.8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }
}
