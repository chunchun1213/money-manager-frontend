/// 設計 Tokens - 從 Figma 提取的設計系統常數
///
/// 包含色彩、間距、圓角、文字樣式等設計標準
library;

import 'package:flutter/painting.dart';

/// 色彩系統 (從 Figma 設計系統提取)
class AppColors {
  AppColors._();

  // 主要品牌色
  static const Color primary = Color(0xFF86EFCC);

  // 背景色
  static const Color background = Color(0xFFF9FAFB);
  static const Color surface = Color(0xFFFFFFFF);

  // 文字色
  static const Color textPrimary = Color(0xFF0A0A0A);
  static const Color textSecondary = Color(0xFF354152);
  static const Color textTertiary = Color(0xFF495565);

  // 邊框色
  static const Color border = Color(0xFFD0D5DB);

  // 社交媒體品牌色
  static const Color facebook = Color(0xFF1877F2);

  // Google 四色
  static const Color googleBlue = Color(0xFF4285F4);
  static const Color googleGreen = Color(0xFF34A853);
  static const Color googleYellow = Color(0xFFFBBC05);
  static const Color googleRed = Color(0xFFEA4335);
}

/// 間距標準
class AppSpacing {
  AppSpacing._();

  static const double xs = 8.0;
  static const double sm = 12.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
}

/// 圓角標準
class AppRadius {
  AppRadius._();

  static const double button = 8.0;
  static const double container = 10.0;
}

/// 文字樣式標準
class AppTextStyles {
  AppTextStyles._();

  /// 主標題 (24px, Inter 400)
  static const TextStyle heading = TextStyle(
    fontFamily: 'Inter',
    fontSize: 24.0,
    fontWeight: FontWeight.w400,
    height: 32.0 / 24.0,
    letterSpacing: 0.07,
  );

  /// 強調標題 (30px, Inter 500)
  static const TextStyle headingEmphasis = TextStyle(
    fontFamily: 'Inter',
    fontSize: 30.0,
    fontWeight: FontWeight.w500,
    height: 36.0 / 30.0,
    letterSpacing: 0.40,
  );

  /// 按鈕文字 (14px, Inter 500)
  static const TextStyle button = TextStyle(
    fontFamily: 'Inter',
    fontSize: 14.0,
    fontWeight: FontWeight.w500,
    height: 20.0 / 14.0,
    letterSpacing: -0.15,
  );

  /// 次要文字 (16px, Inter 400)
  static const TextStyle body = TextStyle(
    fontFamily: 'Inter',
    fontSize: 16.0,
    fontWeight: FontWeight.w400,
    height: 24.0 / 16.0,
    letterSpacing: -0.31,
  );
}

/// 元件尺寸
class AppSizes {
  AppSizes._();

  // 按鈕尺寸
  static const double socialButtonWidth = 313.0;
  static const double socialButtonHeight = 56.0;

  // 圖示尺寸
  static const double logoutIconSize = 36.0;
}
