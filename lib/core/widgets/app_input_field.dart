import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../theme/app_colors.dart';
import '../theme/app_fonts.dart';
import '../utils/app_assets.dart';

/// Reusable text input field component for LexiQuest app
///
/// Features:
/// - Fixed height of 48px
/// - Background color with border styling
/// - Optional password visibility toggle
/// - Consistent styling across the app
/// - Full rounded corners
class AppInputField extends StatefulWidget {
  final String? placeholder;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final TextInputType keyboardType;
  final bool isPassword;
  final bool enabled;
  final int? maxLines;
  final String? initialValue;

  const AppInputField({
    super.key,
    this.placeholder,
    this.controller,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.keyboardType = TextInputType.text,
    this.isPassword = false,
    this.enabled = true,
    this.maxLines = 1,
    this.initialValue,
  });

  @override
  State<AppInputField> createState() => _AppInputFieldState();
}

class _AppInputFieldState extends State<AppInputField> {
  bool _obscureText = true;
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    if (widget.initialValue != null) {
      _controller.text = widget.initialValue!;
    }

    // Initialize obscure text based on password type
    _obscureText = widget.isPassword;
  }

  @override
  void dispose() {
    // Only dispose if we created the controller
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: TextFormField(
        controller: _controller,
        validator: widget.validator,
        onChanged: widget.onChanged,
        onFieldSubmitted: widget.onSubmitted,
        keyboardType: widget.keyboardType,
        obscureText: widget.isPassword ? _obscureText : false,
        enabled: widget.enabled,
        maxLines: widget.maxLines,
        style: AppFonts.bodyMedium.copyWith(color: AppColors.onBackground),
        decoration: InputDecoration(
          hintText: widget.placeholder,
          hintStyle: AppFonts.bodyMedium.copyWith(
            color: AppColors.neutralSlate600_70,
          ),
          filled: true,
          fillColor: AppColors.background,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 10,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24), // Full rounded
            borderSide: const BorderSide(
              color: AppColors.neutralSlate600_30,
              width: 1,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24),
            borderSide: const BorderSide(
              color: AppColors.neutralSlate600_30,
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24),
            borderSide: const BorderSide(color: AppColors.primary, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24),
            borderSide: const BorderSide(color: AppColors.error, width: 1),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24),
            borderSide: const BorderSide(color: AppColors.error, width: 2),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24),
            borderSide: BorderSide(
              color: AppColors.neutralSlate600_30.withOpacity(0.5),
              width: 1,
            ),
          ),
          // Trailing icon for password visibility toggle
          suffixIcon:
              widget.isPassword
                  ? IconButton(
                    icon: SvgPicture.asset(
                      _obscureText ? AppAssets.icEyeClosed : AppAssets.icEye,
                      colorFilter: const ColorFilter.mode(
                        AppColors.neutralSlate600_70,
                        BlendMode.srcIn,
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                    splashRadius: 20,
                  )
                  : null,
        ),
      ),
    );
  }
}
