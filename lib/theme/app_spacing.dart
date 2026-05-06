import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────────────────────
// AppSpacing — 간격 토큰 (8px 베이스 그리드)
// ─────────────────────────────────────────────────────────────────────────────
abstract final class AppSpacing {
  static const xxs     = 4.0;
  static const xs      = 8.0;
  static const sm      = 12.0;
  static const md      = 16.0;
  static const lg      = 24.0;
  static const xl      = 32.0;
  static const xxl     = 48.0;
  static const section = 64.0;  // 타일 섹션 상하 패딩 (Apple 80px → 운동앱 64px)
}

// ─────────────────────────────────────────────────────────────────────────────
// AppRadius — 둥글기 토큰
//
// 두 가지 문법:
//   • sm/md/lg → 유틸리티 카드, 아이콘 컨테이너
//   • pill     → 모든 CTA 버튼의 시그니처 형태 (Apple pill 문법 채택)
// ─────────────────────────────────────────────────────────────────────────────
abstract final class AppRadius {
  static const xs   = 6.0;
  static const sm   = 10.0;
  static const md   = 14.0;
  static const lg   = 20.0;    // 카드 기본
  static const pill = 9999.0;  // CTA 버튼, 배지, 검색창
}

// ─────────────────────────────────────────────────────────────────────────────
// AppButton — 버튼 스타일 팩토리
//
// 채택: Apple의 pill 버튼 문법
//   • 모든 primary CTA = pill (StadiumBorder)
//   • press 상태 = scale(0.95) 마이크로 인터랙션
// ─────────────────────────────────────────────────────────────────────────────
abstract final class AppButtonStyles {
  // 기본 CTA: 주황 pill
  static ButtonStyle primary({Color? backgroundColor}) => ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? const Color(0xFFFF6B35),
        foregroundColor: const Color(0xFFFFFFFF),
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 28),
        textStyle: const TextStyle(
          fontFamily: 'Pretendard Variable',
          fontSize: 17,
          fontWeight: FontWeight.w600,
        ),
      );

  // 보조 CTA: 테두리만 있는 ghost pill
  static ButtonStyle secondaryPill() => OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFFFF6B35),
        side: const BorderSide(color: Color(0xFFFF6B35)),
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 28),
        textStyle: const TextStyle(
          fontFamily: 'Pretendard Variable',
          fontSize: 17,
          fontWeight: FontWeight.w600,
        ),
      );

  // 유틸리티: 작은 둥글기, 서피스 bg
  static ButtonStyle utility() => ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF252542),
        foregroundColor: const Color(0xFFFFFFFF),
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          side: const BorderSide(color: Color(0x1AFFFFFF)),
        ),
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs, horizontal: 15),
        textStyle: const TextStyle(
          fontFamily: 'Pretendard Variable',
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      );
}
