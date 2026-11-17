import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fitness_universe/workout.dart';
import 'package:fitness_universe/workout_store.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('workout round-trip preserves values', () {
    final original = Workout(id: 'one', activity: 'walking', minutes: 45, timestamp: DateTime.utc(2026, 11, 17));
    final restored = Workout.fromJson(original.toJson());
    expect(restored.id, 'one');
    expect(restored.minutes, 45);
    expect(restored.timestamp, original.timestamp);
  });

  test('store persists, reloads, and removes workouts', () async {
    final store = WorkoutStore();
    await store.add('walking', 30);
    await store.add('yoga', 20);
    expect(store.totalMinutes, 50);
    final restored = WorkoutStore();
    await restored.load();
    expect(restored.workouts.length, 2);
    expect(restored.totalMinutes, 50);
    await restored.remove(restored.workouts.first.id);
    final reloaded = WorkoutStore();
    await reloaded.load();
    expect(reloaded.workouts.length, 1);
  });

  test('invalid durations are rejected', () async {
    final store = WorkoutStore();
    await expectLater(store.add('running', 0), throwsArgumentError);
    await expectLater(store.add('running', 1441), throwsArgumentError);
  });

  test('corrupt JSON does not partially load records', () async {
    SharedPreferences.setMockInitialValues({WorkoutStore.storageKey: '[{"id":"bad"}]'});
    final store = WorkoutStore();
    await store.load();
    expect(store.workouts, isEmpty);
  });
}
