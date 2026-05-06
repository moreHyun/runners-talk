import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_spacing.dart';
import 'app_typography.dart';

// ─────────────────────────────────────────────────────────────────────────────
// AppTheme — Flutter MaterialApp용 ThemeData
//
// 이 파일 하나로 전체 앱의 Material 컴포넌트 기본 스타일이 결정됩니다.
// 스크린별 커스텀은 AppColors / AppTextStyles / AppButtonStyles 토큰을 직접 사용.
// ─────────────────────────────────────────────────────────────────────────────
abstract final class AppTheme {
  static ThemeData get dark {
    const scheme = ColorScheme(
      brightness: Brightness.dark,
      primary: AppColors.primary,
      onPrimary: AppColors.inkOnDark,
      secondary: AppColors.primaryOnDark,
      onSecondary: AppColors.inkOnDark,
      error: Color(0xFFFF5252),
      onError: AppColors.inkOnDark,
      surface: AppColors.surfaceTile1,
      onSurface: AppColors.inkOnDark,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.surfaceTile1,

      // ── 텍스트 테마 ─────────────────────────────────────────────────────────
      textTheme: const TextTheme(
        displayLarge:  AppTextStyles.heroDisplay,
        displayMedium: AppTextStyles.displayLg,
        displaySmall:  AppTextStyles.displayMd,
        headlineMedium: AppTextStyles.lead,
        titleMedium:   AppTextStyles.tagline,
        bodyLarge:     AppTextStyles.body,
        bodyMedium:    AppTextStyles.body,
        bodySmall:     AppTextStyles.caption,
        labelLarge:    AppTextStyles.buttonPrimary,
        labelSmall:    AppTextStyles.buttonUtility,
      ),

      // ── AppBar ─────────────────────────────────────────────────────────────
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.surfaceTile1,
        foregroundColor: AppColors.inkOnDark,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: AppTextStyles.bodyStrong,
      ),

      // ── ElevatedButton → primary pill ──────────────────────────────────────
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: AppButtonStyles.primary(),
      ),

      // ── TextButton → ghost 링크 ─────────────────────────────────────────────
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.inkMuted,
          textStyle: AppTextStyles.caption,
        ),
      ),

      // ── OutlinedButton → ghost pill ────────────────────────────────────────
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: AppButtonStyles.secondaryPill(),
      ),

      // ── Card ───────────────────────────────────────────────────────────────
      cardTheme: CardThemeData(
        color: AppColors.surfaceCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          side: const BorderSide(color: AppColors.cardBorder),
        ),
        margin: EdgeInsets.zero,
      ),

      // ── Divider ────────────────────────────────────────────────────────────
      dividerTheme: const DividerThemeData(
        color: AppColors.hairline,
        thickness: 1,
        space: 0,
      ),

      // ── ProgressIndicator ──────────────────────────────────────────────────
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primary,
        linearTrackColor: AppColors.surfaceCard,
      ),

      // ── Icon ───────────────────────────────────────────────────────────────
      iconTheme: const IconThemeData(color: AppColors.inkMuted),

      // ── SnackBar ──────────────────────────────────────────────────────────
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.surfaceCard,
        contentTextStyle: AppTextStyles.body,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
