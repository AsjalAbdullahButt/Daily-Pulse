"""
Chat service - send messages and get history
"""
import '../models/chat.dart';
import 'api_client.dart';

class ChatService {
  final ApiClient _api;

  ChatService(this._api);

  // Send message to AI assistant.
  Future<ChatResponse> send(String message) async {
    final data = await _api.post('/api/chat/send', {'message': message});
    return ChatResponse.fromJson(data);
  }

  // Fetch chat history.
  Future<List<ChatResponse>> getHistory({int limit = 50}) async {
    final data = await _api.getList('/api/chat/history?limit=$limit');
    return data.map((j) => ChatResponse.fromJson(j)).toList();
  }
}
