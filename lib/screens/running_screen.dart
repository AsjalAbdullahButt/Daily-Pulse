"""
Running screen - view and log running sessions
"""
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/running_service.dart';
import '../services/api_client.dart';
import '../models/running_session.dart';
import '../utils/formatters.dart';

class RunningScreen extends StatefulWidget {
  const RunningScreen({super.key});
  @override
  State<RunningScreen> createState() => _RunningScreenState();
}

class _RunningScreenState extends State<RunningScreen> {
  late final RunningService _service;
  List<RunningSession> _sessions = [];
  Map<String, dynamic>? _stats;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _service = RunningService(context.read<ApiClient>());
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      _sessions = await _service.getSessions();
      _stats = await _service.getStats();
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
                if (_stats != null) ...[
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _statItem('${_stats!['total_distance_km']} km', 'Total Distance'),
                          _statItem('${_stats!['total_sessions']}', 'Sessions'),
                          _statItem('${_stats!['avg_distance']} km', 'Avg Distance'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
                if (_sessions.isEmpty)
                  const Card(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Center(child: Text('No running sessions yet')),
                    ),
                  )
                else
                  ..._sessions.map((s) => Card(
                    child: ListTile(
                      leading: const Icon(Icons.directions_run),
                      title: Text('${s.distanceKm} km'),
                      subtitle: Text(
                        '${formatDuration(s.durationSeconds)} • ${s.avgPace != null ? formatPace(s.avgPace!) : '--'}',
                      ),
                      trailing: Text(
                        formatDate(s.date),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  )),
              ],
            ),
          );
  }

  Widget _statItem(String value, String label) {
    return Column(
      children: [
        Text(value, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 2),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}
