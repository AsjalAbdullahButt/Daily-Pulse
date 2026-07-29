"""
ApiClient - shared HTTP wrapper for all services
"""
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

class ApiClient {
  String? _token;

  void setToken(String? token) => _token = token;

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    if (_token != null) 'Authorization': 'Bearer $_token',
  };

  // Sends GET request and returns decoded JSON body.
  Future<Map<String, dynamic>> get(String path) async {
    final res = await http.get(
      Uri.parse('${ApiConfig.baseUrl}$path'),
      headers: _headers,
    );
    return _handleResponse(res);
  }

  // Sends POST request with JSON body data.
  Future<Map<String, dynamic>> post(String path, [Map<String, dynamic>? body]) async {
    final res = await http.post(
      Uri.parse('${ApiConfig.baseUrl}$path'),
      headers: _headers,
      body: body != null ? jsonEncode(body) : null,
    );
    return _handleResponse(res);
  }

  // Sends PUT request with JSON body payload.
  Future<Map<String, dynamic>> put(String path, Map<String, dynamic> body) async {
    final res = await http.put(
      Uri.parse('${ApiConfig.baseUrl}$path'),
      headers: _headers,
      body: jsonEncode(body),
    );
    return _handleResponse(res);
  }

  // Sends DELETE request to remove resource.
  Future<void> delete(String path) async {
    final res = await http.delete(
      Uri.parse('${ApiConfig.baseUrl}$path'),
      headers: _headers,
    );
    if (res.statusCode >= 400) {
      throw ApiException(res.statusCode, _extractMessage(res.body));
    }
  }

  // Sends GET request and returns decoded list.
  Future<List<dynamic>> getList(String path) async {
    final res = await http.get(
      Uri.parse('${ApiConfig.baseUrl}$path'),
      headers: _headers,
    );
    if (res.statusCode >= 400) {
      throw ApiException(res.statusCode, _extractMessage(res.body));
    }
    return jsonDecode(res.body) as List<dynamic>;
  }

  Map<String, dynamic> _handleResponse(http.Response res) {
    if (res.statusCode >= 400) {
      throw ApiException(res.statusCode, _extractMessage(res.body));
    }
    if (res.statusCode == 204) return {};
    return jsonDecode(res.body) as Map<String, dynamic>;
  }

  String _extractMessage(String body) {
    try {
      final j = jsonDecode(body);
      return j['detail'] as String? ?? j['message'] as String? ?? 'Request failed';
    } catch (_) {
      return 'Request failed';
    }
  }
}

class ApiException implements Exception {
  final int statusCode;
  final String message;
  const ApiException(this.statusCode, this.message);

  @override
  String toString() => 'ApiException($statusCode): $message';
}
