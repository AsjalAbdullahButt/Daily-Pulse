"""
Streak badge widget for habit tracking
"""
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class StreakBadge extends StatelessWidget {
  final int currentStreak;
  final int bestStreak;

  const StreakBadge({
    super.key,
    required this.currentStreak,
    this.bestStreak = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _streakColor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _streakColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('🔥', style: const TextStyle(fontSize: 14)),
          const SizedBox(width: 4),
          Text(
            '$currentStreak',
            style: TextStyle(
              color: _streakColor,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Color get _streakColor {
    if (currentStreak >= 30) return AppColors.warning;
    if (currentStreak >= 7) return AppColors.success;
    return AppColors.primary;
  }
}
