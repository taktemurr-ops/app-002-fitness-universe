import 'package:flutter_test/flutter_test.dart';
import 'package:fitness_universe/localized_duration.dart';

void main() {
  test('accepts Latin and Unicode decimal digits', () {
    expect(parseWorkoutMinutes('45'), 45);
    expect(parseWorkoutMinutes('٤٥'), 45);
    expect(parseWorkoutMinutes('۴۵'), 45);
    expect(parseWorkoutMinutes('४५'), 45);
    expect(parseWorkoutMinutes('４５'), 45);
  });

  test('rejects out of range, long and non-integer input', () {
    for (final value in ['', '0', '1441', '-2', '1.5', '1,000', '12x', '9' * 33]) {
      expect(parseWorkoutMinutes(value), isNull, reason: value);
    }
    expect(parseWorkoutMinutes('١٤٤٠'), 1440);
  });
}
