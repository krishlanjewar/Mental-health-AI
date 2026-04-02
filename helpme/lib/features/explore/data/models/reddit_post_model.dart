class RedditPost {
  final String id;
  final String title;
  final String author;
  final String subreddit;
  final String selftext;
  final String url;
  final String? thumbnail;
  final int score;
  final int numComments;
  final int createdUtc;
  final String permalink;
  final bool isVideo;
  final String? postHint;

  RedditPost({
    required this.id,
    required this.title,
    required this.author,
    required this.subreddit,
    required this.selftext,
    required this.url,
    this.thumbnail,
    required this.score,
    required this.numComments,
    required this.createdUtc,
    required this.permalink,
    required this.isVideo,
    this.postHint,
  });

  factory RedditPost.fromJson(Map<String, dynamic> data) {
    final thumb = data['thumbnail'] as String?;
    final validThumb = (thumb != null &&
            thumb != 'self' &&
            thumb != 'default' &&
            thumb != 'nsfw' &&
            thumb.startsWith('http'))
        ? thumb
        : null;

    return RedditPost(
      id: data['id'] ?? '',
      title: data['title'] ?? '',
      author: data['author'] ?? 'unknown',
      subreddit: data['subreddit'] ?? '',
      selftext: data['selftext'] ?? '',
      url: data['url'] ?? '',
      thumbnail: validThumb,
      score: (data['score'] ?? 0) as int,
      numComments: (data['num_comments'] ?? 0) as int,
      createdUtc: (data['created_utc'] ?? 0).toInt(),
      permalink: data['permalink'] ?? '',
      isVideo: data['is_video'] ?? false,
      postHint: data['post_hint'],
    );
  }

  String get redditUrl => 'https://www.reddit.com$permalink';

  String get timeAgo {
    final now = DateTime.now();
    final created =
        DateTime.fromMillisecondsSinceEpoch(createdUtc * 1000);
    final diff = now.difference(created);

    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${(diff.inDays / 7).floor()}w ago';
  }
}
