import 'package:flutter/material.dart';

abstract final class AppColors {
  // ---------------------------------------------------------------------------
  // Brand
  // ---------------------------------------------------------------------------

  /// Main ILM identity color.
  static const Color primary = Color(0xFF0B6B53);

  static const Color primaryDark = Color(0xFF07513F);

  static const Color primaryDeep = Color(0xFF063D30);

  static const Color primarySoft = Color(0xFFDBEEE7);

  static const Color primaryVerySoft = Color(0xFFF0F8F5);

  // ---------------------------------------------------------------------------
  // Premium light surfaces
  // ---------------------------------------------------------------------------

  /// Main app background.
  ///
  /// Slightly warm rather than pure white so cards can visibly sit above it.
  static const Color background = Color(0xFFF7F8F5);

  /// Standard elevated card / sheet surface.
  static const Color surface = Color(0xFFFFFFFF);

  /// Secondary subtle container surface.
  static const Color surfaceSoft = Color(0xFFF1F4F1);

  /// Used behind premium grouped areas.
  static const Color surfaceMuted = Color(0xFFEBEFEC);

  /// Very subtle green-tinted surface.
  static const Color surfaceTint = Color(0xFFF4FAF7);

  // ---------------------------------------------------------------------------
  // Text
  // ---------------------------------------------------------------------------

  static const Color textPrimary = Color(0xFF14201C);

  static const Color textSecondary = Color(0xFF65716C);

  static const Color textTertiary = Color(0xFF8C9691);

  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // ---------------------------------------------------------------------------
  // Borders and separators
  // ---------------------------------------------------------------------------

  static const Color divider = Color(0xFFE4E9E6);

  static const Color borderSoft = Color(0xFFE8ECEA);

  static const Color borderStrong = Color(0xFFD7DDDA);

  // ---------------------------------------------------------------------------
  // Premium accents
  // ---------------------------------------------------------------------------

  /// Warm Islamic accent. Use sparingly for important highlights.
  static const Color gold = Color(0xFFC79B4B);

  static const Color goldSoft = Color(0xFFF5EBD8);

  static const Color goldDeep = Color(0xFF8C682D);

  // ---------------------------------------------------------------------------
  // Semantic colors
  // ---------------------------------------------------------------------------

  static const Color success = Color(0xFF2D8A63);

  static const Color successSoft = Color(0xFFE3F3EB);

  static const Color warning = Color(0xFFB47A22);

  static const Color warningSoft = Color(0xFFF8EFD9);

  static const Color error = Color(0xFFB54A4A);

  static const Color errorSoft = Color(0xFFF8E4E4);

  static const Color info = Color(0xFF477C9D);

  static const Color infoSoft = Color(0xFFE5EFF5);

  // ---------------------------------------------------------------------------
  // Prayer / spiritual accents
  // ---------------------------------------------------------------------------

  /// Used for night / Tahajjud-related UI.
  static const Color night = Color(0xFF263C4A);

  static const Color nightSoft = Color(0xFFE8EEF2);

  /// Used for sunrise / Fajr-related subtle highlights.
  static const Color dawn = Color(0xFFD6A766);

  static const Color dawnSoft = Color(0xFFF7EDDD);

  // ---------------------------------------------------------------------------
  // Dark theme
  // ---------------------------------------------------------------------------

  static const Color darkBackground = Color(0xFF0B110F);

  static const Color darkSurface = Color(0xFF141C18);

  static const Color darkSurfaceSoft = Color(0xFF1B2521);

  static const Color darkSurfaceMuted = Color(0xFF202B26);

  static const Color darkTextPrimary = Color(0xFFF2F6F4);

  static const Color darkTextSecondary = Color(0xFFADB8B3);

  static const Color darkTextTertiary = Color(0xFF7F8A85);

  static const Color darkDivider = Color(0xFF28332E);

  static const Color darkBorder = Color(0xFF303D37);

  // ---------------------------------------------------------------------------
  // Shadows
  // ---------------------------------------------------------------------------

  static const Color shadowSoft = Color(0x12000000);

  static const Color shadowMedium = Color(0x1A000000);

  // ---------------------------------------------------------------------------
  // Gradients
  // ---------------------------------------------------------------------------

  static const LinearGradient premiumBackgroundGradient =
      LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFF9FBF8),
      Color(0xFFF4F7F4),
      Color(0xFFF7F8F5),
    ],
  );

  static const LinearGradient premiumGreenGradient =
      LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF0D745B),
      Color(0xFF085A47),
    ],
  );

  static const LinearGradient premiumGoldGradient =
      LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFD8B36A),
      Color(0xFFB88432),
    ],
  );
}