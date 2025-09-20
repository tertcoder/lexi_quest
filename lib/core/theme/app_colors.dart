import 'package:flutter/material.dart';

/// LexiQuest App Color Palette
/// Defines all colors used throughout the application
class AppColors {
  // Primary Colors
  static const Color primaryIndigo600 = Color(0xFF4F46E5);
  static const Color primaryIndigo500 = Color(0xFF6366F1);
  static const Color primaryIndigoDark = Color(0xFF4646BB);

  // Secondary Colors
  static const Color secondaryGreen500 = Color(0xFF22C55E);
  static const Color secondaryAmber500 = Color(0xFFF59E0B);
  static const Color secondaryRed500 = Color(0xFFEF4444);

  // Neutral Colors
  static const Color neutralSlate900 = Color(0xFF0F172A);
  static const Color neutralSlate600 = Color(0xFF475569);
  static const Color neutralSlate50 = Color(0xFFF8FAFC);
  static const Color neutralWhite = Color(0xFFFFFFFF);

  // Neutral Colors with Opacity
  static const Color neutralSlate600_70 = Color(0xB3475569); // 70% opacity
  static const Color neutralSlate600_30 = Color(0x4D475569); // 30% opacity
  static const Color neutralSlate900_25 = Color(0x400F172A); // 25% opacity
  static const Color neutralSlate50_70 = Color(0xB3F8FAFC); // 70% opacity
  static const Color neutralSlate50_10 = Color(0x1AF8FAFC); // 10% opacity

  // Semantic Colors (mapped to primary/secondary for consistency)
  static const Color success = secondaryGreen500;
  static const Color warning = secondaryAmber500;
  static const Color error = secondaryRed500;
  static const Color primary = primaryIndigo600;
  static const Color primaryVariant = primaryIndigo500;

  // Background Colors
  static const Color background = neutralWhite;
  static const Color surface = neutralSlate50;
  static const Color surfaceVariant = neutralSlate50_10;

  // Text Colors
  static const Color onPrimary = neutralWhite;
  static const Color onBackground = neutralSlate900;
  static const Color onSurface = neutralSlate900;
  static const Color onSurfaceVariant = neutralSlate600;
}
