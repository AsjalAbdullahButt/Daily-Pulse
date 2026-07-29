"""
RunningSession model mirroring backend schema
"""
class RunningSession {
  final String id;
  final String userId;
  final DateTime date;
  final double distanceKm;
  final double? avgPace;
  final double? maxSpeed;
  final int durationSeconds;
  final int? caloriesBurned;
  final double? elevationGain;
  final int? avgHeartRate;
  final String? notes;

  const RunningSession({
    required this.id,
    required this.userId,
    required this.date,
    required this.distanceKm,
    this.avgPace,
    this.maxSpeed,
    required this.durationSeconds,
    this.caloriesBurned,
    this.elevationGain,
    this.avgHeartRate,
    this.notes,
  });

  factory RunningSession.fromJson(Map<String, dynamic> j) => RunningSession(
    id: j['id'] as String,
    userId: j['user_id'] as String,
    date: DateTime.parse(j['date'] as String),
    distanceKm: (j['distance_km'] as num).toDouble(),
    avgPace: (j['avg_pace'] as num?)?.toDouble(),
    maxSpeed: (j['max_speed'] as num?)?.toDouble(),
    durationSeconds: j['duration_seconds'] as int,
    caloriesBurned: j['calories_burned'] as int?,
    elevationGain: (j['elevation_gain'] as num?)?.toDouble(),
    avgHeartRate: j['avg_heart_rate'] as int?,
    notes: j['notes'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'date': date.toIso8601String(),
    'distance_km': distanceKm,
    'duration_seconds': durationSeconds,
    'avg_pace': avgPace,
    'max_speed': maxSpeed,
    'calories_burned': caloriesBurned,
    'elevation_gain': elevationGain,
    'avg_heart_rate': avgHeartRate,
    'notes': notes,
  };
}
