import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'workout.dart';

class WorkoutStore extends ChangeNotifier {
  static const storageKey = 'fitness_workouts_v1';
  final List<Workout> _workouts = [];
  List<Workout> get workouts => List.unmodifiable(_workouts);
  int get totalMinutes => _workouts.fold(0, (sum, workout) => sum + workout.minutes);

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(storageKey);
    if (raw == null) return;
    try {
      final decoded = jsonDecode(raw) as List<dynamic>;
      final restored = decoded
          .map((item) => Workout.fromJson(Map<String, dynamic>.from(item as Map)))
          .toList()
        ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
      _workouts
        ..clear()
        ..addAll(restored);
      notifyListeners();
    } catch (_) {
      // Keep existing in-memory entries and preserve corrupt storage for recovery.
    }
  }

  Future<void> add(String activity, int minutes) async {
    if (minutes < 1 || minutes > 1440) throw ArgumentError.value(minutes, 'minutes');
    const allowed = {'walking', 'running', 'cycling', 'strength', 'yoga'};
    if (!allowed.contains(activity)) throw ArgumentError.value(activity, 'activity');
    final now = DateTime.now();
    _workouts.insert(0, Workout(
      id: '${now.microsecondsSinceEpoch}-${_workouts.length}',
      activity: activity,
      minutes: minutes,
      timestamp: now,
    ));
    notifyListeners();
    await _save();
  }

  Future<void> remove(String id) async {
    _workouts.removeWhere((workout) => workout.id == id);
    notifyListeners();
    await _save();
  }

  /// Deletes the locally stored workout history after explicit user consent.
  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    final removed = await prefs.remove(storageKey);
    if (!removed) throw StateError('Could not delete locally stored workouts');
    _workouts.clear();
    notifyListeners();
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    final success = await prefs.setString(storageKey, jsonEncode(_workouts.map((w) => w.toJson()).toList()));
    if (!success) throw StateError('Could not persist workouts');
  }
}
