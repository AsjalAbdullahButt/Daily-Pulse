"""
Chat provider - manages chat messages state
"""
import 'package:flutter/foundation.dart';
import '../models/chat.dart';
import '../services/chat_service.dart';

class ChatProvider extends ChangeNotifier {
  ChatService _service;

  List<ChatResponse> _messages = [];
  bool _loading = false;
  String? _error;

  List<ChatResponse> get messages => _messages;
  bool get loading => _loading;
  String? get error => _error;

  ChatProvider(this._service);

  // Swaps service when API client changes.
  void _updateService(ChatService s) { _service = s; }

  // Load chat history from backend.
  Future<void> loadHistory() async {
    _loading = true;
    notifyListeners();
    try {
      _messages = await _service.getHistory();
    } catch (e) {
      _error = e.toString();
    }
    _loading = false;
    notifyListeners();
  }

  // Send message and append response.
  Future<void> send(String text) async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      final response = await _service.send(text);
      _messages.add(response);
    } catch (e) {
      _error = e.toString();
    }
    _loading = false;
    notifyListeners();
  }

  // Clear error state.
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
