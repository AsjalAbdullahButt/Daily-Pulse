"""
Date formatting utilities
"""
import 'package:intl/intl.dart';

String formatDate(DateTime dt) => DateFormat('MMM d, yyyy').format(dt);
String formatTime(DateTime dt) => DateFormat('h:mm a').format(dt);
String formatDateTime(DateTime dt) => DateFormat('MMM d, yyyy h:mm a').format(dt);
String formatRelative(DateTime dt) {
  final diff = DateTime.now().difference(dt);
  if (diff.inMinutes < 1) return 'just now';
  if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
  if (diff.inHours < 24) return '${diff.inHours}h ago';
  if (diff.inDays < 7) return '${diff.inDays}d ago';
  return formatDate(dt);
}
String formatDuration(int seconds) {
  final h = seconds ~/ 3600;
  final m = (seconds % 3600) ~/ 60;
  final s = seconds % 60;
  if (h > 0) return '${h}h ${m}m';
  if (m > 0) return '${m}m ${s}s';
  return '${s}s';
}
String formatPace(double minPerKm) {
  final min = minPerKm.floor();
  final sec = ((minPerKm - min) * 60).round();
  return '$min:${sec.toString().padLeft(2, '0')} /km';
}
