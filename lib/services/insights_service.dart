"""
Insights service - AI-powered health analysis
"""
import 'api_client.dart';

class InsightsService {
  final ApiClient _api;

  InsightsService(this._api);

  // Get AI daily summary.
  Future<Map<String, dynamic>> getDailySummary({String? date}) async {
    final q = date != null ? '?target_date=$date' : '';
    return await _api.get('/api/insights/daily-summary$q');
  }

  // Get AI weekly insight.
  Future<Map<String, dynamic>> getWeeklyInsight({String? weekStart}) async {
    final q = weekStart != null ? '?week_start=$weekStart' : '';
    return await _api.get('/api/insights/weekly-insight$q');
  }

  // Get AI habit analysis.
  Future<Map<String, dynamic>> getHabitAnalysis() =>
      _api.get('/api/insights/habit-analysis');

  // Get health metrics (BMI, BMR, TDEE).
  Future<Map<String, dynamic>> getHealthMetrics() =>
      _api.get('/api/insights/health-metrics');
}
