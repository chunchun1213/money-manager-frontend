/// Material 3 主題設定
///
/// 整合設計 tokens 建立統一的應用程式主題
library;

import 'package:flutter/material.dart';

import 'package:money_manager/core/theme/design_tokens.dart';

class AppTheme {
  AppTheme._();

  /// 應用程式主題
  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        surface: AppColors.surface,
        onPrimary: AppColors.textPrimary,
        onSurface: AppColors.textPrimary,
      ),
      scaffoldBackgroundColor: AppColors.background,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primary,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.textPrimary),
        titleTextStyle: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.surface,
          foregroundColor: AppColors.textSecondary,
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.xs,
            horizontal: AppSpacing.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.button),
          ),
          textStyle: AppTextStyles.button,
          minimumSize: const Size(
            AppSizes.socialButtonWidth,
            AppSizes.socialButtonHeight,
          ),
        ),
      ),
      textTheme: TextTheme(
        headlineMedium: AppTextStyles.heading.copyWith(
          color: AppColors.textPrimary,
        ),
        headlineLarge: AppTextStyles.headingEmphasis.copyWith(
          color: AppColors.primary,
        ),
        labelLarge: AppTextStyles.button.copyWith(
          color: AppColors.textSecondary,
        ),
        bodyLarge: AppTextStyles.body.copyWith(
          color: AppColors.textTertiary,
        ),
      ),
    );
  }
}
