import 'package:flutter/material.dart';
import '../models/interval_program.dart';

// ─────────────────────────────────────────────────────────────────────────────
// AppColors — 러너스톡 컬러 토큰
//
// 원칙 (Apple Design System에서 채택):
//   • 인터랙티브 요소는 단 하나의 액센트(primary)만 사용
//   • 카드/버튼에 그림자 없음 — 테두리로만 구분
//   • 유일한 그림자는 feature 요소(로고 아이콘)에만 적용
// ─────────────────────────────────────────────────────────────────────────────
abstract final class AppColors {
  // ── 브랜드 액센트 ───────────────────────────────────────────────────────────
  // 모든 CTA, 포커스 링, 활성 상태의 유일한 색상
  static const primary = Color(0xFFFF6B35);         // Warm Orange
  static const primaryFocus = Color(0xFFFF8552);    // 포커스 링 (primary보다 밝음)
  static const primaryOnDark = Color(0xFFFF9A6E);   // 다크 타일 위 인라인 링크

  // ── 서피스 (다크 타일 시스템) ────────────────────────────────────────────────
  // 운동 중 야간 사용성을 위해 딥 네이비 기반 유지
  static const surfaceTile1 = Color(0xFF1A1A2E);   // 메인 배경
  static const surfaceTile2 = Color(0xFF21213A);   // 타일1보다 한 단계 밝음
  static const surfaceTile3 = Color(0xFF131325);   // 타일1보다 한 단계 어두움
  static const surfaceCard  = Color(0xFF252542);   // 카드 서피스
  static const surfaceBlack = Color(0xFF0A0A1A);   // 최심부

  // ── 텍스트 ──────────────────────────────────────────────────────────────────
  static const inkOnDark   = Color(0xFFFFFFFF);    // 다크 타일 기본 텍스트
  static const inkBody     = Color(0xFFE2E2EE);    // 한글 본문용 (순백보다 눈 편함)
  static const inkMuted    = Color(0xFF8892A4);    // 보조 텍스트
  static const inkFaint    = Color(0xFF50506A);    // 비활성 / 법적 고지

  // ── 테두리 / 구분선 ──────────────────────────────────────────────────────────
  static const hairline     = Color(0x14FFFFFF);   // rgba(255,255,255, 0.08)
  static const cardBorder   = Color(0x1AFFFFFF);   // rgba(255,255,255, 0.10)

  // ── 단계별 기능 색상 (운동 페이즈 식별용) ───────────────────────────────────────
  // 운동 중 한눈에 구별 가능하도록 채도 유지
  static const phaseWarmup   = Color(0xFF5BB8F5);  // 차분한 파랑 — 워밍업
  static const phaseRun      = Color(0xFFFF6B35);  // = primary — 달리기
  static const phaseWalk     = Color(0xFF52C77A);  // 상쾌한 초록 — 걷기
  static const phaseCooldown = Color(0xFFA78BFA);  // 부드러운 보라 — 쿨다운

  // ── 단계 색상 헬퍼 ──────────────────────────────────────────────────────────
  static Color forPhase(PhaseType type) => switch (type) {
        PhaseType.warmup   => phaseWarmup,
        PhaseType.run      => phaseRun,
        PhaseType.walk     => phaseWalk,
        PhaseType.cooldown => phaseCooldown,
      };

  // ── 특수 그림자 (단 하나 — 로고 아이콘/feature 요소 전용) ───────────────────────
  static const featureShadow = [
    BoxShadow(
      color: Color(0x44FF6B35),   // 브랜드 색 틴트 그림자
      blurRadius: 28,
      offset: Offset(0, 8),
    ),
  ];
}
