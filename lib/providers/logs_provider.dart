"""
Logs provider - manages daily log state
"""
import 'package:flutter/foundation.dart';
import '../models/daily_log.dart';
import '../services/logs_service.dart';

class LogsProvider extends ChangeNotifier {
  final LogsService _service;

  List<DailyLog> _logs = [];
  DailyLog? _todayLog;
  Map<String, dynamic>? _weeklyStats;
  bool _loading = false;

  List<DailyLog> get logs => _logs;
  DailyLog? get todayLog => _todayLog;
  Map<String, dynamic>? get weeklyStats => _weeklyStats;
  bool get loading => _loading;

  LogsProvider(this._service);

  // Updates service when ApiClient changes.
  void _updateService(LogsService s) { _service = s; }

  // Load today's log.
  Future<void> loadToday() async {
    _loading = true;
    notifyListeners();
    _todayLog = await _service.getToday();
    _loading = false;
    notifyListeners();
  }

  // Load logs for a date range.
  Future<void> loadLogs({String? startDate, String? endDate}) async {
    _loading = true;
    notifyListeners();
    _logs = await _service.getLogs(startDate: startDate, endDate: endDate);
    _loading = false;
    notifyListeners();
  }

  // Save or update today's log.
  Future<void> saveLog(Map<String, dynamic> body) async {
    _loading = true;
    notifyListeners();
    _todayLog = await _service.saveLog(body);
    _loading = false;
    notifyListeners();
  }

  // Load weekly stats.
  Future<void> loadWeeklyStats() async {
    _weeklyStats = await _service.getWeeklyStats();
    notifyListeners();
  }
}
