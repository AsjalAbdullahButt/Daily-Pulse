"""
Habits screen - manage and track habit streaks
"""
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/habits_provider.dart';
import '../widgets/streak_badge.dart';

class HabitsScreen extends StatefulWidget {
  const HabitsScreen({super.key});
  @override
  State<HabitsScreen> createState() => _HabitsScreenState();
}

class _HabitsScreenState extends State<HabitsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<HabitsProvider>().loadHabits());
  }

  void _showAddDialog() {
    final ctrl = TextEditingController();
    String freq = 'daily';
    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: const Text('New Habit'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: ctrl,
                decoration: const InputDecoration(hintText: 'e.g. Drink 2L water'),
                autofocus: true,
              ),
              const SizedBox(height: 12),
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(value: 'daily', label: Text('Daily')),
                  ButtonSegment(value: 'weekly', label: Text('Weekly')),
                ],
                selected: {freq},
                onSelectionChanged: (s) => setDialogState(() => freq = s.first),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            FilledButton(
              onPressed: () {
                if (ctrl.text.trim().isNotEmpty) {
                  context.read<HabitsProvider>().createHabit(ctrl.text.trim(), frequency: freq);
                  Navigator.pop(ctx);
                }
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final habits = context.watch<HabitsProvider>();

    return Scaffold(
      body: habits.loading
          ? const Center(child: CircularProgressIndicator())
          : habits.habits.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('🎯', style: TextStyle(fontSize: 48)),
                      SizedBox(height: 12),
                      Text('No habits yet'),
                      Text('Tap + to start tracking', style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: habits.habits.length,
                  itemBuilder: (_, i) {
                    final h = habits.habits[i];
                    return Card(
                      child: ListTile(
                        leading: const Text('🔥', style: TextStyle(fontSize: 28)),
                        title: Text(h.habitName),
                        subtitle: Text(
                          '${h.targetFrequency ?? "daily"} • Best: ${h.bestStreak} days',
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            StreakBadge(currentStreak: h.currentStreak),
                            const SizedBox(width: 4),
                            IconButton(
                              icon: const Icon(Icons.delete_outline, size: 20),
                              onPressed: () => habits.deleteHabit(h.id),
                            ),
                          ],
                        ),
                        onTap: () => habits.completeHabit(h.id),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
