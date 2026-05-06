import '../models/workout_record.dart';

// Firebase로 업그레이드할 때 이 인터페이스를 구현한 클래스만 추가하면 됩니다
abstract class WorkoutRepository {
  Future<void> save(WorkoutRecord record);
  Future<List<WorkoutRecord>> getAll();
}
