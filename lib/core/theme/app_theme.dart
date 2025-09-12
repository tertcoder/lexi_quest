import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';
import 'app_fonts.dart';

/// LexiQuest App Theme Configuration
/// Provides light and dark theme configurations
class AppTheme {
  /// Light Theme Configuration
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: AppFonts.primaryFontFamily,

      // Color Scheme
      colorScheme: const ColorScheme.light(
        brightness: Brightness.light,
        primary: AppColors.primaryIndigo600,
        onPrimary: AppColors.onPrimary,
        primaryContainer: AppColors.primaryIndigo500,
        onPrimaryContainer: AppColors.onPrimary,
        secondary: AppColors.secondaryGreen500,
        onSecondary: AppColors.neutralWhite,
        secondaryContainer: AppColors.secondaryGreen500,
        onSecondaryContainer: AppColors.neutralWhite,
        tertiary: AppColors.secondaryAmber500,
        onTertiary: AppColors.neutralWhite,
        error: AppColors.error,
        onError: AppColors.neutralWhite,
        errorContainer: AppColors.secondaryRed500,
        onErrorContainer: AppColors.neutralWhite,
        surface: AppColors.surface,
        onSurface: AppColors.onSurface,
        surfaceContainerHighest: AppColors.surfaceVariant,
        onSurfaceVariant: AppColors.onSurfaceVariant,
        outline: AppColors.neutralSlate600_30,
        outlineVariant: AppColors.neutralSlate600_30,
        shadow: AppColors.neutralSlate900_25,
        scrim: AppColors.neutralSlate900_25,
        inverseSurface: AppColors.neutralSlate900,
        onInverseSurface: AppColors.neutralWhite,
        inversePrimary: AppColors.primaryIndigo500,
      ),

      // Text Theme
      textTheme: TextTheme(
        displayLarge: AppFonts.displayLarge.copyWith(
          color: AppColors.onBackground,
        ),
        displayMedium: AppFonts.displayMedium.copyWith(
          color: AppColors.onBackground,
        ),
        displaySmall: AppFonts.displaySmall.copyWith(
          color: AppColors.onBackground,
        ),
        headlineLarge: AppFonts.headlineLarge.copyWith(
          color: AppColors.onBackground,
        ),
        headlineMedium: AppFonts.headlineMedium.copyWith(
          color: AppColors.onBackground,
        ),
        headlineSmall: AppFonts.headlineSmall.copyWith(
          color: AppColors.onBackground,
        ),
        titleLarge: AppFonts.titleLarge.copyWith(color: AppColors.onBackground),
        titleMedium: AppFonts.titleMedium.copyWith(
          color: AppColors.onBackground,
        ),
        titleSmall: AppFonts.titleSmall.copyWith(color: AppColors.onBackground),
        labelLarge: AppFonts.labelLarge.copyWith(
          color: AppColors.onSurfaceVariant,
        ),
        labelMedium: AppFonts.labelMedium.copyWith(
          color: AppColors.onSurfaceVariant,
        ),
        labelSmall: AppFonts.labelSmall.copyWith(
          color: AppColors.onSurfaceVariant,
        ),
        bodyLarge: AppFonts.bodyLarge.copyWith(color: AppColors.onBackground),
        bodyMedium: AppFonts.bodyMedium.copyWith(color: AppColors.onBackground),
        bodySmall: AppFonts.bodySmall.copyWith(
          color: AppColors.onSurfaceVariant,
        ),
      ),

