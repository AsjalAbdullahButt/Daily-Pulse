// Daily Pulse theme - Obsidian Kinetic design system
// Dark theme with Electric Lime (#c3f400) and Cyan Glow (#00eefc) accents
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Obsidian base
  static const surface = Color(0xFF131313);
  static const surfaceDim = Color(0xFF131313);
  static const surfaceBright = Color(0xFF3A3939);
  static const surfaceContainerLowest = Color(0xFF0E0E0E);
  static const surfaceContainerLow = Color(0xFF1C1B1B);
  static const surfaceContainer = Color(0xFF201F1F);
  static const surfaceContainerHigh = Color(0xFF2A2A2A);
  static const surfaceContainerHighest = Color(0xFF353534);
  static const onSurface = Color(0xFFE5E2E1);
  static const onSurfaceVariant = Color(0xFFC4C9AC);
  static const inverseSurface = Color(0xFFE5E2E1);
  static const inverseOnSurface = Color(0xFF313030);

  // Outline
  static const outline = Color(0xFF8E9379);
  static const outlineVariant = Color(0xFF444933);

  // Primary - Electric Lime
  static const primary = Color(0xFFFFFFFF);
  static const onPrimary = Color(0xFF283500);
  static const primaryContainer = Color(0xFFC3F400);
  static const onPrimaryContainer = Color(0xFF556D00);
  static const inversePrimary = Color(0xFF506600);
  static const primaryFixed = Color(0xFFC3F400);
  static const primaryFixedDim = Color(0xFFABD600);
  static const onPrimaryFixed = Color(0xFF161E00);
  static const onPrimaryFixedVariant = Color(0xFF3C4D00);

  // Secondary - Cyan Glow
  static const secondary = Color(0xFFD3FBFF);
  static const onSecondary = Color(0xFF00363A);
  static const secondaryContainer = Color(0xFF00EEFC);
  static const onSecondaryContainer = Color(0xFF00686F);
  static const secondaryFixed = Color(0xFF7DF4FF);
  static const secondaryFixedDim = Color(0xFF00DBE9);
  static const onSecondaryFixed = Color(0xFF002022);
  static const onSecondaryFixedVariant = Color(0xFF004F54);

  // Tertiary
  static const tertiary = Color(0xFFFFFFFF);
  static const onTertiary = Color(0xFF313030);
  static const tertiaryContainer = Color(0xFFE5E2E1);
  static const onTertiaryContainer = Color(0xFF656464);
  static const tertiaryFixed = Color(0xFFE5E2E1);
  static const tertiaryFixedDim = Color(0xFFC8C6C5);
  static const onTertiaryFixed = Color(0xFF1C1B1B);
  static const onTertiaryFixedVariant = Color(0xFF474746);

  // Error
  static const error = Color(0xFFFFB4AB);
  static const onError = Color(0xFF690005);
  static const errorContainer = Color(0xFF93000A);
  static const onErrorContainer = Color(0xFFFFDAD6);

  // Background
  static const background = Color(0xFF131313);
  static const onBackground = Color(0xFFE5E2E1);
  static const surfaceVariant = Color(0xFF353534);
  static const surfaceTint = Color(0xFFABD600);

  // Surface tint
  static const primaryTint = Color(0xFFABD600);
}

