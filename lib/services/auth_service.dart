"""
Authentication service - register, login, token management
"""
import '../models/user.dart';
import 'api_client.dart';

class AuthService {
  final ApiClient _api;

  AuthService(this._api);

  // Register new user and return tokens + user.
  Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String name,
  }) async {
    final data = await _api.post('/api/auth/register', {
      'email': email,
      'password': password,
      'name': name,
    });
    _api.setToken(data['access_token'] as String?);
    return data;
  }

  // Login and return tokens + user.
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final data = await _api.post('/api/auth/login', {
      'email': email,
      'password': password,
    });
    _api.setToken(data['access_token'] as String?);
    return data;
  }

  // Refresh access token.
  Future<Map<String, dynamic>> refresh(String refreshToken) async {
    final data = await _api.post('/api/auth/refresh', {
      'refresh_token': refreshToken,
    });
    _api.setToken(data['access_token'] as String?);
    return data;
  }

  // Get current user profile.
  Future<User> getMe() async {
    final data = await _api.get('/api/auth/me');
    return User.fromJson(data);
  }

  // Update current user profile.
  Future<User> updateProfile(Map<String, dynamic> fields) async {
    final data = await _api.put('/api/auth/me', fields);
    return User.fromJson(data);
  }

  // Logout - clear stored token.
  void logout() => _api.setToken(null);
}
