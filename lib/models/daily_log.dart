"""
DailyLog model mirroring backend schema
"""
class DailyLog {
  final String id;
  final String userId;
  final DateTime date;
  final int steps;
  final double? sleepHours;
  final int? sleepQuality;
  final int waterMl;
  final List<MealEntry>? meals;
  final String? mood;
  final String? notes;
  final int? caloriesConsumed;
  final int? caloriesBurned;

  const DailyLog({
    required this.id,
    required this.userId,
    required this.date,
    this.steps = 0,
    this.sleepHours,
    this.sleepQuality,
    this.waterMl = 0,
    this.meals,
    this.mood,
    this.notes,
    this.caloriesConsumed,
    this.caloriesBurned,
  });

  factory DailyLog.fromJson(Map<String, dynamic> j) => DailyLog(
    id: j['id'] as String,
    userId: j['user_id'] as String,
    date: DateTime.parse(j['date'] as String),
    steps: j['steps'] as int? ?? 0,
    sleepHours: (j['sleep_hours'] as num?)?.toDouble(),
    sleepQuality: j['sleep_quality'] as int?,
    waterMl: j['water_ml'] as int? ?? 0,
    meals: (j['meals'] as List?)?.map((m) => MealEntry.fromJson(m)).toList(),
    mood: j['mood'] as String?,
    notes: j['notes'] as String?,
    caloriesConsumed: j['calories_consumed'] as int?,
    caloriesBurned: j['calories_burned'] as int?,
  );

  Map<String, dynamic> toJson() => {
    'date': date.toIso8601String().split('T')[0],
    'steps': steps,
    'sleep_hours': sleepHours,
    'sleep_quality': sleepQuality,
    'water_ml': waterMl,
    'meals': meals?.map((m) => m.toJson()).toList(),
    'mood': mood,
    'notes': notes,
    'calories_consumed': caloriesConsumed,
    'calories_burned': caloriesBurned,
  };
}

class MealEntry {
  final String name;
  final String? time;
  final int? calories;
  final String? notes;

  const MealEntry({required this.name, this.time, this.calories, this.notes});

  factory MealEntry.fromJson(Map<String, dynamic> j) => MealEntry(
    name: j['name'] as String,
    time: j['time'] as String?,
    calories: j['calories'] as int?,
    notes: j['notes'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'name': name,
    'time': time,
    'calories': calories,
    'notes': notes,
  };
}
