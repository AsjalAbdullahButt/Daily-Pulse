"""
Insights screen - AI-powered health analysis
"""
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/insights_service.dart';
import '../services/api_client.dart';

class InsightsScreen extends StatefulWidget {
  const InsightsScreen({super.key});
  @override
  State<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends State<InsightsScreen> {
  late final InsightsService _service;
  Map<String, dynamic>? _daily;
  Map<String, dynamic>? _weekly;
  Map<String, dynamic>? _habits;
  Map<String, dynamic>? _metrics;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _service = InsightsService(context.read<ApiClient>());
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final results = await Future.wait([
        _service.getDailySummary(),
        _service.getWeeklyInsight(),
        _service.getHabitAnalysis(),
        _service.getHealthMetrics(),
      ]);
      _daily = results[0];
      _weekly = results[1];
      _habits = results[2];
      _metrics = results[3];
    } catch (_) {}
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? const Center(child: CircularProgressIndicator())
        : RefreshIndicator(
            onRefresh: _load,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildSection('Today\'s Summary', _daily?['summary']),
                _buildSection('Weekly Insight', _weekly?['insight']),
                _buildSection('Habit Analysis', _habits?['analysis']),
                if (_metrics != null) Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Health Metrics', style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        )),
                        const SizedBox(height: 8),
                        _metricRow('BMI', '${_metrics!['bmi']?['bmi'] ?? '--'} (${_metrics!['bmi']?['category'] ?? '--'})'),
                        _metricRow('BMR', '${_metrics!['bmr'] ?? '--'} kcal/day'),
                        _metricRow('TDEE', '${_metrics!['tdee'] ?? '--'} kcal/day'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
  }

  Widget _buildSection(String title, String? content) {
    if (content == null || content.isEmpty) return const SizedBox.shrink();
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            )),
            const SizedBox(height: 8),
            Text(content, style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              height: 1.5,
            )),
          ],
        ),
      ),
    );
  }

  Widget _metricRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(value),
        ],
      ),
    );
  }
}
