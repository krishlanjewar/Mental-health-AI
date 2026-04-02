import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/reddit_post_model.dart';

class RedditService {
  // Must look like a real browser to avoid Reddit blocking
  static const _userAgent =
      'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36';

  // All sources: public subreddit .json endpoints — always newest posts
  static const _sources = [
    'https://www.reddit.com/r/mentalhealth/new.json?limit=25&raw_json=1',
    'https://www.reddit.com/r/EngineeringStudents/new.json?limit=25&raw_json=1',
    'https://www.reddit.com/search.json?q=exam+stress&sort=new&t=week&limit=20&raw_json=1',
    'https://www.reddit.com/search.json?q=student+mental+health&sort=new&t=week&limit=20&raw_json=1',
  ];

  Future<List<RedditPost>> fetchAllPosts() async {
    final List<RedditPost> allPosts = [];
    final List<Future<List<RedditPost>>> futures =
        _sources.map((url) => _fetchFromUrl(url).catchError((_) => <RedditPost>[])).toList();

    final results = await Future.wait(futures);
    for (final posts in results) {
      allPosts.addAll(posts);
    }

    if (allPosts.isEmpty) {
      throw Exception(
          'Could not load posts. Reddit may be temporarily unavailable or blocking the request.');
    }

    // De-duplicate by id
    final seen = <String>{};
    final unique = allPosts.where((p) => seen.add(p.id)).toList();
    unique.sort((a, b) => b.createdUtc.compareTo(a.createdUtc));
    return unique;
  }

  Future<List<RedditPost>> fetchByCategory(String category) async {
    final urls = <String>[];
    switch (category) {
      case 'Mental Health':
        urls.add(
            'https://www.reddit.com/r/mentalhealth/new.json?limit=30&raw_json=1');
        urls.add(
            'https://www.reddit.com/r/anxiety/new.json?limit=15&raw_json=1');
        break;
      case 'Exam Stress':
        urls.add(
            'https://www.reddit.com/search.json?q=exam+stress+anxiety&sort=new&t=week&limit=30&raw_json=1');
        break;
      case 'Study Tips':
        urls.add(
            'https://www.reddit.com/search.json?q=study+tips+students&sort=new&t=week&limit=30&raw_json=1');
        urls.add(
            'https://www.reddit.com/r/GetStudying/new.json?limit=15&raw_json=1');
        break;
      case 'Engineering':
        urls.add(
            'https://www.reddit.com/r/EngineeringStudents/new.json?limit=30&raw_json=1');
        break;
      default:
        return fetchAllPosts();
    }

    final List<RedditPost> all = [];
    for (final url in urls) {
      try {
        all.addAll(await _fetchFromUrl(url));
      } catch (_) {}
    }

    if (all.isEmpty) {
      throw Exception('No posts found for "$category". Please try again.');
    }

    final seen = <String>{};
    final unique = all.where((p) => seen.add(p.id)).toList();
    unique.sort((a, b) => b.createdUtc.compareTo(a.createdUtc));
    return unique;
  }

  Future<List<RedditPost>> _fetchFromUrl(String url) async {
    final response = await http
        .get(
          Uri.parse(url),
          headers: {
            'User-Agent': _userAgent,
            'Accept': 'application/json',
          },
        )
        .timeout(const Duration(seconds: 20));

    if (response.statusCode == 429) {
      throw Exception('Rate limited by Reddit. Please wait and try again.');
    }

    if (response.statusCode == 403) {
      throw Exception('Reddit blocked the request (403).');
    }

    if (response.statusCode != 200) {
      throw Exception('Reddit error: HTTP ${response.statusCode}');
    }

    final decoded = jsonDecode(response.body);
    // Handle both search results and subreddit feeds
    dynamic listing;
    if (decoded is Map && decoded.containsKey('data')) {
      listing = decoded;
    } else {
      return [];
    }

    final children = listing['data']?['children'] as List<dynamic>? ?? [];
    return children
        .whereType<Map<String, dynamic>>()
        .map((c) {
          final data = c['data'];
          if (data == null) return null;
          return RedditPost.fromJson(data as Map<String, dynamic>);
        })
        .whereType<RedditPost>()
        .where((p) => p.title.isNotEmpty)
        .toList();
  }
}
