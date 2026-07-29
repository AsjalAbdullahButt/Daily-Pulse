import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

class ApiClient {
  // Sends GET request and returns decoded JSON body.
  Future<Map<String, dynamic>> get(String path) async {
    final res = await http.get(Uri.parse('${ApiConfig.baseUrl}$path'));
    return jsonDecode(res.body) as Map<String, dynamic>;
  }

  // Sends POST request with JSON body, returns decoded response.
  Future<Map<String, dynamic>> post(String path, Map<String, dynamic> body) async {
    final res = await http.post(
      Uri.parse('${ApiConfig.baseUrl}$path'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
    return jsonDecode(res.body) as Map<String, dynamic>;
  }
}
