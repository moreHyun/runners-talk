import 'dart:convert';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import '../models/workout_record.dart';
import 'workout_repository.dart';

class LocalWorkoutRepository implements WorkoutRepository {
  static const _key = 'runners_talk_records';

  @override
  Future<void> save(WorkoutRecord record) async {
    final records = await getAll();
    records.add(record);
    html.window.localStorage[_key] =
        jsonEncode(records.map((r) => r.toJson()).toList());
  }

  @override
  Future<List<WorkoutRecord>> getAll() async {
    final raw = html.window.localStorage[_key];
    if (raw == null || raw.isEmpty) return [];
    try {
      final list = jsonDecode(raw) as List<dynamic>;
      return list
          .map((e) => WorkoutRecord.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }
}

// 의존성 주입 포인트: Firebase로 바꾸려면 이 한 줄만 교체
final WorkoutRepository workoutRepo = LocalWorkoutRepository();