class AppTheme {
  static ThemeData get darkTheme {
    final textTheme = GoogleFonts.getTextTheme(
      'Montserrat',
      TextTheme(
        displayLarge: GoogleFonts.montserrat(
          fontSize: 48,
          fontWeight: FontWeight.w800,
          height: 56 / 48,
          letterSpacing: -0.02,
          color: AppColors.primary,
        ),
        displayMedium: GoogleFonts.montserrat(
          fontSize: 36,
          fontWeight: FontWeight.w800,
          height: 42 / 36,
          letterSpacing: -0.02,
          color: AppColors.primary,
        ),
        headlineLarge: GoogleFonts.montserrat(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          height: 40 / 32,
          letterSpacing: -0.01,
          color: AppColors.primary,
        ),
        headlineMedium: GoogleFonts.montserrat(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          height: 32 / 24,
          color: AppColors.primary,
        ),
        titleLarge: GoogleFonts.montserrat(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          height: 28 / 20,
          color: AppColors.primary,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w400,
          height: 28 / 18,
          color: AppColors.onSurface,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          height: 24 / 16,
          color: AppColors.onSurface,
        ),
        bodySmall: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          height: 20 / 14,
          color: AppColors.onSurfaceVariant,
        ),
        labelLarge: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          height: 20 / 14,
          letterSpacing: 0.05,
          color: AppColors.onSurfaceVariant,
        ),
        labelMedium: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          height: 16 / 12,
          letterSpacing: 0.05,
          color: AppColors.onSurfaceVariant,
        ),
        labelSmall: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          height: 16 / 11,
          letterSpacing: 0.05,
          color: AppColors.onSurfaceVariant,
        ),
      ),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        surface: AppColors.surface,
        onSurface: AppColors.onSurface,
        primary: AppColors.primary,
        onPrimary: AppColors.onPrimary,
        primaryContainer: AppColors.primaryContainer,
        onPrimaryContainer: AppColors.onPrimaryContainer,
        secondary: AppColors.secondary,
        onSecondary: AppColors.onSecondary,
        secondaryContainer: AppColors.secondaryContainer,
        onSecondaryContainer: AppColors.onSecondaryContainer,
        tertiary: AppColors.tertiary,
        onTertiary: AppColors.onTertiary,
        tertiaryContainer: AppColors.tertiaryContainer,
        onTertiaryContainer: AppColors.onTertiaryContainer,
        error: AppColors.error,
        onError: AppColors.onError,
        errorContainer: AppColors.errorContainer,
        onErrorContainer: AppColors.onErrorContainer,
        surfaceTint: AppColors.surfaceTint,
        inverseSurface: AppColors.inverseSurface,
        inversePrimary: AppColors.inversePrimary,
        surfaceContainerLowest: AppColors.surfaceContainerLowest,
        surfaceContainerLow: AppColors.surfaceContainerLow,
        surfaceContainer: AppColors.surfaceContainer,
        surfaceContainerHigh: AppColors.surfaceContainerHigh,
        surfaceContainerHighest: AppColors.surfaceContainerHighest,
        outline: AppColors.outline,
        outlineVariant: AppColors.outlineVariant,
      ),
      textTheme: textTheme,
      scaffoldBackgroundColor: AppColors.background,
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        backgroundColor: AppColors.surfaceContainerLowest.withValues(alpha: 0.1),
        foregroundColor: AppColors.primary,
        titleTextStyle: GoogleFonts.montserrat(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          height: 40 / 32,
          letterSpacing: -0.01,
          color: AppColors.primary,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: AppColors.surfaceContainerLow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceContainerHigh,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.secondaryContainer, width: 1),
        ),
        hintStyle: GoogleFonts.inter(
          color: AppColors.onSurfaceVariant.withValues(alpha: 0.4),
          fontSize: 16,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryContainer,
          foregroundColor: AppColors.onPrimaryContainer,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          textStyle: GoogleFonts.montserrat(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            height: 32 / 24,
          ),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.surfaceContainerLowest.withValues(alpha: 0.15),
        selectedItemColor: AppColors.secondaryContainer,
        unselectedItemColor: AppColors.onSurfaceVariant.withValues(alpha: 0.6),
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          height: 16 / 12,
        ),
        unselectedLabelStyle: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          height: 16 / 12,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.primaryContainer,
        foregroundColor: AppColors.onPrimaryContainer,
        shape: const CircleBorder(),
      ),
      dividerTheme: DividerThemeData(
        color: AppColors.outline.withValues(alpha: 0.3),
        thickness: 0.5,
      ),
    );
  }
}
