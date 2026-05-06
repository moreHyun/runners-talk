# 러너스톡 (Runners Talk) — CLAUDE.md

## 프로젝트 개요
- **앱 이름**: 러너스톡 (Runners Talk)
- **컨셉**: "왕초보 러너 탈출 + 커플 같이 뛰기" — 친근하고 따뜻한 톤, 한국 사용자 타겟
- **핵심 기능**: 인터벌 타이머 (걷기/뛰기 반복), 코스 선택, 운동 기록 저장
- **개발 단계**: Flutter Web MVP → 검증 후 iOS/Android 확장

## 기술 스택
- **프레임워크**: Flutter (Dart)
- **초기 타겟**: Flutter Web (모바일 빌드 환경 없이 빠른 반복 개발)
- **상태 관리**: (미정 — 초기엔 StatefulWidget, 필요시 Riverpod 도입 검토)
- **추후 고려**: flutter_local_notifications, audioplayers, shared_preferences

## 개발 환경 제약
- MacBook M1
- **디스크 여유: 약 66GB** — Xcode/Android Studio 미설치 유지 방침
- Flutter Web 전용으로 시작, MVP 검증 후 모바일 환경 추가 예정
- Homebrew 미설치 상태 (Flutter SDK 직접 설치 방식 사용)

## 개발자 배경
- Java, Python 경험 있음
- 3년 정도 코딩 공백
- Flutter/Dart 첫 도전
- Java↔Dart 차이점, Flutter 개념 설명 필요할 때 짧게 요청

## 현재 폴더 구조
```
lib/
├── main.dart                          # 앱 진입점, AppTheme.dark 적용
├── theme/                             # 디자인 시스템 (전체 토큰)
│   ├── runners_theme.dart             # barrel export — 스크린에서 이것만 import
│   ├── app_colors.dart                # 색상 토큰 + AppColors.forPhase()
│   ├── app_typography.dart            # Pretendard 기반 텍스트 스타일
│   ├── app_spacing.dart               # 간격·둥글기·버튼 스타일(AppButtonStyles)
│   └── app_theme.dart                 # MaterialApp ThemeData
├── models/
│   ├── course.dart                    # Course, CourseLevel enum
│   ├── interval_program.dart          # Phase, PhaseType, IntervalProgram
│   └── workout_record.dart            # 저장 단위 (날짜·코스·시간·페이즈)
├── data/
│   └── courses.dart                   # kCourses 목록 (여기만 수정하면 코스 추가)
├── services/
│   ├── workout_repository.dart        # abstract 인터페이스 (Firebase 교체 포인트)
│   ├── local_workout_repository.dart  # localStorage 구현체 + workoutRepo 싱글톤
│   └── stats_service.dart             # 스트릭·주간횟수 계산 순수 로직
└── screens/
    ├── home_screen.dart               # 홈 (로고·통계카드·CTA)
    ├── course_selection_screen.dart   # 코스 선택 리스트
    └── timer_screen.dart              # 인터벌 타이머 + 스크럽바
web/
└── index.html                         # Pretendard CDN 링크 포함
```

## 진행 상황 (2026-05-07 기준)

### 완료된 것
- [x] Flutter Web 환경 설치 (`~/dev/flutter/`, PATH 등록)
- [x] 프로젝트 생성 (`flutter create . --platforms web`)
- [x] **홈 화면** — 러너스톡 로고, "오늘의 운동 시작" pill 버튼
- [x] **코스 선택 화면** — 초보자/초급/중급 카드 리스트 (확장 가능 구조)
- [x] **인터벌 타이머 화면**
  - 워밍업 5분 → (달리기 1분 + 걷기 1.5분) × 7세트 → 쿨다운 3분
  - ▶/⏸ 수동 시작/일시정지
  - 상단 스크럽바: 탭/드래그로 구간 이동, 페이즈별 색상 세그먼트
  - 페이즈 색상: 워밍업(파랑) / 달리기(오렌지) / 걷기(초록) / 쿨다운(보라)
  - 운동 완료 시 축하 화면 → "홈으로" 루트로 복귀
- [x] **운동 기록 저장** (localStorage, 로그인 없음)
  - 완료 날짜·시간, 코스명, 총 운동 시간, 페이즈 목록
- [x] **홈 통계 카드** — 성공 N일차 / 연속 N일 운동 / 이번 주 N/7회
- [x] **디자인 시스템** (`lib/theme/`)
  - Pretendard 폰트 (CDN, 디스크 0 사용)
  - 단일 액센트 오렌지 (#FF6B35), pill CTA, 그림자 없는 카드
  - `import '../theme/runners_theme.dart'` 한 줄로 전체 토큰 사용

### 다음 세션에서 할 것 (우선순위 순)
1. **음성/진동 알림** — 페이즈 전환 시 "달려요!", "걸어요!" 음성 안내
   - Flutter Web: `web_audio_api` 또는 `audioplayers` 패키지
   - 모바일 대비: 진동(`HapticFeedback`) 추가 예정
2. **초급·중급 코스 프로그램 구현** — `buildElementaryProgram()`, `buildIntermediateProgram()`
   - `lib/data/courses.dart`의 TODO 항목
3. **운동 기록 히스토리 화면** — 날짜별 운동 목록, 캘린더 뷰
4. **Web 배포** — GitHub Pages 또는 Firebase Hosting

### 알려진 미완료/TODO
- `course_selection_screen.dart`: 초급·중급 코스 탭 시 초보자 프로그램으로 fallback 중 (TODO 표시)
- 타이머 완료 후 페이즈 skip 시 `_secondsLeft`가 간헐적으로 0이 될 수 있음 (재현 미확인)
- 통계 "성공 N일차"는 첫 운동일~오늘 달력 기준 (운동 안 한 날도 포함)

## 주요 아키텍처 결정
- **Firebase 업그레이드 포인트**: `local_workout_repository.dart` 마지막 줄 한 줄만 교체
  ```dart
  final WorkoutRepository workoutRepo = LocalWorkoutRepository(); // → FirebaseWorkoutRepository()
  ```
- **코스 추가**: `lib/data/courses.dart`의 `kCourses` 리스트에 항목 추가 → UI 자동 반영
- **페이즈 색상**: `AppColors.forPhase(PhaseType)` — 색상 변경 시 이 한 곳만 수정
- 상태 관리: StatefulWidget 유지 (Riverpod는 복잡도 높아질 때 도입 검토)

## 개발 환경
- Flutter SDK: `~/dev/flutter/` (3.32.0, arm64)
- 실행: `flutter run -d chrome --web-port 8080`
- 빌드 확인: `flutter build web --no-tree-shake-icons`
- PATH 설정: `~/.zshrc`에 `export PATH="$HOME/dev/flutter/bin:$PATH"` 등록됨
