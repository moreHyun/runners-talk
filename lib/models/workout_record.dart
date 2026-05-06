class WorkoutRecord {
  const WorkoutRecord({
    required this.courseId,
    required this.courseTitle,
    required this.completedAt,
    required this.durationSeconds,
    required this.phases,
  });

  final String courseId;
  final String courseTitle;
  final DateTime completedAt;
  final int durationSeconds; // 총 운동 시간(초)
  final List<String> phases; // 포함된 페이즈 종류 (예: ['워밍업','달리기','걷기','쿨다운'])

  factory WorkoutRecord.fromJson(Map<String, dynamic> json) => WorkoutRecord(
        courseId: json['courseId'] as String,
        courseTitle: json['courseTitle'] as String,
        completedAt: DateTime.parse(json['completedAt'] as String),
        durationSeconds: json['durationSeconds'] as int,
        phases: List<String>.from(json['phases'] as List),
      );

  Map<String, dynamic> toJson() => {
        'courseId': courseId,
        'courseTitle': courseTitle,
        'completedAt': completedAt.toIso8601String(),
        'durationSeconds': durationSeconds,
        'phases': phases,
      };
}
