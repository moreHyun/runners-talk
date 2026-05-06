enum PhaseType { warmup, run, walk, cooldown }

class Phase {
  const Phase({
    required this.type,
    required this.durationSeconds,
    this.setIndex,
  });

  final PhaseType type;
  final int durationSeconds;
  final int? setIndex; // run/walk 페이즈에 몇 번째 세트인지

  String get label => switch (type) {
        PhaseType.warmup => '워밍업',
        PhaseType.run => '달리기',
        PhaseType.walk => '걷기',
        PhaseType.cooldown => '쿨다운',
      };

  String get emoji => switch (type) {
        PhaseType.warmup => '🚶',
        PhaseType.run => '🏃',
        PhaseType.walk => '🚶',
        PhaseType.cooldown => '😮‍💨',
      };

  bool get isRun => type == PhaseType.run;
}

class IntervalProgram {
  const IntervalProgram({
    required this.courseId,
    required this.phases,
    required this.totalSets,
  });

  final String courseId;
  final List<Phase> phases;
  final int totalSets;

  Duration get totalDuration => phases.fold(
        Duration.zero,
        (sum, p) => sum + Duration(seconds: p.durationSeconds),
      );
}

// 초보자 코스: 워밍업 5분 → (달리기 1분 + 걷기 1.5분) × 7세트 → 쿨다운 3분
IntervalProgram buildBeginnerProgram() {
  const sets = 7;
  final phases = <Phase>[
    const Phase(type: PhaseType.warmup, durationSeconds: 5 * 60),
    for (var i = 1; i <= sets; i++) ...[
      Phase(type: PhaseType.run, durationSeconds: 60, setIndex: i),
      Phase(type: PhaseType.walk, durationSeconds: 90, setIndex: i),
    ],
    const Phase(type: PhaseType.cooldown, durationSeconds: 3 * 60),
  ];
  return IntervalProgram(courseId: 'beginner', phases: phases, totalSets: sets);
}
