"""
Dashboard screen - overview of today's health data
"""
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/logs_provider.dart';
import '../providers/habits_provider.dart';
import '../widgets/stat_card.dart';
import '../utils/formatters.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<LogsProvider>().loadToday();
      context.read<HabitsProvider>().loadHabits();
    });
  }

  @override
  Widget build(BuildContext context) {
    final logs = context.watch<LogsProvider>();
    final habits = context.watch<HabitsProvider>();
    final today = logs.todayLog;

    return RefreshIndicator(
      onRefresh: () async {
        await logs.loadToday();
        await habits.loadHabits();
      },
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Today, ${formatDate(DateTime.now())}',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            )),
          const SizedBox(height: 12),
          if (logs.loading)
            const Center(child: Padding(
              padding: EdgeInsets.all(32),
              child: CircularProgressIndicator(),
            ))
          else ...[
            Row(
              children: [
                Expanded(child: StatCard(
                  icon: Icons.directions_walk,
                  label: 'Steps',
                  value: '${today?.steps ?? 0}',
                  subtitle: 'Goal: 10,000',
                )),
                Expanded(child: StatCard(
                  icon: Icons.water_drop_outlined,
                  label: 'Water',
                  value: '${today?.waterMl ?? 0} ml',
                  subtitle: 'Goal: 2,500 ml',
                )),
              ],
            ),
            Row(
              children: [
                Expanded(child: StatCard(
                  icon: Icons.bedtime_outlined,
                  label: 'Sleep',
                  value: today?.sleepHours != null ? '${today!.sleepHours!.toStringAsFixed(1)}h' : '--',
                  subtitle: today?.sleepQuality != null ? 'Quality: ${today!.sleepQuality}/10' : null,
                )),
                Expanded(child: StatCard(
                  icon: Icons.mood_outlined,
                  label: 'Mood',
                  value: today?.mood ?? '--',
                  iconColor: _moodColor(today?.mood),
                )),
              ],
            ),
          ],
          const SizedBox(height: 16),
          Text('Active Habits', style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          )),
          const SizedBox(height: 8),
          if (habits.habits.isEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Center(child: Text(
                  'No habits yet. Tap + to add one!',
                  style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
                )),
              ),
            )
          else
            ...habits.habits.map((h) => Card(
              child: ListTile(
                leading: Text('🔥', style: const TextStyle(fontSize: 24)),
                title: Text(h.habitName),
                subtitle: Text('Streak: ${h.currentStreak} days • Best: ${h.bestStreak}'),
                trailing: IconButton(
                  icon: const Icon(Icons.check_circle_outline),
                  onPressed: () => habits.completeHabit(h.id),
                ),
              ),
            )),
        ],
      ),
    );
  }

  Color? _moodColor(String? mood) {
    switch (mood) {
      case 'happy': return Colors.green;
      case 'energetic': return Colors.orange;
      case 'sad': return Colors.blue;
      case 'anxious': return Colors.red;
      default: return null;
    }
  }
}
