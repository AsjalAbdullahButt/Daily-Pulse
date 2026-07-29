"""
ChatMessage and ChatResponse models mirroring backend schema
"""
class ChatResponse {
  final String id;
  final String response;
  final Map<String, dynamic>? extractedData;
  final DateTime timestamp;

  const ChatResponse({
    required this.id,
    required this.response,
    this.extractedData,
    required this.timestamp,
  });

  factory ChatResponse.fromJson(Map<String, dynamic> j) => ChatResponse(
    id: j['id'] as String,
    response: j['response'] as String,
    extractedData: j['extracted_data'] as Map<String, dynamic>?,
    timestamp: DateTime.parse(j['timestamp'] as String),
  );
}
