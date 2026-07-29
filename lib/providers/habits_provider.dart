"""
Habits provider - manages habit streaks state
"""
import 'package:flutter/foundation.dart';
import '../models/habit_streak.dart';
import '../services/habits_service.dart';

class HabitsProvider extends ChangeNotifier {
  HabitsService _service;

  List<HabitStreak> _habits = [];
  bool _loading = false;

  List<HabitStreak> get habits => _habits;
  bool get loading => _loading;

  HabitsProvider(this._service);

  // Swaps service when API client changes.
  void _updateService(HabitsService s) { _service = s; }

  // Load all habits.
  Future<void> loadHabits() async {
    _loading = true;
    notifyListeners();
    _habits = await _service.getHabits();
    _loading = false;
    notifyListeners();
  }

  // Create a new habit.
  Future<void> createHabit(String name, {String frequency = 'daily'}) async {
    await _service.createHabit(name, frequency: frequency);
    await loadHabits();
  }

  // Mark habit complete.
  Future<void> completeHabit(String id) async {
    await _service.completeHabit(id);
    await loadHabits();
  }

  // Delete a habit.
  Future<void> deleteHabit(String id) async {
    await _service.deleteHabit(id);
    await loadHabits();
  }
}