      // App Bar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.primaryIndigo600,
        foregroundColor: AppColors.onPrimary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: AppFonts.titleLarge.copyWith(
          color: AppColors.onPrimary,
        ),
        iconTheme: const IconThemeData(color: AppColors.onPrimary),
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryIndigo600,
          foregroundColor: AppColors.onPrimary,
          textStyle: AppFonts.buttonText,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 2,
        ),
      ),

      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primaryIndigo600,
          textStyle: AppFonts.buttonText,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          side: const BorderSide(color: AppColors.primaryIndigo600, width: 1),
        ),
      ),

      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primaryIndigo600,
          textStyle: AppFonts.buttonText,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.neutralSlate600_30),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.neutralSlate600_30),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: AppColors.primaryIndigo600,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        labelStyle: AppFonts.bodyMedium.copyWith(
          color: AppColors.onSurfaceVariant,
        ),
        hintStyle: AppFonts.bodyMedium.copyWith(
          color: AppColors.neutralSlate600_70,
        ),
        errorStyle: AppFonts.bodySmall.copyWith(color: AppColors.error),
      ),

      // Card Theme
      cardTheme: CardTheme(
        color: AppColors.surface,
        shadowColor: AppColors.neutralSlate900_25,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(8),
      ),

      // Floating Action Button Theme
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primaryIndigo600,
        foregroundColor: AppColors.onPrimary,
        elevation: 4,
      ),

      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.primaryIndigo600,
        unselectedItemColor: AppColors.neutralSlate600,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),

      // Progress Indicator Theme
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primaryIndigo600,
        linearTrackColor: AppColors.neutralSlate600_30,
        circularTrackColor: AppColors.neutralSlate600_30,
      ),

      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surface,
        selectedColor: AppColors.primaryIndigo600,
        secondarySelectedColor: AppColors.primaryIndigo500,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        labelStyle: AppFonts.labelMedium,
        secondaryLabelStyle: AppFonts.labelMedium.copyWith(
          color: AppColors.onPrimary,
        ),
        brightness: Brightness.light,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }

  /// Dark Theme Configuration
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: AppFonts.primaryFontFamily,

      // Color Scheme for Dark Theme
      colorScheme: const ColorScheme.dark(
        brightness: Brightness.dark,
        primary: AppColors.primaryIndigo500,
        onPrimary: AppColors.neutralWhite,
        primaryContainer: AppColors.primaryIndigoDark,
        onPrimaryContainer: AppColors.neutralWhite,
        secondary: AppColors.secondaryGreen500,
        onSecondary: AppColors.neutralWhite,
        secondaryContainer: AppColors.secondaryGreen500,
        onSecondaryContainer: AppColors.neutralWhite,
        tertiary: AppColors.secondaryAmber500,
        onTertiary: AppColors.neutralSlate900,
        error: AppColors.error,
        onError: AppColors.neutralWhite,
        errorContainer: AppColors.secondaryRed500,
        onErrorContainer: AppColors.neutralWhite,
        surface: AppColors.neutralSlate900,
        onSurface: AppColors.neutralWhite,
        surfaceContainerHighest: AppColors.neutralSlate600,
        onSurfaceVariant: AppColors.neutralSlate50,
        outline: AppColors.neutralSlate600_70,
        outlineVariant: AppColors.neutralSlate600_30,
        shadow: AppColors.neutralSlate900,
        scrim: AppColors.neutralSlate900,
        inverseSurface: AppColors.neutralSlate50,
        onInverseSurface: AppColors.neutralSlate900,
        inversePrimary: AppColors.primaryIndigo600,
      ),

      // Text Theme for Dark Mode
      textTheme: TextTheme(
        displayLarge: AppFonts.displayLarge.copyWith(
          color: AppColors.neutralWhite,
        ),
        displayMedium: AppFonts.displayMedium.copyWith(
          color: AppColors.neutralWhite,
        ),
        displaySmall: AppFonts.displaySmall.copyWith(
          color: AppColors.neutralWhite,
        ),
        headlineLarge: AppFonts.headlineLarge.copyWith(
          color: AppColors.neutralWhite,
        ),
        headlineMedium: AppFonts.headlineMedium.copyWith(
          color: AppColors.neutralWhite,
        ),
        headlineSmall: AppFonts.headlineSmall.copyWith(
          color: AppColors.neutralWhite,
        ),
        titleLarge: AppFonts.titleLarge.copyWith(color: AppColors.neutralWhite),
        titleMedium: AppFonts.titleMedium.copyWith(
          color: AppColors.neutralWhite,
        ),
        titleSmall: AppFonts.titleSmall.copyWith(color: AppColors.neutralWhite),
        labelLarge: AppFonts.labelLarge.copyWith(
          color: AppColors.neutralSlate50,
        ),
        labelMedium: AppFonts.labelMedium.copyWith(
          color: AppColors.neutralSlate50,
        ),
        labelSmall: AppFonts.labelSmall.copyWith(
          color: AppColors.neutralSlate50,
        ),
        bodyLarge: AppFonts.bodyLarge.copyWith(color: AppColors.neutralWhite),
        bodyMedium: AppFonts.bodyMedium.copyWith(color: AppColors.neutralWhite),
        bodySmall: AppFonts.bodySmall.copyWith(color: AppColors.neutralSlate50),
      ),

      // App Bar Theme for Dark Mode
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.neutralSlate900,
        foregroundColor: AppColors.neutralWhite,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: AppFonts.titleLarge.copyWith(
          color: AppColors.neutralWhite,
        ),
        iconTheme: const IconThemeData(color: AppColors.neutralWhite),
      ),
    );
  }
}
