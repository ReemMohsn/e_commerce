import 'package:e_commeric/core/themes/app_color.dart';
import 'package:flutter/material.dart';

abstract final class AppTheme {
  static const String fontFamily = 'Poppins';
  static const double fieldRadius = 12;
  static const double buttonRadius = 12;

  static ThemeData get lightTheme {
    const colorScheme = ColorScheme.light(
      primary: AppColor.primary,
      secondary: AppColor.secondary,
      surface: AppColor.background,
      onPrimary: AppColor.onPrimary,
      onSecondary: AppColor.textPrimary,
      onSurface: AppColor.textPrimary,
      error: AppColor.danger,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamily: fontFamily,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColor.background,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColor.background,
        foregroundColor: AppColor.textPrimary,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: AppColor.background,
        elevation: 2,
        shadowColor: AppColor.cardShadow,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: AppColor.inputBorder),
        ),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 28,
          height: 1.25,
          fontWeight: FontWeight.w700,
          color: AppColor.textPrimary,
        ),
        headlineMedium: TextStyle(
          fontSize: 24,
          height: 1.3,
          fontWeight: FontWeight.w600,
          color: AppColor.textPrimary,
        ),
        headlineSmall: TextStyle(
          fontSize: 20,
          height: 1.3,
          fontWeight: FontWeight.w600,
          color: AppColor.textPrimary,
        ),
        titleLarge: TextStyle(
          fontSize: 24,
          height: 1.4,
          fontWeight: FontWeight.w600,
          color: AppColor.textPrimary,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          height: 1.4,
          fontWeight: FontWeight.w600,
          color: AppColor.textSecondary,
        ),
        titleSmall: TextStyle(
          fontSize: 16,
          height: 1.35,
          fontWeight: FontWeight.w500,
          color: AppColor.textPrimary,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          height: 1.45,
          fontWeight: FontWeight.w400,
          color: AppColor.textSecondary,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          height: 1.35,
          fontWeight: FontWeight.w400,
          color: AppColor.textSecondary,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          height: 1.35,
          fontWeight: FontWeight.w400,
          color: AppColor.textSecondary,
        ),
        labelLarge: TextStyle(
          fontSize: 18,
          height: 1.3,
          fontWeight: FontWeight.w400,
          color: AppColor.onPrimary,
        ),
        labelMedium: TextStyle(
          fontSize: 13,
          height: 1.3,
          fontWeight: FontWeight.w500,
          color: AppColor.textPrimary,
        ),
        labelSmall: TextStyle(
          fontSize: 14,
          height: 1.35,
          fontWeight: FontWeight.w400,
          color: AppColor.textSecondary,
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColor.divider,
        thickness: 1,
        space: 1,
      ),
      switchTheme: SwitchThemeData(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        trackColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? AppColor.primary
              : AppColor.controlInactive,
        ),
        thumbColor: const WidgetStatePropertyAll(AppColor.onPrimary),
        trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColor.inputField,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 15,
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        floatingLabelAlignment: FloatingLabelAlignment.start,
        labelStyle: const TextStyle(
          fontFamily: fontFamily,
          fontSize: 12,
          height: 1.2,
          fontWeight: FontWeight.w500,
          color: AppColor.textPrimary,
        ),
        floatingLabelStyle: const TextStyle(
          fontFamily: fontFamily,
          fontSize: 12,
          height: 1.2,
          fontWeight: FontWeight.w500,
          color: AppColor.textPrimary,
        ),
        hintStyle: const TextStyle(
          fontFamily: fontFamily,
          fontSize: 13,
          fontWeight: FontWeight.w400,
          color: AppColor.hint,
        ),
        prefixIconColor: AppColor.textPrimary,
        suffixIconColor: AppColor.textPrimary,
        border: _inputBorder(AppColor.inputBorder),
        enabledBorder: _inputBorder(AppColor.inputBorder),
        focusedBorder: _inputBorder(AppColor.primary),
        errorBorder: _inputBorder(AppColor.danger),
        focusedErrorBorder: _inputBorder(AppColor.danger),
        errorStyle: const TextStyle(
          fontFamily: fontFamily,
          fontSize: 11,
          color: AppColor.danger,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(49),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          foregroundColor: AppColor.onPrimary,
          backgroundColor: AppColor.primary,
          disabledForegroundColor: AppColor.onPrimary,
          disabledBackgroundColor: AppColor.secondary,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(buttonRadius),
          ),
          textStyle: const TextStyle(
            fontFamily: fontFamily,
            fontSize: 18,
            height: 1.3,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColor.primary,
          textStyle: const TextStyle(
            fontFamily: fontFamily,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: 68,
        backgroundColor: AppColor.background,
        indicatorColor: Colors.transparent,
        elevation: 4,
        shadowColor: AppColor.cardShadow,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final isSelected = states.contains(WidgetState.selected);
          return IconThemeData(
            color: isSelected ? AppColor.primary : AppColor.textSecondary,
            size: 25,
          );
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final isSelected = states.contains(WidgetState.selected);
          return TextStyle(
            fontFamily: fontFamily,
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            color: isSelected ? AppColor.primary : AppColor.textSecondary,
          );
        }),
      ),
      checkboxTheme: CheckboxThemeData(
        visualDensity: VisualDensity.compact,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        side: const BorderSide(color: AppColor.inputBorder),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
        fillColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? AppColor.primary
              : Colors.transparent,
        ),
        checkColor: const WidgetStatePropertyAll(AppColor.onPrimary),
      ),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        contentTextStyle: TextStyle(
          fontFamily: fontFamily,
          color: AppColor.onPrimary,
        ),
      ),
    );
  }

  static OutlineInputBorder _inputBorder(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(fieldRadius),
      borderSide: BorderSide(color: color, width: 1.6),
    );
  }
}
