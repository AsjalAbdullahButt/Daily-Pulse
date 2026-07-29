"""
Auth provider - manages authentication state
"""
import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../services/api_client.dart';
import '../services/auth_service.dart';

enum AuthState { initial, loading, authenticated, unauthenticated, error }

class AuthProvider extends ChangeNotifier {
  final ApiClient _client;
  late final AuthService _auth;

  AuthState _state = AuthState.initial;
  User? _user;
  String? _error;

  AuthState get state => _state;
  User? get user => _user;
  String? get error => _error;
  bool get isAuthenticated => _state == AuthState.authenticated;

  AuthProvider(this._client) : _auth = AuthService(_client);

  // Load saved tokens and validate session.
  Future<void> init(String? token, String? refreshToken) async {
    if (token == null) {
      _state = AuthState.unauthenticated;
      notifyListeners();
      return;
    }
    _client.setToken(token);
    try {
      _user = await _auth.getMe();
      _state = AuthState.authenticated;
    } catch (_) {
      if (refreshToken != null) {
        try {
          final data = await _auth.refresh(refreshToken);
          _user = User.fromJson(data['user']);
          _state = AuthState.authenticated;
        } catch (_) {
          _state = AuthState.unauthenticated;
        }
      } else {
        _state = AuthState.unauthenticated;
      }
    }
    notifyListeners();
  }

  // Register new user.
  Future<bool> register(String email, String password, String name) async {
    _state = AuthState.loading;
    _error = null;
    notifyListeners();
    try {
      final data = await _auth.register(email: email, password: password, name: name);
      _user = User.fromJson(data['user']);
      _state = AuthState.authenticated;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _state = AuthState.error;
      notifyListeners();
      return false;
    }
  }

  // Login with credentials.
  Future<bool> login(String email, String password) async {
    _state = AuthState.loading;
    _error = null;
    notifyListeners();
    try {
      final data = await _auth.login(email: email, password: password);
      _user = User.fromJson(data['user']);
      _state = AuthState.authenticated;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _state = AuthState.error;
      notifyListeners();
      return false;
    }
  }

  // Logout and clear state.
  void logout() {
    _auth.logout();
    _user = null;
    _state = AuthState.unauthenticated;
    notifyListeners();
  }
}
