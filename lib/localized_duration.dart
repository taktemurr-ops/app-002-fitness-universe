/// Normalizes supported Unicode decimal digits for localized duration input.
/// Only decimal digits are accepted: signs, fractions and grouping are rejected.
int? parseWorkoutMinutes(String input) {
  final text = input.trim();
  if (text.isEmpty || text.length > 32) return null;
  final digits = StringBuffer();
  for (final rune in text.runes) {
    int? digit;
    if (rune >= 0x30 && rune <= 0x39) {
      digit = rune - 0x30;
    } else if (rune >= 0x0660 && rune <= 0x0669) {
      digit = rune - 0x0660;
    } else if (rune >= 0x06F0 && rune <= 0x06F9) {
      digit = rune - 0x06F0;
    } else if (rune >= 0x0966 && rune <= 0x096F) {
      digit = rune - 0x0966;
    } else if (rune >= 0xFF10 && rune <= 0xFF19) {
      digit = rune - 0xFF10;
    }
    if (digit == null) return null;
    digits.write(digit);
  }
  final value = int.tryParse(digits.toString());
  return value != null && value >= 1 && value <= 1440 ? value : null;
}
