import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTheme {
  const AppTheme._();

  static const double radiusSmall = 14;
  static const double radiusMedium = 20;
  static const double radiusLarge = 28;

  static ThemeData get light {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.light,
      surface: AppColors.surface,
    ).copyWith(
      primary: AppColors.primary,
      onPrimary: AppColors.textOnPrimary,
      primaryContainer: AppColors.primarySoft,
      onPrimaryContainer: AppColors.primaryDeep,
      surface: AppColors.surface,
      onSurface: AppColors.textPrimary,
      surfaceContainerLowest: AppColors.background,
      surfaceContainerLow: AppColors.surfaceTint,
      surfaceContainer: AppColors.surfaceSoft,
      surfaceContainerHigh: AppColors.surfaceMuted,
      outline: AppColors.borderStrong,
      outlineVariant: AppColors.borderSoft,
      error: AppColors.error,
      onError: Colors.white,
    );

    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.background,
    );

    return base.copyWith(
      splashFactory: InkSparkle.splashFactory,

      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        foregroundColor: AppColors.textPrimary,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: base.textTheme.titleLarge?.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
        ),
      ),

      textTheme: base.textTheme.copyWith(
        displayLarge: base.textTheme.displayLarge?.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w700,
          letterSpacing: -2.0,
          height: 1.05,
        ),
        displayMedium: base.textTheme.displayMedium?.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w700,
          letterSpacing: -1.8,
          height: 1.05,
        ),
        displaySmall: base.textTheme.displaySmall?.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w700,
          letterSpacing: -1.4,
          height: 1.08,
        ),
        headlineLarge: base.textTheme.headlineLarge?.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w700,
          letterSpacing: -1.0,
          height: 1.1,
        ),
        headlineMedium: base.textTheme.headlineMedium?.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.8,
          height: 1.12,
        ),
        headlineSmall: base.textTheme.headlineSmall?.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.6,
          height: 1.15,
        ),
        titleLarge: base.textTheme.titleLarge?.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.4,
        ),
        titleMedium: base.textTheme.titleMedium?.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.2,
        ),
        titleSmall: base.textTheme.titleSmall?.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: base.textTheme.bodyLarge?.copyWith(
          color: AppColors.textPrimary,
          height: 1.5,
        ),
        bodyMedium: base.textTheme.bodyMedium?.copyWith(
          color: AppColors.textPrimary,
          height: 1.45,
        ),
        bodySmall: base.textTheme.bodySmall?.copyWith(
          color: AppColors.textSecondary,
          height: 1.4,
        ),
        labelLarge: base.textTheme.labelLarge?.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w600,
        ),
        labelMedium: base.textTheme.labelMedium?.copyWith(
          color: AppColors.textSecondary,
          fontWeight: FontWeight.w600,
        ),
      ),

      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            radiusMedium,
          ),
          side: const BorderSide(
            color: AppColors.borderSoft,
          ),
        ),
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textOnPrimary,
          minimumSize: const Size(
            48,
            56,
          ),
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: 22,
            vertical: 16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              18,
            ),
          ),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textPrimary,
          minimumSize: const Size(
            48,
            56,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 22,
            vertical: 16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              18,
            ),
          ),
          side: const BorderSide(
            color: AppColors.borderStrong,
          ),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceSoft,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 18,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            18,
          ),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            18,
          ),
          borderSide: const BorderSide(
            color: AppColors.borderSoft,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            18,
          ),
          borderSide: const BorderSide(
            color: AppColors.primary,
            width: 1.4,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            18,
          ),
          borderSide: const BorderSide(
            color: AppColors.error,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            18,
          ),
          borderSide: const BorderSide(
            color: AppColors.error,
            width: 1.4,
          ),
        ),
        hintStyle: const TextStyle(
          color: AppColors.textTertiary,
        ),
      ),

      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        modalBackgroundColor: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(
              28,
            ),
          ),
        ),
      ),

      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            radiusLarge,
          ),
          side: const BorderSide(
            color: AppColors.borderSoft,
          ),
        ),
      ),

      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: 1,
        space: 1,
      ),

      listTileTheme: ListTileThemeData(
        iconColor: AppColors.textSecondary,
        textColor: AppColors.textPrimary,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 6,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            radiusMedium,
          ),
        ),
      ),

      navigationBarTheme: NavigationBarThemeData(
        height: 72,
        elevation: 0,
        backgroundColor: AppColors.surface.withValues(
          alpha: 0.97,
        ),
        surfaceTintColor: Colors.transparent,
        indicatorColor: AppColors.primarySoft,
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) {
            final selected = states.contains(
              WidgetState.selected,
            );

            return TextStyle(
              fontSize: 12,
              fontWeight: selected
                  ? FontWeight.w700
                  : FontWeight.w500,
              color: selected
                  ? AppColors.primary
                  : AppColors.textSecondary,
            );
          },
        ),
        iconTheme: WidgetStateProperty.resolveWith(
          (states) {
            final selected = states.contains(
              WidgetState.selected,
            );

            return IconThemeData(
              size: 23,
              color: selected
                  ? AppColors.primary
                  : AppColors.textSecondary,
            );
          },
        ),
      ),

      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        elevation: 0,
        backgroundColor: AppColors.primaryDeep,
        contentTextStyle: const TextStyle(
          color: Colors.white,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            16,
          ),
        ),
      ),

      progressIndicatorTheme:
          const ProgressIndicatorThemeData(
        color: AppColors.primary,
        linearTrackColor: AppColors.primarySoft,
      ),

      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: AppColors.textPrimary,
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              14,
            ),
          ),
        ),
      ),

      switchTheme: SwitchThemeData(
        thumbColor:
            WidgetStateProperty.resolveWith(
          (states) {
            if (states.contains(
              WidgetState.selected,
            )) {
              return Colors.white;
            }

            return AppColors.textTertiary;
          },
        ),
        trackColor:
            WidgetStateProperty.resolveWith(
          (states) {
            if (states.contains(
              WidgetState.selected,
            )) {
              return AppColors.primary;
            }

            return AppColors.surfaceMuted;
          },
        ),
      ),

      sliderTheme: base.sliderTheme.copyWith(
        activeTrackColor: AppColors.primary,
        inactiveTrackColor: AppColors.primarySoft,
        thumbColor: AppColors.primary,
        overlayColor: AppColors.primary.withValues(
          alpha: 0.10,
        ),
      ),

      chipTheme: base.chipTheme.copyWith(
        backgroundColor: AppColors.surfaceSoft,
        selectedColor: AppColors.primarySoft,
        side: const BorderSide(
          color: AppColors.borderSoft,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            14,
          ),
        ),
        labelStyle: const TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),

      pageTransitionsTheme: PageTransitionsTheme(
        builders: const {
          TargetPlatform.android:
              _PremiumPageTransitionBuilder(),
          TargetPlatform.iOS:
              CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }
}

class _PremiumPageTransitionBuilder
    extends PageTransitionsBuilder {
  const _PremiumPageTransitionBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final curved = CurvedAnimation(
      parent: animation,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    );

    final fade = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      curved,
    );

    final slide = Tween<Offset>(
      begin: const Offset(
        0.025,
        0.012,
      ),
      end: Offset.zero,
    ).animate(
      curved,
    );

    return FadeTransition(
      opacity: fade,
      child: SlideTransition(
        position: slide,
        child: child,
      ),
    );
  }
}