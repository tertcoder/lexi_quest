import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// LexiQuest App Font Configuration
/// Uses Mulish as the primary font family
class AppFonts {
  // Font Family
  static const String primaryFontFamily = 'Mulish';

  // Text Styles using Mulish from Google Fonts

  // Display Styles
  static TextStyle get displayLarge => GoogleFonts.mulish(
    fontSize: 57,
    fontWeight: FontWeight.w400,
    height: 1.12,
  );

  static TextStyle get displayMedium => GoogleFonts.mulish(
    fontSize: 45,
    fontWeight: FontWeight.w400,
    height: 1.16,
  );

  static TextStyle get displaySmall => GoogleFonts.mulish(
    fontSize: 36,
    fontWeight: FontWeight.w400,
    height: 1.22,
  );

  // Headline Styles
  static TextStyle get headlineLarge => GoogleFonts.mulish(
    fontSize: 32,
    fontWeight: FontWeight.w600,
    height: 1.25,
  );

  static TextStyle get headlineMedium => GoogleFonts.mulish(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    height: 1.29,
  );

  static TextStyle get headlineSmall => GoogleFonts.mulish(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 1.33,
  );

  // Title Styles
  static TextStyle get titleLarge => GoogleFonts.mulish(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    height: 1.27,
  );

  static TextStyle get titleMedium => GoogleFonts.mulish(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.50,
  );

  static TextStyle get titleSmall => GoogleFonts.mulish(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.43,
  );

  // Label Styles
  static TextStyle get labelLarge => GoogleFonts.mulish(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    height: 1.43,
  );

  static TextStyle get labelMedium => GoogleFonts.mulish(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 1.33,
  );

  static TextStyle get labelSmall => GoogleFonts.mulish(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    height: 1.45,
  );

  // Body Styles
  static TextStyle get bodyLarge => GoogleFonts.mulish(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.50,
  );

  static TextStyle get bodyMedium => GoogleFonts.mulish(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.43,
  );

  static TextStyle get bodySmall => GoogleFonts.mulish(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.33,
  );

  // Custom App-Specific Styles
  static TextStyle get buttonText => GoogleFonts.mulish(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    height: 1.50,
  );

  static TextStyle get caption => GoogleFonts.mulish(
    fontSize: 10,
    fontWeight: FontWeight.w400,
    height: 1.40,
  );

  static TextStyle get overline => GoogleFonts.mulish(
    fontSize: 10,
    fontWeight: FontWeight.w600,
    height: 1.40,
    letterSpacing: 1.5,
  );
}
