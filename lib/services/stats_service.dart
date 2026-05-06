import '../models/workout_record.dart';

class WorkoutStats {
  const WorkoutStats({
    required this.totalDays,
    required this.streak,
    required this.thisWeekCount,
  });

  final int totalDays;      // 성공 N일차 (첫 운동일부터 오늘까지 경과일 +1)
  final int streak;         // 연속 N일 운동 중
  final int thisWeekCount;  // 이번 주 N/7

  bool get hasData => totalDays > 0;

  static const empty = WorkoutStats(totalDays: 0, streak: 0, thisWeekCount: 0);
}

class StatsService {
  static WorkoutStats compute(List<WorkoutRecord> records) {
    if (records.isEmpty) return WorkoutStats.empty;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // 운동한 날짜 집합 (시간 제거)
    final uniqueDates = records
        .map((r) => DateTime(
            r.completedAt.year, r.completedAt.month, r.completedAt.day))
        .toSet();

    // 성공 N일차: 첫 운동일 ~ 오늘까지 달력 기준 경과일
    final firstDay = (uniqueDates.toList()..sort()).first;
    final totalDays = today.difference(firstDay).inDays + 1;

    // 연속 N일: 오늘부터 하루씩 거슬러 운동 여부 확인
    int streak = 0;
    DateTime check = today;
    while (uniqueDates.contains(check)) {
      streak++;
      check = check.subtract(const Duration(days: 1));
    }
    // 오늘 아직 운동 전이면 어제부터 역산 (동기 부여 유지)
    if (streak == 0) {
      check = today.subtract(const Duration(days: 1));
      while (uniqueDates.contains(check)) {
        streak++;
        check = check.subtract(const Duration(days: 1));
      }
    }

    // 이번 주 N회: 이번 주 월요일 ~ 오늘
    final weekStart = today.subtract(Duration(days: today.weekday - 1));
    final thisWeekCount = uniqueDates
        .where((d) => !d.isBefore(weekStart) && !d.isAfter(today))
        .length;

    return WorkoutStats(
      totalDays: totalDays,
      streak: streak,
      thisWeekCount: thisWeekCount,
    );
  }
}
