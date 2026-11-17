import 'dart:convert';
import 'workout.dart';

/// Generates a portable JSON snapshot entirely on-device.
///
/// Call only after an explicit user export action. This function does not
/// transmit, upload, log or persist personal records.
String exportWorkoutHistory(Iterable<Workout> workouts) {
  return jsonEncode({
    'schemaVersion': 1,
    'exportedAtUtc': DateTime.now().toUtc().toIso8601String(),
    'workouts': workouts.map((entry) => entry.toJson()).toList(),
  });
}
