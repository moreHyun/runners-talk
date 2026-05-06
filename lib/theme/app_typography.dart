import 'package:flutter/material.dart';
import 'app_colors.dart';

// ─────────────────────────────────────────────────────────────────────────────
// AppTextStyles — 러너스톡 타이포그래피 토큰
//
// 폰트: Pretendard Variable (한글 최적화)
//   • 영문 SF Pro의 역할을 한국 시장에서 Pretendard가 담당
//   • macOS에서는 web/index.html의 CDN으로 로드됨
//
// 원칙 (Apple Design System에서 채택 + 한국어 적용):
//   • 디스플레이 크기는 약간 음수 자간으로 "타이트한" 느낌 연출
//   • 한글 본문 line-height = 1.65 (영문 1.47보다 높게 — 한글 가독성)
//   • 버튼 텍스트 = 15px/w600 (운동 중 오터치 방지)
//   • 타이머 숫자 = w200 (숫자 전용 — 날씬한 계측기 느낌)
//   • weight 사다리: 200 / 400 / 500 / 600 / 700 / 800
// ─────────────────────────────────────────────────────────────────────────────
abstract final class AppTextStyles {
  static const _font = 'Pretendard Variable';

  // ── 디스플레이 계층 ─────────────────────────────────────────────────────────
  // 타이트한 음수 자간 → "러너스톡 tight" 헤드라인 cadence
  static const heroDisplay = TextStyle(
    fontFamily: _font,
    fontSize: 36,
    fontWeight: FontWeight.w700,
    height: 1.15,
    letterSpacing: -0.5,
    color: AppColors.inkOnDark,
  );

  static const displayLg = TextStyle(
    fontFamily: _font,
    fontSize: 28,
    fontWeight: FontWeight.w700,
    height: 1.20,
    letterSpacing: -0.3,
    color: AppColors.inkOnDark,
  );

  static const displayMd = TextStyle(
    fontFamily: _font,
    fontSize: 22,
    fontWeight: FontWeight.w600,
    height: 1.25,
    letterSpacing: -0.2,
    color: AppColors.inkOnDark,
  );

  // ── 리드 / 서브헤드 ──────────────────────────────────────────────────────────
  static const lead = TextStyle(
    fontFamily: _font,
    fontSize: 18,
    fontWeight: FontWeight.w400,
    height: 1.55,
    letterSpacing: 0,
    color: AppColors.inkBody,
  );

  static const tagline = TextStyle(
    fontFamily: _font,
    fontSize: 15,
    fontWeight: FontWeight.w600,
    height: 1.40,
    letterSpacing: 0.1,
    color: AppColors.inkOnDark,
  );

  // ── 본문 ────────────────────────────────────────────────────────────────────
  // 한글 본문: 16px (영문 Apple 17px보다 1px 작게 — 한글 자소 크기 특성)
  static const body = TextStyle(
    fontFamily: _font,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.65,   // 한글 가독성을 위해 Apple 1.47보다 높게
    letterSpacing: 0.01,
    color: AppColors.inkBody,
  );

  static const bodyStrong = TextStyle(
    fontFamily: _font,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.40,
    letterSpacing: 0.01,
    color: AppColors.inkOnDark,
  );

  // ── 캡션 ────────────────────────────────────────────────────────────────────
  static const caption = TextStyle(
    fontFamily: _font,
    fontSize: 13,
    fontWeight: FontWeight.w400,
    height: 1.45,
    letterSpacing: 0,
    color: AppColors.inkMuted,
  );

  static const captionStrong = TextStyle(
    fontFamily: _font,
    fontSize: 13,
    fontWeight: FontWeight.w600,
    height: 1.30,
    letterSpacing: 0,
    color: AppColors.inkOnDark,
  );

  // ── 버튼 ────────────────────────────────────────────────────────────────────
  // 운동 중 빠른 인식을 위해 충분한 크기
  static const buttonPrimary = TextStyle(
    fontFamily: _font,
    fontSize: 17,
    fontWeight: FontWeight.w600,
    height: 1.0,
    letterSpacing: 0,
    color: AppColors.inkOnDark,
  );

  static const buttonUtility = TextStyle(
    fontFamily: _font,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.0,
    letterSpacing: 0,
    color: AppColors.inkOnDark,
  );

  // ── 운동 전용 ────────────────────────────────────────────────────────────────
  // 타이머 숫자: 큰 크기 + 얇은 weight = 계측기 느낌
  static const timerDisplay = TextStyle(
    fontFamily: _font,
    fontSize: 80,
    fontWeight: FontWeight.w200,
    letterSpacing: -3,
    height: 1.0,
    color: AppColors.inkOnDark,
  );

  // 페이즈 라벨: 운동 중 즉각 인식 (굵고 크게)
  static const phaseLabel = TextStyle(
    fontFamily: _font,
    fontSize: 26,
    fontWeight: FontWeight.w800,
    height: 1.0,
    letterSpacing: 0.5,
    color: AppColors.inkOnDark,
  );

  // ── 기타 ────────────────────────────────────────────────────────────────────
  static const finePrint = TextStyle(
    fontFamily: _font,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.40,
    letterSpacing: 0,
    color: AppColors.inkFaint,
  );
}
