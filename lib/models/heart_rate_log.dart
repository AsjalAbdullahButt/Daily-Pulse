"""
HeartRateLog model mirroring backend schema
"""
class HeartRateLog {
  final String id;
  final String userId;
  final DateTime timestamp;
  final int bpm;
  final String? source;
  final String? activity;

  const HeartRateLog({
    required this.id,
    required this.userId,
    required this.timestamp,
    required this.bpm,
    this.source,
    this.activity,
  });

  factory HeartRateLog.fromJson(Map<String, dynamic> j) => HeartRateLog(
    id: j['id'] as String,
    userId: j['user_id'] as String,
    timestamp: DateTime.parse(j['timestamp'] as String),
    bpm: j['bpm'] as int,
    source: j['source'] as String?,
    activity: j['activity'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'timestamp': timestamp.toIso8601String(),
    'bpm': bpm,
    'source': source,
    'activity': activity,
  };
}
