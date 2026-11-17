class Workout {
  const Workout({required this.id, required this.activity, required this.minutes, required this.timestamp});
  final String id;
  final String activity;
  final int minutes;
  final DateTime timestamp;

  Map<String, dynamic> toJson() => {
    'id': id, 'activity': activity, 'minutes': minutes, 'timestamp': timestamp.toIso8601String(),
  };

  factory Workout.fromJson(Map<String, dynamic> data) {
    final minutes = (data['minutes'] as num).toInt();
    if (minutes < 1 || minutes > 1440) throw const FormatException('Invalid workout duration');
    return Workout(
      id: data['id'] as String,
      activity: data['activity'] as String,
      minutes: minutes,
      timestamp: DateTime.parse(data['timestamp'] as String),
    );
  }
}
