"""
Daily logs service - create, read, update, delete logs
"""
import '../models/daily_log.dart';
import 'api_client.dart';

class LogsService {
  final ApiClient _api;

  LogsService(this._api);

  // Fetch daily logs with optional date filters.
  Future<List<DailyLog>> getLogs({String? date, String? startDate, String? endDate}) async {
    final params = <String>[];
    if (date != null) params.add('date=$date');
    if (startDate != null) params.add('start_date=$startDate');
    if (endDate != null) params.add('end_date=$endDate');
    final q = params.isNotEmpty ? '?${params.join('&')}' : '';
    final data = await _api.getList('/api/logs/daily$q');
    return data.map((j) => DailyLog.fromJson(j)).toList();
  }

  // Get today's log.
  Future<DailyLog?> getToday() async {
    try {
      final data = await _api.get('/api/logs/daily/today');
      return DailyLog.fromJson(data);
    } catch (_) {
      return null;
    }
  }

  // Create or update a daily log.
  Future<DailyLog> saveLog(Map<String, dynamic> body) async {
    final data = await _api.post('/api/logs/daily', body);
    return DailyLog.fromJson(data);
  }

  // Update a specific daily log.
  Future<DailyLog> updateLog(String logId, Map<String, dynamic> body) async {
    final data = await _api.put('/api/logs/daily/$logId', body);
    return DailyLog.fromJson(data);
  }

  // Delete a daily log.
  Future<void> deleteLog(String logId) => _api.delete('/api/logs/daily/$logId');

  // Get weekly stats.
  Future<Map<String, dynamic>> getWeeklyStats() => _api.get('/api/logs/stats/weekly');
}
