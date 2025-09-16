import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../theme/app_colors.dart';
import '../theme/app_fonts.dart';

/// Primary button component for LexiQuest app
///
/// Features:
/// - Primary background color with dark border
/// - Fixed height of 48px
/// - Optional leading or trailing icon
/// - Centered content
/// - Consistent styling across the app
class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final String? iconPath;
  final bool iconTrailing;
  final bool isLoading;
  final double? width;

  const PrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.iconPath,
    this.iconTrailing = true,
    this.isLoading = false,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          side: const BorderSide(color: AppColors.primaryIndigoDark, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24),
        ),
        child:
            isLoading
                ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.onPrimary,
                    ),
                  ),
                )
                : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Leading icon
                    if (iconPath != null && !iconTrailing) ...[
                      SvgPicture.asset(
                        iconPath!,
                        width: 20,
                        height: 20,
                        colorFilter: const ColorFilter.mode(
                          AppColors.onPrimary,
                          BlendMode.srcIn,
                        ),
                      ),
                      const SizedBox(width: 12),
                    ],

                    // Button text
                    Flexible(
                      child: Text(
                        text,
                        style: AppFonts.labelLarge.copyWith(
                          color: AppColors.onPrimary,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    // Trailing icon
                    if (iconPath != null && iconTrailing) ...[
                      const SizedBox(width: 12),
                      SvgPicture.asset(
                        iconPath!,
                        width: 20,
                        height: 20,
                        colorFilter: const ColorFilter.mode(
                          AppColors.onPrimary,
                          BlendMode.srcIn,
                        ),
                      ),
                    ],
                  ],
                ),
      ),
    );
  }
}
