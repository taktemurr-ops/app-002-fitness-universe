import 'package:flutter_test/flutter_test.dart';
import 'package:fitness_universe/localized_duration.dart';

void main() {
  test('localized digits parse into bounded workout minutes', () {
    expect(parseWorkoutMinutes('120'), 120);
    expect(parseWorkoutMinutes('١٢٠'), 120);
    expect(parseWorkoutMinutes('۱۲۳'), 123);
    expect(parseWorkoutMinutes('१२३'), 123);
    expect(parseWorkoutMinutes('１２３'), 123);
    expect(parseWorkoutMinutes('1440'), 1440);
  });

  test('unsafe and ambiguous workout inputs are rejected', () {
    for (final input in ['', '0', '1441', '-1', '1.5', '1,000', 'abc', '9' * 33]) {
      expect(parseWorkoutMinutes(input), isNull, reason: input);
    }
  });
}
