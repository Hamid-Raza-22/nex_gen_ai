import 'package:flutter/material.dart';

import 'app_colors.dart';

abstract final class AppTheme {
  static const _radius = 16.0;
  static const displayFont = 'ShareTechMono';

  static ThemeData get dark {
    const scheme = ColorScheme.dark(
      primary: AppColors.primary,
      onPrimary: Colors.white,
      secondary: AppColors.neonCyan,
      onSecondary: AppColors.darkest,
      tertiary: AppColors.neonPurple,
      surface: AppColors.darkest,
      onSurface: AppColors.lightest,
      surfaceContainer: AppColors.dark,
      surfaceContainerHighest: AppColors.mid,
      outline: AppColors.mid,
      error: AppColors.error,
    );

    final base = ThemeData(useMaterial3: true, colorScheme: scheme);
    final radius = BorderRadius.circular(_radius);

    return base.copyWith(
      scaffoldBackgroundColor: AppColors.darkest,
      textTheme: base.textTheme
          .apply(
            bodyColor: AppColors.lightest,
            displayColor: AppColors.lightest,
          )
          .copyWith(
            displayLarge: base.textTheme.displayLarge
                ?.copyWith(fontFamily: displayFont),
            displayMedium: base.textTheme.displayMedium
                ?.copyWith(fontFamily: displayFont),
            displaySmall: base.textTheme.displaySmall
                ?.copyWith(fontFamily: displayFont),
            headlineLarge: base.textTheme.headlineLarge
                ?.copyWith(fontFamily: displayFont),
            headlineMedium: base.textTheme.headlineMedium
                ?.copyWith(fontFamily: displayFont),
            headlineSmall: base.textTheme.headlineSmall
                ?.copyWith(fontFamily: displayFont),
            titleLarge:
                base.textTheme.titleLarge?.copyWith(fontFamily: displayFont),
          ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.darkest,
        foregroundColor: AppColors.lightest,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: displayFont,
          fontSize: 20,
          color: AppColors.lightest,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.dark,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: radius),
        margin: EdgeInsets.zero,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.dark,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: radius,
          borderSide: const BorderSide(color: AppColors.mid),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: radius,
          borderSide: const BorderSide(color: AppColors.mid),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: radius,
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: radius,
          borderSide: const BorderSide(color: AppColors.error),
        ),
        hintStyle: const TextStyle(color: AppColors.light),
        labelStyle: const TextStyle(color: AppColors.light),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(borderRadius: radius),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.lightest,
          side: const BorderSide(color: AppColors.mid),
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(borderRadius: radius),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: AppColors.neonCyan),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.dark,
        indicatorColor: AppColors.primary.withValues(alpha: 0.2),
        iconTheme: WidgetStateProperty.resolveWith(
          (states) => IconThemeData(
            color: states.contains(WidgetState.selected)
                ? AppColors.primary
                : AppColors.light,
          ),
        ),
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => TextStyle(
            fontSize: 12,
            color: states.contains(WidgetState.selected)
                ? AppColors.primary
                : AppColors.light,
          ),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.dark,
        contentTextStyle: const TextStyle(color: AppColors.lightest),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: radius),
      ),
      dividerTheme: const DividerThemeData(color: AppColors.mid, thickness: 1),
      progressIndicatorTheme:
          const ProgressIndicatorThemeData(color: AppColors.primary),
    );
  }
}
