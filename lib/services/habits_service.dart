"""
Habits service - manage habit streaks
"""
import '../models/habit_streak.dart';
import 'api_client.dart';

class HabitsService {
  final ApiClient _api;

  HabitsService(this._api);

  // Fetch all habits.
  Future<List<HabitStreak>> getHabits() async {
    final data = await _api.getList('/api/habits/');
    return data.map((j) => HabitStreak.fromJson(j)).toList();
  }

  // Create a new habit.
  Future<HabitStreak> createHabit(String name, {String frequency = 'daily'}) async {
    final data = await _api.post('/api/habits/', {
      'habit_name': name,
      'target_frequency': frequency,
    });
    return HabitStreak.fromJson(data);
  }

  // Mark a habit complete.
  Future<HabitStreak> completeHabit(String id) async {
    final data = await _api.post('/api/habits/$id/complete');
    return HabitStreak.fromJson(data);
  }

  // Delete a habit.
  Future<void> deleteHabit(String id) => _api.delete('/api/habits/$id');
}
