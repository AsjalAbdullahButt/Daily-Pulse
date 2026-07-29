import 'dart:io' show Platform;

class ApiConfig {
  // Picks correct host per platform automatically.
  static String get baseUrl {
    if (Platform.isAndroid) return 'http://10.0.2.2:8000';
    return 'http://localhost:8000';
  }
}
