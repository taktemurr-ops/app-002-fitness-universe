import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitness_universe/privacy_export.dart';

void main() {
  test('offline export produces versioned portable JSON without records', () {
    final json = jsonDecode(exportWorkoutHistory([])) as Map<String, dynamic>;
    expect(json['schemaVersion'], 1);
    expect(DateTime.tryParse(json['exportedAtUtc'] as String), isNotNull);
    expect(json['exportedAtUtc'], endsWith('Z'));
    final records = json.entries.singleWhere((entry) =>
        entry.key != 'schemaVersion' && entry.key != 'exportedAtUtc');
    expect(records.value, isEmpty);
  });
}
