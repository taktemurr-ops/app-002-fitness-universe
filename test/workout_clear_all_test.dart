import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fitness_universe/workout_store.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('clearAll deletes persisted data and memory', () async {
    final store = WorkoutStore();
    await store.add('walking', 30);
    expect(store.workouts, isNotEmpty);
    await store.clearAll();
    expect(store.workouts, isEmpty);
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.containsKey(WorkoutStore.storageKey), isFalse);
    final reloaded = WorkoutStore();
    await reloaded.load();
    expect(reloaded.workouts, isEmpty);
  });
}
