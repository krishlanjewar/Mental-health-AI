import 'package:supabase_flutter/supabase_flutter.dart';

class CommunityService {
  final _supabase = Supabase.instance.client;

  Future<void> createPost(String content) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) throw Exception("User not logged in");

    await _supabase.from('community_posts').insert({
      'user_id': userId,
      'content': content,
    });
  }

  Future<List<Map<String, dynamic>>> getPosts() async {
    final response = await _supabase
        .from('community_posts')
        .select()
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(response);
  }

  Future<void> giveSupport(String postId) async {
    // This is a simple implementation, in a real app you'd want a separate table for likes
    // to prevent double-liking, but for this anonymous MVP we'll just increment.
    final response = await _supabase
        .from('community_posts')
        .select('support_count')
        .eq('id', postId)
        .single();

    final currentCount = response['support_count'] as int;

    await _supabase
        .from('community_posts')
        .update({'support_count': currentCount + 1})
        .eq('id', postId);
  }
}
