import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fitness_universe/workout_store.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('workouts persist, reload, and delete from local storage', () async {
    final store = WorkoutStore();
    await store.add('walking', 45);
    expect(store.totalMinutes, 45);
    final reloaded = WorkoutStore();
    await reloaded.load();
    expect(reloaded.workouts.single.activity, 'walking');
    await reloaded.clearAll();
    expect(reloaded.workouts, isEmpty);
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.containsKey(WorkoutStore.storageKey), isFalse);
  });

  test('invalid durations and unsupported activities are rejected', () async {
    final store = WorkoutStore();
    await expectLater(store.add('walking', 0), throwsArgumentError);
    await expectLater(store.add('running', 1441), throwsArgumentError);
    await expectLater(store.add('unknown', 30), throwsArgumentError);
    expect(store.workouts, isEmpty);
  });

  test('malformed saved data is preserved and not partially loaded', () async {
    SharedPreferences.setMockInitialValues({
      WorkoutStore.storageKey: jsonEncode([
        {'id': 'bad', 'activity': 'walking', 'minutes': 'not-an-int', 'timestamp': 'invalid'},
      ]),
    });
    final store = WorkoutStore();
    await store.load();
    expect(store.workouts, isEmpty);
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.containsKey(WorkoutStore.storageKey), isTrue);
  });
}
