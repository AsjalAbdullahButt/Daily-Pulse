import 'package:flutter/foundation.dart';
import '../services/api_client.dart';

enum ConnectionState { checking, connected, failed }

class ConnectionProvider extends ChangeNotifier {
  final ApiClient _client = ApiClient();
  ConnectionState state = ConnectionState.checking;

  // Calls backend health endpoint and updates state.
  Future<void> checkConnection() async {
    try {
      final res = await _client.get('/health');
      state = res['status'] == 'healthy'
          ? ConnectionState.connected
          : ConnectionState.failed;
    } catch (_) {
      state = ConnectionState.failed; // catches any network or server error
    }
    notifyListeners();
  }
}
