import 'package:flutter/material.dart';
import 'package:lexi_quest/core/utils/app_assets.dart';

class PositionedLiney extends StatelessWidget {
  const PositionedLiney({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
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
    );
  }
}
