import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitness_universe/privacy_export.dart';
import 'package:fitness_universe/workout.dart';

void main() {
  test('export round-trips Unicode activity, duration and timestamp', () {
    final at = DateTime.utc(2026, 11, 17, 9, 15);
    final workout = Workout(
      id: 'antrenman-١', activity: 'Yürüyüş 🚶', minutes: 45, timestamp: at,
    );
    final payload = jsonDecode(exportWorkoutHistory([workout])) as Map<String, dynamic>;
    final records = payload['workouts'] as List<dynamic>;
    expect(records.length, 1);
    final restored = Workout.fromJson(Map<String, dynamic>.from(records.single as Map));
    expect(restored.id, workout.id);
    expect(restored.activity, workout.activity);
    expect(restored.minutes, workout.minutes);
    expect(restored.timestamp, at);
  });

  test('export has a stable minimal versioned schema', () {
    final payload = jsonDecode(exportWorkoutHistory([])) as Map<String, dynamic>;
    expect(payload.keys.toSet(), {'schemaVersion', 'exportedAtUtc', 'workouts'});
    expect(payload['schemaVersion'], 1);
    expect(payload['workouts'], isEmpty);
  });
}
