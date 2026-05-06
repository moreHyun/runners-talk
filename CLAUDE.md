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

### 화면별 구현 상태

#### ✅ 홈 화면 (`home_screen.dart`, 198줄)
- 러너스톡 로고 + 오렌지 feature 그림자
- "오늘의 운동 시작" pill 버튼 → 코스 선택으로 이동
- 운동 기록 있을 때만 통계 카드 표시 (없으면 숨김)
  - 성공 N일차 / 연속 N일 운동 중 / 이번 주 N/7회
- 운동 완료 후 돌아오면 자동 통계 갱신

#### ✅ 코스 선택 화면 (`course_selection_screen.dart`, 172줄)
- 초보자 / 초급 / 중급 카드 리스트
- 난이도 pill 배지, 주차 정보, 설명 포함
- **⚠️ 미완성**: 초급·중급 탭 시 초보자 프로그램으로 fallback
  - `course_selection_screen.dart:14` — `_ => buildBeginnerProgram()`

#### ✅ 인터벌 타이머 화면 (`timer_screen.dart`, 463줄)
- 초보자 코스: 워밍업 5분 → (달리기 1분 + 걷기 1.5분) × 7세트 → 쿨다운 3분
- ▶/⏸ 수동 시작·일시정지 (자동 시작 없음 — 의도적)
- 상단 스크럽바: 탭·드래그로 구간 이동, 페이즈별 색상 (커스텀 `CustomPainter`)
- 세트 진행 표시 (1/7, 2/7...)
- 전체 남은 시간 AppBar 우측 표시
- 완료 → 축하 화면 → "홈으로" 누르면 스택 전체 pop (코스 선택 건너뜀)
- **⚠️ 미완성**: 페이즈 전환 시 음성/진동 알림 없음

#### ❌ 미구현 화면
- 운동 기록 히스토리 화면 (날짜별 목록)
- 코스 상세/소개 화면

### 동작하는 기능
| 기능 | 상태 | 비고 |
|---|---|---|
| 인터벌 타이머 (초보자) | ✅ 완전 동작 | |
| 구간 스크럽 (드래그/탭) | ✅ 완전 동작 | |
| 운동 기록 localStorage 저장 | ✅ 완전 동작 | 브라우저 새로고침 후에도 유지 |
| 홈 통계 카드 | ✅ 완전 동작 | |
| 디자인 시스템 토큰 | ✅ 완전 동작 | Pretendard CDN |
| 초급·중급 코스 | ⚠️ fallback | 초보자 프로그램으로 실행됨 |
| 페이즈 전환 알림 | ❌ 미구현 | 소리/진동 없음 |
| 운동 기록 히스토리 | ❌ 미구현 | 화면 없음 |
| Web 배포 | ❌ 미구현 | 로컬만 동작 |

### 외부 패키지
현재 `cupertino_icons`만 사용 중. 추가 패키지 없음.
Pretendard는 `web/index.html` CDN으로 로드 (디스크 사용 0).

### 다음 세션 추천 작업 (우선순위 순)

**1순위 — 초급·중급 코스 구현 (버그 수정)**
- `lib/models/interval_program.dart`에 `buildElementaryProgram()`, `buildIntermediateProgram()` 추가
- `course_selection_screen.dart:14` switch 케이스 채우기
- 빠르게 할 수 있고, 현재 버그성 fallback을 막음

**2순위 — 페이즈 전환 음성 알림**
- 브라우저 Web Audio API 직접 사용 (패키지 불필요)
- `dart:js_interop`으로 `window.speechSynthesis.speak()` 호출
- "달려요!" / "걸어요!" / "워밍업 시작!" / "잘했어요, 쿨다운!"
- UX 임팩트가 가장 큼 (화면 안 봐도 운동 가능)

**3순위 — 운동 기록 히스토리 화면**
- `WorkoutRecord` 리스트를 날짜 역순으로 표시
- 코스명, 운동 시간, 날짜 카드
- 동기 부여 요소 + "나 이만큼 했다" 확인

**4순위 — Web 배포 (GitHub Pages)**
- `flutter build web --no-tree-shake-icons`
- GitHub 저장소 생성 → `build/web` 폴더 배포
- 실제 사람에게 링크 공유 → MVP 검증 시작

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
