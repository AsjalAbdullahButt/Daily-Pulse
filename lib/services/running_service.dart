"""
Running service - manage running/jogging sessions
"""
import '../models/running_session.dart';
import 'api_client.dart';

class RunningService {
  final ApiClient _api;

  RunningService(this._api);

  // Fetch running sessions.
  Future<List<RunningSession>> getSessions({int limit = 50}) async {
    final data = await _api.getList('/api/running/sessions?limit=$limit');
    return data.map((j) => RunningSession.fromJson(j)).toList();
  }

  // Create a running session.
  Future<RunningSession> createSession(Map<String, dynamic> body) async {
    final data = await _api.post('/api/running/sessions', body);
    return RunningSession.fromJson(data);
  }

  // Delete a running session.
  Future<void> deleteSession(String id) => _api.delete('/api/running/sessions/$id');

  // Get running stats.
  Future<Map<String, dynamic>> getStats() => _api.get('/api/running/stats');
}
