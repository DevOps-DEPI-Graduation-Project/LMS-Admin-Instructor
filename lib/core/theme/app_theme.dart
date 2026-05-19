// import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTheme {
  static const _primary = Color(0xFF0A5C75);
  static const _onPrimary = Color(0xFFFFFFFF);
  static const _secondary = Color(0xFFA8DF8E);
  static const _onSecondary = Color(0xFF0A3D2E);
  static const _backgroundLight = Color(0xFFF3F7F8);
  // static const _backgroundDark = Color(0xFF0E1416);
  static const _textPrimaryLight = Color(0xFF102A33);
  static const _textPrimaryDark = Color(0xFFF3F7F8);
  static const _textSecondaryLight = Color(0xFF37474F);
  static const _textSecondaryDark = Color(0xFFB0BEC5);
  static const _textTertiary = Color(0xFF607D8B);
  static const _outline = Color(0xFFD1DDE1);
  static const _error = Color(0xFFD32F2F);

  static double getResponsiveSize(
    double webSize,
    double mobileSize, [
    double? tabletSize,
  ]) {
    final width = ScreenUtil().screenWidth;
    if (width >= 1100) return webSize.sp;
    if (width >= 600) {
      return (tabletSize ?? ((webSize + mobileSize) / 2)).sp;
    }
    return mobileSize.sp;
  }

  static TextTheme _buildTextTheme(ColorScheme colorScheme) {
    const base = TextStyle(fontFamily: 'Inter');
    return TextTheme(
      displayLarge: base.copyWith(
        fontSize: getResponsiveSize(36, 30, 32),
        fontWeight: FontWeight.bold,
        color: colorScheme.onSurface,
      ),
      displayMedium: base.copyWith(
        fontSize: getResponsiveSize(30, 24, 28),
        fontWeight: FontWeight.bold,
        color: colorScheme.onSurface,
      ),
      displaySmall: base.copyWith(
        fontSize: getResponsiveSize(26, 20, 24),
        fontWeight: FontWeight.w600,
        color: colorScheme.onSurface,
      ),
      headlineLarge: base.copyWith(
        fontSize: getResponsiveSize(24, 18, 22),
        fontWeight: FontWeight.bold,
        color: colorScheme.onSurface,
      ),
      headlineMedium: base.copyWith(
        fontSize: getResponsiveSize(20, 16, 18),
        fontWeight: FontWeight.w600,
        color: colorScheme.onSurface,
      ),
      headlineSmall: base.copyWith(
        fontSize: getResponsiveSize(18, 14, 16),
        fontWeight: FontWeight.w600,
        color: colorScheme.onSurface,
      ),
      titleLarge: base.copyWith(
        fontSize: getResponsiveSize(20, 16, 18),
        fontWeight: FontWeight.bold,
        color: colorScheme.onSurface,
      ),
      titleMedium: base.copyWith(
        fontSize: getResponsiveSize(18, 14, 16),
        fontWeight: FontWeight.w600,
        color: colorScheme.onSurface,
      ),
      titleSmall: base.copyWith(
        fontSize: getResponsiveSize(16, 12, 14),
        fontWeight: FontWeight.bold,
        color: colorScheme.onSurface,
      ),
      bodyLarge: base.copyWith(
        fontSize: getResponsiveSize(18, 14, 16),
        fontWeight: FontWeight.normal,
        color: colorScheme.onSurface,
      ),
      bodyMedium: base.copyWith(
        fontSize: getResponsiveSize(16, 12, 14),
        fontWeight: FontWeight.normal,
        color: colorScheme.onSurfaceVariant,
      ),
      bodySmall: base.copyWith(
        fontSize: getResponsiveSize(14, 11, 12),
        fontWeight: FontWeight.normal,
        color: _textTertiary,
      ),
      labelLarge: base.copyWith(
        fontSize: getResponsiveSize(16, 12, 14),
        fontWeight: FontWeight.w500,
        color: colorScheme.onPrimary,
      ),
      labelMedium: base.copyWith(
        fontSize: getResponsiveSize(14, 11, 12),
        fontWeight: FontWeight.w500,
        color: colorScheme.onSurfaceVariant,
      ),
      labelSmall: base.copyWith(
        fontSize: getResponsiveSize(12, 10, 11),
        fontWeight: FontWeight.w500,
        color: colorScheme.primary,
      ),
    );
  }

  static ThemeData get lightTheme {
    const colorScheme = ColorScheme.light(
      primary: _primary,
      onPrimary: _onPrimary,
      primaryContainer: _primary,
      onPrimaryContainer: _onPrimary,
      secondary: _secondary,
      onSecondary: _onSecondary,
      onSurface: _textPrimaryLight,
      surface: Colors.white,
      surfaceContainerHighest: _backgroundLight,
      onSurfaceVariant: _textSecondaryLight,
      error: _error,
      outline: _outline,
    );

    return _buildTheme(colorScheme, Brightness.light);
  }

  static ThemeData get darkTheme {
    const colorScheme = ColorScheme.dark(
      primary: Color(0xFF14B8A6),
      onPrimary: Colors.white,
      primaryContainer: Color(0xFF0F3E4B),
      onPrimaryContainer: Color(0xFFE2F1F3),
      secondary: Color(0xFF34D399),
      onSecondary: Color(0xFF022C22),
      secondaryContainer: Color(0xFF1E3D31),
      onSecondaryContainer: Color(0xFFD1FAE5),
      onSurface: _textPrimaryDark,
      surface: Color(0xFF0E1315),
      surfaceContainerHighest: Color(0xFF182023),
      onSurfaceVariant: _textSecondaryDark,
      error: Color(0xFFF87171),
      outline: Color(0xFF233035),
    );

    return _buildTheme(colorScheme, Brightness.dark);
  }

  static ThemeData _buildTheme(ColorScheme colorScheme, Brightness brightness) {
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      textTheme: _buildTextTheme(colorScheme),
      scaffoldBackgroundColor: colorScheme.surface,
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surface,
        hintStyle: const TextStyle(color: _textTertiary),
        labelStyle: TextStyle(color: colorScheme.onSurfaceVariant),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colorScheme.error),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          disabledBackgroundColor: const Color(0xFFB0BEC5),
          disabledForegroundColor: const Color(0xFF78909C),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: TextStyle(
            fontSize: getResponsiveSize(16, 14),
            fontWeight: FontWeight.w500,
            fontFamily: 'Inter',
          ),
        ),
      ),
      // outlined theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.primary,
          side: BorderSide(color: colorScheme.primary),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          textStyle: TextStyle(
            fontSize: getResponsiveSize(16, 14),
            fontWeight: FontWeight.w500,
            fontFamily: 'Inter',
          ),
        ),
      ),

      extensions: [
        CustomColors(
          primaryHover: brightness == Brightness.dark
              ? const Color(0xFF0D9488)
              : const Color(0xFF084C61),
          secondaryHover: brightness == Brightness.dark
              ? const Color(0xFF059669)
              : const Color(0xFF8FCC72),
          textTertiary: _textTertiary,
          divider: colorScheme.outline,
        ),
      ],
    );
  }
}

@immutable
class CustomColors extends ThemeExtension<CustomColors> {
  final Color? primaryHover;
  final Color? secondaryHover;
  final Color? textTertiary;
  final Color? divider;

  const CustomColors({
    this.primaryHover,
    this.secondaryHover,
    this.textTertiary,
    this.divider,
  });

  @override
  CustomColors copyWith({
    Color? primaryHover,
    Color? secondaryHover,
    Color? textTertiary,
    Color? divider,
  }) {
    return CustomColors(
      primaryHover: primaryHover ?? this.primaryHover,
      secondaryHover: secondaryHover ?? this.secondaryHover,
      textTertiary: textTertiary ?? this.textTertiary,
      divider: divider ?? this.divider,
    );
  }

  @override
  CustomColors lerp(ThemeExtension<CustomColors>? other, double t) {
    if (other is! CustomColors) return this;
    return CustomColors(
      primaryHover: Color.lerp(primaryHover, other.primaryHover, t),
      secondaryHover: Color.lerp(secondaryHover, other.secondaryHover, t),
      textTertiary: Color.lerp(textTertiary, other.textTertiary, t),
      divider: Color.lerp(divider, other.divider, t),
    );
  }
}
