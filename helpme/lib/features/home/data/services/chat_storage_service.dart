import 'package:supabase_flutter/supabase_flutter.dart';

class ChatStorageService {
  final _supabase = Supabase.instance.client;

  Future<void> saveMessage({
    required String content,
    required String role,
  }) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return;

    await _supabase.from('chat_messages').insert({
      'user_id': userId,
      'content': content,
      'role': role,
    });
  }

  Future<List<Map<String, String>>> getChatHistory() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return [];

    final response = await _supabase
        .from('chat_messages')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: true);

    return (response as List).map((msg) {
      return {
        'role': msg['role'] as String,
        'content': msg['content'] as String,
      };
    }).toList();
  }
}
