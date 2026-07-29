"""
HabitStreak model mirroring backend schema
"""
class HabitStreak {
  final String id;
  final String userId;
  final String habitName;
  final int currentStreak;
  final int bestStreak;
  final DateTime? lastCompleted;
  final String? targetFrequency;
  final DateTime createdAt;

  const HabitStreak({
    required this.id,
    required this.userId,
    required this.habitName,
    this.currentStreak = 0,
    this.bestStreak = 0,
    this.lastCompleted,
    this.targetFrequency,
    required this.createdAt,
  });

  factory HabitStreak.fromJson(Map<String, dynamic> j) => HabitStreak(
    id: j['id'] as String,
    userId: j['user_id'] as String,
    habitName: j['habit_name'] as String,
    currentStreak: j['current_streak'] as int? ?? 0,
    bestStreak: j['best_streak'] as int? ?? 0,
    lastCompleted: j['last_completed'] != null
        ? DateTime.parse(j['last_completed'] as String)
        : null,
    targetFrequency: j['target_frequency'] as String?,
    createdAt: DateTime.parse(j['created_at'] as String),
  );

  Map<String, dynamic> toJson() => {
    'habit_name': habitName,
    'target_frequency': targetFrequency,
  };
}
